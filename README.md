# RFID ile Anlık Araç Takibi ve Akıllı Otopark Yönlendirme Sistemi

**Geliştirici:** Cem Emre Demir
**Kurum:** Işık Üniversitesi

## 📌 Proje Özeti
Bu proje, kampüs gibi kontrollü ve geniş alanlarda araç giriş-çıkış güvenliğini sağlamak ve otopark alanlarının etkin kullanımını artırmak amacıyla geliştirilmiştir. Kullanıcıların otopark ararken yaşadığı zaman kaybını azaltmayı hedefleyen bu sistem; donanımsal IoT altyapısı, bulut tabanlı veri yönetimi ve mobil kullanıcı arayüzü ile uçtan uca entegre bir yapı sunmaktadır.

## 🚀 Temel Özellikler
* **Güvenli Geçiş Kontrolü:** Kampüs girişinde yer alan RFID okuyucu sayesinde, yalnızca sisteme tanımlı kart bilgilerine sahip yetkili araçların girişine izin verilmektedir.
* **Gerçek Zamanlı Doluluk Takibi:** Her otopark alanına yerleştirilmiş sensörler kullanılarak boş ve dolu park yerleri anlık olarak tespit edilir ve bu veriler doğrudan mobil uygulamaya aktarılır.
* **Kullanıcı Dostu Mobil Uygulama:** Kullanıcılar mobil uygulama üzerinden güncel otopark krokisini görüntüleyebilir, yönlendirme alabilir ve kendi profil bilgilerine ulaşabilir.
* **Gelişmiş Admin Paneli:** Yetkili kullanıcılar, kayıtlı profilleri görüntüleyip yönetebilir ve olası donanımsal hatalara karşı otopark doluluk durumunu mobil uygulama üzerinden manuel olarak güncelleyebilir.

## 🛠️ Kullanılan Teknolojiler ve Donanımlar
* **Donanım (IoT) Bileşenleri:**
  * Sistemin tüm kontrolü ve veri işleme görevleri Wi-Fi destekli **ESP32 CH340** mikrodenetleyicisi ile sağlanmıştır.
  * Araç tanımlama işlemleri için **RC522 RFID okuyucu** kullanılmıştır.
  * Otopark doluluk durumunu tespit etmek amacıyla **HC-SR04 ultrasonik sensörler** sisteme dahil edilmiştir.
  * Araç geçişlerinde bariyer kontrolü için **SG90 servo motor** kullanılmıştır.
  * Bilgilendirme ve uyarı amacıyla **LCD Ekran (I2C)** ve **Buzzer** entegre edilmiştir.
* **Veritabanı Altyapısı (Firebase):**
  * **Firebase Realtime Database:** Otopark alanlarının yüksek frekansta değişen anlık doluluk durumunu ve kullanıcı profili bilgilerini tutmak için kullanılmıştır.
  * **Cloud Firestore Database:** Okutulan RFID kartların UID bilgisi, araç plakası ve giriş zamanı gibi log kayıtlarını kalıcı olarak depolamak için yapılandırılmıştır.
* **Mobil Geliştirme:** Uygulamanın kullanıcı arayüzü Google'ın açık kaynaklı UI kiti olan **Flutter** ve **Dart** programlama dili kullanılarak geliştirilmiştir.
