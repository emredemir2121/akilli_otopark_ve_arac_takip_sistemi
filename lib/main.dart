import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:untitled7/firebase_options.dart';
import 'package:untitled7/Anasayfa.dart';
import 'package:untitled7/adminPage.dart';
import 'package:untitled7/giris_sayfasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Kullanıcının admin olup olmadığını kontrol eder.
  Future<bool> isAdmin(String? userEmail) async {
    if (userEmail == null) return false;

    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot = await dbRef.child('kullanicilar/admin/email').get();

    if (snapshot.exists && snapshot.value == userEmail) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Giriş durumu kontrol ediliyor
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Giriş yapılmışsa
          if (snapshot.hasData) {
            final email = snapshot.data!.email;

            return FutureBuilder<bool>(
              future: isAdmin(email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                if (snapshot.hasData && snapshot.data == true) {
                  return const AdminPage(); // Admin mail eşleştiyse
                } else {
                  return const Anasayfa(); // Normal kullanıcı
                }
              },
            );
          }

          // Giriş yapılmamışsa
          return const LoginScreen();
        },
      ),
    );
  }
}
