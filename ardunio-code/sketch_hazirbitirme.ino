#include <SPI.h>
#include <Wire.h>
#include <MFRC522.h>
#include <LiquidCrystal_I2C.h>
#include <ESP32Servo.h>
#include <HCSR04.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h> // FİREBASE KÜTÜPHANESİNİ EKLİYORUZ
#include <time.h> // Giriş satti gösterebilmek için


 

// Wi-Fi bilgilerini buraya yazıyoruz
const char* ssid = "OPPO A52";
const char* password = "gh123456";



// FİREBASE BİLGİLERİNİ EKLEDİK
#define API_KEY "AIzaSyA4cfu2FYYf_NJgoaj5D0t9L48sRA1rC5k"
#define DATABASE_URL "https://otopark-sistemi-cd3ec-default-rtdb.europe-west1.firebasedatabase.app/"


// FİREBASE NESNELERİNİ EKLİYORUZ Kİ AUTHANTİCATE İSLEMLLERİ VE GÖNDERME İŞLEMİ YAPILIYIOR MU YAPILMIYOR MU BAKABİLELİM
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;



// NTP Sunucu ve saat dilimi ayarları (Türkiye için)
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 3 * 3600; // Türkiye GMT+3
const int daylightOffset_sec = 0;


#define SS_PIN 5
#define RST_PIN 4

// Park yeri sensörleri
#define TRIG_PIN 32 
#define ECHO_PIN 13 
#define TRIG_PIN2 25
#define ECHO_PIN2 34
#define TRIG_PIN3 33 
#define ECHO_PIN3 35 

// Çıkış Pinleri
#define TRIG_PIN4 14 
#define ECHO_PIN4 27  

// Servo pinleri
#define SERVO_GIRIS_PIN 12
#define SERVO_CIKIS 15

#define BUZZER_PIN 26

UltraSonicDistanceSensor distanceSensor(TRIG_PIN, ECHO_PIN);
UltraSonicDistanceSensor distanceSensor2(TRIG_PIN2, ECHO_PIN2);
UltraSonicDistanceSensor distanceSensor3(TRIG_PIN3, ECHO_PIN3);
UltraSonicDistanceSensor cikisSensor(TRIG_PIN4, ECHO_PIN4); // Yeni sensör

MFRC522 rfid(SS_PIN, RST_PIN);
LiquidCrystal_I2C lcd(0x27, 16, 2);

Servo servoGiris;
Servo servoCikis;

// Global değişken
bool cikisKapiAcik = false;




void setup() {
  Serial.begin(9600);

  // Wi-Fi'ye bağlan
  Serial.println("Wi-Fi'ye bağlanılıyor...");
  WiFi.begin(ssid, password);

  //Bağlantı sağlanana kadar bekliyoruz
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println(".");
  }

  //Bağlantı Başarılı!
  Serial.println("");
  Serial.println("Wi-Fi bağlantısı başarılı!");
  Serial.print("IP adresi: ");
  Serial.println(WiFi.localIP());





 // NTP başlat
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);

  // Saat verisinin gelmesini bekle
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Zaman alınamadı");
    return;
  }



  // FİREBASE'DEKİ SETTİNGS KISMIJNDAKİ WEB APP KISMINAKİ CONFİGTEN ALINAN BİLGİLERİ BURADA CONFİG DİYE KURUYORUZ ANLADIĞIM KADARIYLA
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

 // BURADA BİZİM FİREBASE'İMİZ SADECE ONAYLI KULLANICI GİRİŞ YAPS
  auth.user.email = "admin@isik.edu.tr";
  auth.user.password = "123456";

 // BURADA ANLADIĞIM KADARIYL FİREBASE.BEGİNN DİREYEK AUTHANTİCATE KISMINA BAĞLANIYORUZ VE BİR AŞAĞSIINDA WİFİ BAĞLANTISINI KONTROL EDİYORUZZ YA DA 
 // EĞER BAĞLANTI RECONNECT OLURS TEKRAR BAĞLAN GİBİ BİR ŞEY DİYORUZ
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  
  SPI.begin(18, 19, 23, SS_PIN);
  rfid.PCD_Init();

  lcd.init();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Kart Bekleniyor");

  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  pinMode(TRIG_PIN4, OUTPUT);  // Yeni sensör TRIG
  pinMode(ECHO_PIN4, INPUT);   // Yeni sensör ECHO

  servoGiris.attach(SERVO_GIRIS_PIN);
  servoGiris.write(0);
  servoCikis.attach(SERVO_CIKIS);
  servoCikis.write(0);

  pinMode(BUZZER_PIN, OUTPUT);
}




void kayitFirestore(String uid, String plaka) {
  if (!Firebase.ready()) {
    Serial.println("Firebase hazır değil!");
    return;
  }

  FirebaseJson content;

   // Zamanı al
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Zaman alınamadı, kayıt yapılmayacak.");
    return;
  }

  char timestamp[30];
  strftime(timestamp, sizeof(timestamp), "%d/%m/%Y %H:%M:%S", &timeinfo);
  String zaman = String(timestamp);



  // Belge içeriğini oluştur
  content.set("fields/uid/stringValue", uid);
  content.set("fields/plaka/stringValue", plaka);
  content.set("fields/timestamp/stringValue", zaman);

  // JSON içeriği string olarak dönüştür
  String jsonStr;
  content.toString(jsonStr);

  // Firestore createDocument işlemi
  bool success = Firebase.Firestore.createDocument(
  &fbdo,
  "otopark-sistemi-cd3ec",  // Proje ID
  "",                       // Veritabanı ID (default için boş)
  "otopark_kayitlari",      // Koleksiyon adı
  "",                       // Belge ID (boşsa otomatik oluşturulur)
  jsonStr.c_str(),          // JSON veri
  ""                        // Mask (isteğe bağlı, genelde boş bırakılır)
);


  if (success) {
    Serial.println("✅ Firestore'a kayıt başarıyla eklendi.");
  } else {
    Serial.print("❌ Firestore Hatası: ");
    Serial.println(fbdo.errorReason());
  }
}







