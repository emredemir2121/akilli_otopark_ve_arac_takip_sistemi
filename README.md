# RFID ile Anlık Araç Takibi ve Akıllı Otopark Yönlendirme Sistemi

**Geliştirici:** Cem Emre Demir[cite: 2]
**Kurum:** Işık Üniversitesi[cite: 2]

## 📌 Proje Özeti
Bu proje, kampüs gibi kontrollü ve geniş alanlarda araç giriş-çıkış güvenliğini sağlamak ve otopark alanlarının etkin kullanımını artırmak amacıyla geliştirilmiştir[cite: 2]. Kullanıcıların otopark ararken yaşadığı zaman kaybını azaltmayı hedefleyen bu sistem; donanımsal IoT altyapısı, bulut tabanlı veri yönetimi ve mobil kullanıcı arayüzü ile uçtan uca entegre bir yapı sunmaktadır[cite: 2].

## 🚀 Temel Özellikler
* **Güvenli Geçiş Kontrolü:** Kampüs girişinde yer alan RFID okuyucu sayesinde, yalnızca sisteme tanımlı kart bilgilerine sahip yetkili araçların girişine izin verilmektedir[cite: 2].
* **Gerçek Zamanlı Doluluk Takibi:** Her otopark alanına yerleştirilmiş sensörler kullanılarak boş ve dolu park yerleri anlık olarak tespit edilir ve bu veriler doğrudan mobil uygulamaya aktarılır[cite: 2].
* **Kullanıcı Dostu Mobil Uygulama:** Kullanıcılar mobil uygulama üzerinden güncel otopark krokisini görüntüleyebilir, yönlendirme alabilir ve kendi profil bilgilerine ulaşabilir[cite: 2].
* **Gelişmiş Admin Paneli:** Yetkili kullanıcılar, kayıtlı profilleri görüntüleyip yönetebilir ve olası donanımsal hatalara karşı otopark doluluk durumunu mobil uygulama üzerinden manuel olarak güncelleyebilir[cite: 2].

## 🛠️ Kullanılan Teknolojiler ve Donanımlar
* **Donanım (IoT) Bileşenleri:**
  * Sistemin tüm kontrolü ve veri işleme görevleri Wi-Fi destekli **ESP32 CH340** mikrodenetleyicisi ile sağlanmıştır[cite: 2].
  * Araç tanımlama işlemleri için **RC522 RFID okuyucu** kullanılmıştır[cite: 2].
  * Otopark doluluk durumunu tespit etmek amacıyla **HC-SR04 ultrasonik sensörler** sisteme dahil edilmiştir[cite: 2].
  * Araç geçişlerinde bariyer kontrolü için **SG90 servo motor** kullanılmıştır[cite: 2].
  * Bilgilendirme ve uyarı amacıyla **LCD Ekran (I2C)** ve **Buzzer** entegre edilmiştir[cite: 2].
* **Veritabanı Altyapısı (Firebase):**
  * **Firebase Realtime Database:** Otopark alanlarının yüksek frekansta değişen anlık doluluk durumunu ve kullanıcı profili bilgilerini tutmak için kullanılmıştır[cite: 2].
  * **Cloud Firestore Database:** Okutulan RFID kartların UID bilgisi, araç plakası ve giriş zamanı gibi log kayıtlarını kalıcı olarak depolamak için yapılandırılmıştır[cite: 2].
* **Mobil Geliştirme:** Uygulamanın kullanıcı arayüzü Google'ın açık kaynaklı UI kiti olan **Flutter** ve **Dart** programlama dili kullanılarak geliştirilmiştir[cite: 2].
