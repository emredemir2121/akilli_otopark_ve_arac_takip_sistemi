import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled7/anasayfa.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final db = FirebaseDatabase.instance.ref();

  bool isLoading = true;
  String? ad;
  String? email;
  String? telefon;
  String? plaka;


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final snap = await db.child('kullanicilar').get();
    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);

      for (final entry in data.entries) {
        final userData = Map<String, dynamic>.from(entry.value);
        if ((userData['email'] ?? '').toString().toLowerCase() ==
            currentUser.email!.toLowerCase()) {
          setState(() {
            ad = userData['ad'] ?? '-';
            email = userData['email'] ?? '-';
            telefon = userData['telefon'] ?? '-';
            plaka = userData['plaka'] ?? '-';

            isLoading = false;
          });
          return;
        }
      }
    }

    setState(() {
      ad = '-';
      email = '-';
      telefon = '-';
      plaka = '-';
      isLoading = false;
    });
  }

  Widget infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        label,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Profil Sayfası'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout , color: Colors.white,),
            tooltip: 'Çıkış Yap',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Çıkış yapıldı')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Kullanıcı Bilgileri',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.5),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30, horizontal: 20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ad ?? '-',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 30),
                      infoTile(Icons.email, 'Email', email ?? '-'),
                      infoTile(Icons.phone, 'Telefon', telefon ?? '-'),
                      infoTile(Icons.car_repair, 'Plaka', plaka ?? '-'),


                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  children: [

                    const TextSpan(text: 'Bilgileriniz güncelse hiçbir işlem yapmanıza gerek yok.\n'),
                    const TextSpan(text: 'Eğer bilgileriniz güncel değilse lütfen '),

                    TextSpan(
                      text: 'admin@isik.edu.tr',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'admin@isik.edu.tr',
                            query: Uri.encodeQueryComponent('subject=Profil Bilgisi Güncelleme'),
                          );
                          await launchUrl(emailLaunchUri);
                        },
                    ),
                    const TextSpan(text: ' ile iletişime geçiniz.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        elevation: 8,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const Anasayfa()),
                );
              },
              child: const Icon(Icons.home, size: 30),
            ),
          ),
          const BottomNavigationBarItem(
            label: '',
            icon: const Icon(Icons.account_circle, size: 30),
          ),
        ],
      ),
    );
  }
}
