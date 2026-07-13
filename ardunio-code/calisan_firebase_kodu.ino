#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <HCSR04.h>

// Wi-Fi bilgileri
#define WIFI_SSID "realme 5i"
#define WIFI_PASSWORD "as123456"

// Firebase bilgileri
#define API_KEY "AIzaSyA4cfu2FYYf_NJgoaj5D0t9L48sRA1rC5k"
#define DATABASE_URL "https://otopark-sistemi-cd3ec-default-rtdb.europe-west1.firebasedatabase.app/"

// Firebase nesneleri
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// HC-SR04 sensör (trig=14, echo=27)
UltraSonicDistanceSensor distanceSensor(33, 35);

void setup() {
  Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Wi-Fi bağlanıyor");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("\nWi-Fi bağlantısı tamamlandı.");

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Burada kullanıcı bilgilerini gir
  auth.user.email = "admin@isik.edu.tr";
  auth.user.password = "123456";

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}


void loop() {
  // Mesafe ölçümü (cm)
  float distance = distanceSensor.measureDistanceCm();
  Serial.print("Ölçülen mesafe: ");
  Serial.print(distance);
  Serial.println(" cm");

  // Durumu belirle
  String p1Durum = (distance <= 15.0) ? "Dolu" : "Boş";

  // Firebase'e sadece /otopark_listesi/P1 verisini güncelle
  if (Firebase.RTDB.setString(&fbdo, "/otopark_listesi/P1", p1Durum)) {
    Serial.println("Firebase güncellendi: P1 -> " + p1Durum);
  } else {
    Serial.print("Firebase güncellenemedi: ");
    Serial.println(fbdo.errorReason());
  }

  delay(2000); // 5 saniye bekle ve tekrar ölç
}
