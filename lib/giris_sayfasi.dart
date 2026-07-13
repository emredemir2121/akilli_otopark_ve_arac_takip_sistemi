import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'hizmet_gizlilik.dart';  // Hizmet ve Gizlilik sayfalarını import et

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          SizedBox.expand(
            child: Image.asset(
              'assets/background.jpg',  // Buraya kendi arka plan resminin yolunu yaz
              fit: BoxFit.cover,        // Ekranı tamamen kaplar, orantıyı korur
            ),
          ),
          // Üzerinde login içeriği, biraz saydamlık için Container ile renk filtresi ekleyebilirsin
          Container(
            color: Colors.white.withOpacity(0.85), // Beyaz ve hafif saydam arka plan (isteğe göre ayarla)
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png'),
                      const SizedBox(height: 30),
                      const Text(
                        'Kampüs Otopark Sistemi',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Üniversite mailiniz ile giriş yapınız!',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.blue[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Şifre',
                          filled: true,
                          fillColor: Colors.blue[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                            // Giriş başarılıysa yönlendirme ekleyebilirsin
                          } on FirebaseAuthException catch (e) {
                            debugPrint('FirebaseAuthException → ${e.code}: ${e.message}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: ${e.message}')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Giriş Yap'),
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          children: [
                            const TextSpan(text: 'Giriş Yap’a tıklayarak '),
                            TextSpan(
                              text: 'Hizmet Şartlarımızı',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HizmetSartlariPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' ve '),
                            TextSpan(
                              text: 'Gizlilik Politikamızı',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const GizlilikPolitikasiPage(),
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(text: ' kabul etmiş olursunuz.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