void loop() {
  float mesafe = distanceSensor.measureDistanceCm();
  float mesafe2 = distanceSensor2.measureDistanceCm();
  float mesafe3 = distanceSensor3.measureDistanceCm();
  float cikisMesafe = cikisSensor.measureDistanceCm(); // Yeni sensör ölçümü
  Serial.println("\n ");

  delay(1000);
  
  Serial.print("1: "); Serial.println(mesafe);
  Serial.print("2: "); Serial.println(mesafe2);
  Serial.print("3: "); Serial.println(mesafe3);
  Serial.print("Cikis: "); Serial.println(cikisMesafe);
  Serial.println("\n ");


// BU KODLARI BURADA ÇALIŞTIRMAMIZIN SEBEBİ RFİD NİN RETURN KISMI OLDUĞUNDAN AŞAĞIDA KALINCA ALGILAMA YAPMIYOR BU YÜZDEN BUNLARI BURADA YAPTIK
// ZATEN BURADA YAPMAMIZ AŞAĞIDAKİ DURUMA GÖRE DE YİNE GÜNCELLEYECEK YANİ HA BURADA DEĞİTİRMİŞİZ DEĞERİ HA AŞAĞIDA 

  String parkDurumu = (mesafe <= 15.0 && mesafe != -1.00) ? "Dolu" : "Bos";
  String parkDurumu2 = (mesafe2 <= 15.0 && mesafe2 != -1.00) ? "Dolu" : "Bos";
  String parkDurumu3 = (mesafe3 <= 15.0 && mesafe3 != -1.00) ? "Dolu" : "Bos";


// Firebase'e sadece /otopark_listesi/P1 verisini güncelle
  if (Firebase.RTDB.setString(&fbdo, "/otopark_listesi/P1", parkDurumu)) {
    Serial.println("Firebase güncellendi: P1 -> " + parkDurumu);
  } else {
    Serial.print("Firebase güncellenemedi: ");
    Serial.println(fbdo.errorReason());
    
  }

// Firebase'e P2 verisini güncelle
  if (Firebase.RTDB.setString(&fbdo, "/otopark_listesi/P2", parkDurumu2)) {
    Serial.println("Firebase güncellendi: P2 -> " + parkDurumu2);
  } else {
    Serial.print("Firebase güncellenemedi (P2): ");
    Serial.println(fbdo.errorReason());
  }

// Firebase'e P3 verisini güncelle
  if (Firebase.RTDB.setString(&fbdo, "/otopark_listesi/P3", parkDurumu3)) {
    Serial.println("Firebase güncellendi: P3 -> " + parkDurumu3);
  } else {
    Serial.print("Firebase güncellenemedi (P3): ");
    Serial.println(fbdo.errorReason());
  }



  

  // Yeni sensör çıkış kontrolü
  if (cikisMesafe <= 15 && cikisMesafe != -1.00) {
    Serial.println("Çıkış Kapısı Açılıyor..");
    servoCikis.write(90);
    delay(5000);
    servoCikis.write(0);
  }

  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) return;

  String uid = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    if (rfid.uid.uidByte[i] < 0x10) uid += "0";
    uid += String(rfid.uid.uidByte[i], HEX);
  }
  uid.toUpperCase();

  Serial.print("Kart UID: ");
  Serial.println(uid);

  String plaka = getPlakaFromUID(uid);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Plaka:");
  lcd.setCursor(0, 1);
  lcd.print(plaka);
  delay(2000);
  // BURAYA EKLE
   lcd.clear();
  lcd.print("P1:"); lcd.print(parkDurumu);
  lcd.print(" P2:"); lcd.print(parkDurumu2);
  lcd.setCursor(0, 1);
  lcd.print("P3:"); lcd.print(parkDurumu3);
 



  if (plaka == "TANIMSIZ KART") {
    for (int i = 0; i < 3; i++) {
      tone(BUZZER_PIN, 1000);
      delay(300);
      noTone(BUZZER_PIN);
      delay(300);
    }
  } else {
    tone(BUZZER_PIN, 1000);
    delay(500);
    noTone(BUZZER_PIN);

    kayitFirestore(uid, plaka);

    servoGiris.write(90);

    delay(6000);
    servoGiris.write(0);
  }








  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Kart Bekleniyor");
  delay(500);
}

String getPlakaFromUID(String uid) {
  if (uid == "C7193803") return "34 BA 6721";
  else if (uid == "C322D02C") return "55 HM 541";
  else if (uid == "44AF33EF") return "34 MTV 162";
  else if (uid == "14593AEF") return "01 HB 2439";
  else if (uid == "34CC3CEF") return "42 MN 5010";
  else if (uid == "136F8914") return "34 KK 6021";
  else return "TANIMSIZ KART";
}
