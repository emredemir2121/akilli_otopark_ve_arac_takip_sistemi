import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:untitled7/profile.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final db = FirebaseDatabase.instance.ref();

  Map<String, dynamic> kullanicilar = {};
  Map<String, String> parkDurumlari = {};

  static const Map<String, Offset> _spotOffsets = {
    'P4': Offset(0.65, 0.134),
    'P1': Offset(0.05, 0.135),
    'P3': Offset(0.05, 0.382),
    'P2': Offset(0.65, 0.380),
  };

  @override
  void initState() {
    super.initState();

    db.child('kullanicilar').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() => kullanicilar = data
            .map((k, v) => MapEntry(k.toString(), v as Map<dynamic, dynamic>)));
      }
    });

    db.child('otopark_listesi').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() => parkDurumlari = data
            .map((k, v) => MapEntry(k.toString(), v.toString()))
            .map((k, v) => MapEntry(k, v)));
      }
    });
  }

  Color renkSecici(String durum) {
    final d = durum.toLowerCase();

    if (d == 'dolu') return Colors.red;
    if (d == 'boş' || d == 'bos') return Colors.green;
    return Colors.grey;
  }

  Widget _buildParkingMap() {
    return AspectRatio(
      aspectRatio: 1232 / 1340,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/otopark1.png',
                  fit: BoxFit.cover,
                ),
              ),
              ...parkDurumlari.entries.map((e) {
                final offset = _spotOffsets[e.key] ?? Offset.zero;
                final width = constraints.maxWidth * 0.30;
                final height = constraints.maxHeight * 0.23;

                return Positioned(
                  left: offset.dx * constraints.maxWidth,
                  top: offset.dy * constraints.maxHeight,
                  child: Container(
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: renkSecici(e.value).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${e.key}: ${e.value.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    final duyurular = [
      "⚠️ LPG'li araçların otopark alanına girmesi yasaktır",
      '🆕 P4 park alanı sadece engelli araç sürücülerinin kullanımına açılmıştır.',

    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Bilgilendirme',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        ...duyurular.map((duyuru) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.campaign, color: Colors.blue),
            title: Text(
              duyuru,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Kampüs Otopark'),
        backgroundColor: Colors.blue,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (currentUserEmail != null) ...[
              const SizedBox(height: 8),
              ...kullanicilar.values
                  .where((u) => u['email'] == currentUserEmail)
                  .map((u) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merhaba, ${u['ad']}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        )),
                  ],
                );
              }),
            ],
            const SizedBox(height: 24),
            const Text(
              textAlign: TextAlign.center,
              'Güncel Otopark Durumu',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),
            _buildParkingMap(),


            /// ⬇️ Duyurular bölümü eklendi
            _buildAnnouncementsSection(),
          ],
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
              onTap: () {},
              child: const Icon(Icons.home, size: 30),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: const Icon(Icons.account_circle, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
