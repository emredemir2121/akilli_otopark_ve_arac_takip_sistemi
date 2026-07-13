import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final db = FirebaseDatabase.instance.ref();
  bool isAdmin = false;
  bool isLoading = true;
  String? userName;

  Map<String, dynamic> otoparkListesi = {};
  Map<String, dynamic> kullanicilar = {};

  final _newUserKeyController = TextEditingController();
  final _newUserNameController = TextEditingController();
  final _newUserEmailController = TextEditingController();
  final _newUserPasswordController = TextEditingController();
  final _newUserPlakaController = TextEditingController();
  final _newUserPhoneController = TextEditingController(); // 📱 Eklendi

  @override
  void initState() {
    super.initState();
    checkIfAdmin();
  }

  @override
  void dispose() {
    _newUserKeyController.dispose();
    _newUserNameController.dispose();
    _newUserEmailController.dispose();
    _newUserPasswordController.dispose();
    _newUserPlakaController.dispose();
    _newUserPhoneController.dispose(); // 📱 Eklendi
    super.dispose();
  }

  Future<void> checkIfAdmin() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snap = await db.child('kullanicilar').get();
      final data = snap.value as Map?;
      if (data != null) {
        for (final entry in data.entries) {
          final userData = Map<String, dynamic>.from(entry.value);
          final isSameMail = (userData['email'] ?? '').toString().toLowerCase() ==
              currentUser.email!.toLowerCase();
          final isKeyAdmin = entry.key.toString() == 'admin';

          if (isSameMail && isKeyAdmin) {
            setState(() {
              isAdmin = true;
              userName = userData['ad'] ?? 'Admin';
            });
            await loadData(); // Admin ise verileri yükle
            break;
          }
        }
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> loadData() async {
    final otoparkSnap = await db.child('otopark_listesi').get();
    if (otoparkSnap.exists) {
      otoparkListesi = Map<String, dynamic>.from(otoparkSnap.value as Map);
    }
    final kullaniciSnap = await db.child('kullanicilar').get();
    if (kullaniciSnap.exists) {
      kullanicilar = Map<String, dynamic>.from(kullaniciSnap.value as Map);
    }
    setState(() {});
  }

  Future<void> updateOtopark(String parkYeri, String durum) async {
    await db.child('otopark_listesi/$parkYeri').set(durum);
    setState(() {
      otoparkListesi[parkYeri] = durum;
    });
  }

  Future<void> deleteUser(String key) async {
    await db.child('kullanicilar/$key').remove();
    kullanicilar.remove(key);
    setState(() {});
  }

  Future<void> addUserWithAuth(
      String email,
      String password,
      String key,
      Map<String, dynamic> userData,
      ) async {
    try {
      await db.child('kullanicilar/$key').set(userData);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      kullanicilar[key] = userData;
      setState(() {});
    } on FirebaseAuthException catch (e) {
      await db.child('kullanicilar/$key').remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı oluşturulamadı: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Bu sayfaya erişim yetkiniz yok.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Paneli',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Text(
                  'Hoş geldiniz, $userName 👋',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text('Otopark Durumları:',
                style: Theme.of(context).textTheme.titleLarge),
            ...otoparkListesi.entries.map((e) {
              return ListTile(
                title: Text('${e.key} - Durum: ${e.value}'),
                trailing: DropdownButton<String>(
                  value: e.value.toString(),
                  items: ['Bos', 'Dolu', 'ENGELLİ'].map((durum) {
                    return DropdownMenuItem(
                      value: durum,
                      child: Text(durum),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) updateOtopark(e.key, val);
                  },
                ),
              );
            }).toList(),
            const Divider(height: 40),
            Text('Kullanıcılar:', style: Theme.of(context).textTheme.titleLarge),
            ...kullanicilar.entries.map((e) {
              final user = Map<String, dynamic>.from(e.value);
              return ListTile(
                title: Text('${user['ad']} (${user['email']})'),
                subtitle: Text(
                  'Plaka: ${user['plaka'] ?? '-'}\nTelefon: ${user['telefon'] ?? '-'}',
                ),
                trailing: e.key != 'admin'
                    ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteUser(e.key),
                )
                    : null,
              );
            }).toList(),
            const Divider(height: 40),
            Text('Yeni Kullanıcı Ekle:',
                style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _newUserKeyController,
              decoration: const InputDecoration(labelText: 'Kullanıcı Key (ör: user4)'),
            ),
            TextField(
              controller: _newUserNameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            TextField(
              controller: _newUserPhoneController,
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
            ),
            TextField(
              controller: _newUserEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _newUserPasswordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,

            ),
            TextField(
              controller: _newUserPlakaController,
              decoration: const InputDecoration(labelText: 'Plaka (Opsiyonel)'),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final key = _newUserKeyController.text.trim();
                final ad = _newUserNameController.text.trim();
                final email = _newUserEmailController.text.trim();
                final password = _newUserPasswordController.text.trim();
                final plaka = _newUserPlakaController.text.trim();
                final phone = _newUserPhoneController.text.trim();

                if (key.isEmpty || ad.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Lütfen tüm zorunlu alanları doldurun!')),
                  );
                  return;
                }

                await addUserWithAuth(email, password, key, {
                  'ad': ad,
                  'email': email,
                  if (plaka.isNotEmpty) 'plaka': plaka,
                  if (phone.isNotEmpty) 'telefon': phone,
                });

                _newUserKeyController.clear();
                _newUserNameController.clear();
                _newUserEmailController.clear();
                _newUserPasswordController.clear();
                _newUserPlakaController.clear();
                _newUserPhoneController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kullanıcı başarıyla eklendi!')),
                );

                const adminEmail = 'admin@isik.edu.tr';
                const adminPassword = '123456';

                await FirebaseAuth.instance.signOut();

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: adminEmail,
                    password: adminPassword,
                  );

                  if (!mounted) return;

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AdminPage()),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Admin olarak tekrar giriş yapılamadı: ${e.message}')),
                  );
                }
              },
              child: const Text('Kullanıcı Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
