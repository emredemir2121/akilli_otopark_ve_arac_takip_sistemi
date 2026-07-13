import 'package:flutter/material.dart';

class HizmetSartlariPage extends StatelessWidget {
  const HizmetSartlariPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hizmet Şartlarımız')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Text(
                '''Işık Üniversitesi olarak, kişisel verilerinizin güvenliğine ve mahremiyetine önem veriyor ve bu verilerinizi muhafaza etmek en üst düzeyde güvenlik tedbirlerini almaya çalışıyoruz.
Özellikle kişisel verilerinizin güvenliğini göz önünde bulundurarak, özel hayatın gizliliği, temel hak ve özgürlüklerin korunması amacıyla, 6698 Sayılı Kişisel Verilerin Korunması Kanunu gereği sizleri aydınlatmak istiyoruz.
Işık Üniversitesi olarak mevzuat gereği veri sorumlusu sıfatıyla, eğitim ve öğretim faaliyetlerinin sürdürülebilmesi kapsamında edinilen her türlü özel ve genel nitelikli kişisel veriler, 6698 Sayılı Kişisel Verilerin Korunması Kanunu'na uygun olarak aşağıda detayları belirtilen şekilde ve ilişkili mevzuat tarafından emredilen sınırlar çerçevesinde alınacak, kaydedilecek, saklanacak, güncellenecek, belirli üçüncü kişilere açıklanabilecek, sınıflandırılabilecek ve mevzuatta belirtilen diğer usul ve esaslara göre işlenecektir.
Kişisel verileri işlemeye ilişkin ilkelerimiz
Işık Üniversitesi olarak veriyi;
a) Hukuka ve dürüstlük kurallarına uygun işlemeyi,
b) Doğru ve güncelliği sağlama gayretinde olmayı,
c) Belirli, açık ve meşru amaçlar için işlemeyi,
ç) İşlendikleri amaçla bağlantılı, sınırlı ve ölçülü olmayı,
d) İlgili mevzuatta öngörülen veya işlendikleri amaç için gerekli olan süre kadar muhafaza etmeyi ilke edindik.

Kişisel Verilerinizi Kanunlar Gereği Açık Rızanız Olmaksızın İşleyebileceğimiz Durumlar
Kanunun 5. maddesi uyarınca açık rıza, Kanundaki kişisel veri işleme şartlarından biri olmakla birlikte veri işleme faaliyetine hukukilik kazandıran tek unsur değildir. Kanunda veri işleme faaliyeti için açık rıza dışında da şartlar öngörülmüştür. Buna göre, aşağıdaki şartlardan birinin varlığı halinde, ilgili kişinin açık rızası aranmaksızın kişisel verilerinin işlenmesi mümkündür:

a) Kanunlarda açıkça öngörülmesi,
b) Fiili imkânsızlık nedeniyle rızasını açıklayamayacak durumda bulunan veya rızasına hukuki geçerlilik tanınmayan kişinin kendisinin ya da bir başkasının hayatı veya beden bütünlüğünün korunması için zorunlu olması,
c) Bir sözleşmenin kurulması veya ifasıyla doğrudan doğruya ilgili olması kaydıyla, sözleşmenin taraflarına ait kişisel verilerin işlenmesinin gerekli olması,
ç) Veri sorumlusunun hukuki yükümlülüğünü yerine getirebilmesi için zorunlu olması,
d) İlgili kişinin kendisi tarafından alenileştirilmiş olması,
e) Bir hakkın tesisi, kullanılması veya korunması için veri işlemenin zorunlu olması,
f) İlgili kişinin temel hak ve özgürlüklerine zarar vermemek kaydıyla, veri sorumlusunun meşru menfaatleri için veri işlenmesinin zorunlu olması.
Nasıl Koruyoruz?
Işık Üniversitesi tarafından toplanan tüm 
kişisel verilerin güvenliği için gerekli teknik ve idari bütün tedbirler alınmaktadır. Bu çerçevede KVK kurulu tarafından yayımlanmış Kişisel Veri Güvenliği Rehberi gerekliliklerine, Türkiye Cumhuriyeti Cumhurbaşkanlığı Bilgi ve İletişim Güvenliği Rehberine, ISO/IEC 27001 Bilgi Güvenliği, ISO/IEC 27017 Bulut Hizmetleri Bilgi Güvenliği, ISO/IEC 27701 Gizlilik Bilgileri Yönetimi standartlarına, Avrupa Birliği Genel Veri Koruma Yönetmeliği GDPR uygun şekilde yetkisiz erişime, kötüye kullanıma, ifşaya veya değiştirilmesine karşı fiziksel, teknik, örgütsel ve yönetimsel önlemler alıyoruz.  
''',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}


class GizlilikPolitikasiPage extends StatelessWidget {
  const GizlilikPolitikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gizlilik Politikamız')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Text(
                '''Veri Sorumlusu

6698 sayılı Kişisel Verilerin Korunması Kanunu ("6698 sayılı Kanun") uyarınca, Veri Sorumlusu Feyziye Mektepleri Vakfı Işık Üniversitesi'dir.
İş Ortaklarımıza Ait Kişisel Verileri İşlemeye İlişkin İlkelerimiz
Işık Üniversitesi olarak veriyi;

a) Hukuka ve dürüstlük kurallarına uygun işlemeyi,
b) Doğru ve güncelliği sağlama gayretinde olmayı,
c) Belirli, açık ve meşru amaçlar için işlemeyi,
ç) İşlendikleri amaçla bağlantılı, sınırlı ve ölçülü olmayı,
d) Mevzuatta öngörülen veya işlendikleri amaç için gerekli olan süre kadar muhafaza etmeyi ilke edindik.
Aydınlatma ve Kapsam
Veri sorumlusu sıfatı ile Işık Üniversitesi olarak, iş ilişkilerimiz kapsamında edinilen her türlü özel ve genel kişisel veriler, 6698 sayılı Kişisel Verilerin Korunması Kanunu 5. ve 6. Maddelerde belirtilen veri işleme şartları doğrultusunda ölçülü ve sınırlı olmak şartıyla, kurum ilkelerimiz gereğince, iş faaliyetlerinin yerine getirilmesi sebebiyle, veri sorumlusu olarak hukuki sorumluluğumuz ve sözleşmenin ifası gibi veri sorumluluğu yükümlülükleri gereğince işlenebilmektedir.
Bu bilinçle kurumumuz edinilen özel ve genel nitelikli kişisel verileri, 6698 sayılı Kişisel Verilerin Korunması Kanununa, bağlı yürürlüğe koyulan ve koyulacak ikincil düzenlemelere (yönetmelik, tebliğ,  genelge) ve bağlayıcı nitelikteki Kişisel Verileri Koruma Kurulu tarafından alınmış ve alınacak kararlara uygun olarak işlenmesine (saklama, silme, imha, yedekleme vb.) büyük önem göstermektedir. 

İşlenen Kişisel Veriler

İş ilişkisi kapsamında tarafımızca işlenebilecek kişisel verileriniz ve açıklamaları aşağıdaki gibidir;
Kimlik Bilgisi; Tüm kimlik bilgileri, uyruk, medeni durumu, doğum yeri ve tarihi, T.C. kimlik numarası, cinsiyet, imza bilgisi, SGK numarası gibi veriler,
İletişim Bilgisi; Telefon numarası, gerekli durumlarda ulaşmak işin yedek kişi telefon bilgisi, adres bilgisi, e-posta adresi gibi veriler,
Eğitim ve Sertifika Bilgisi; Öğrenim durumu, sertifika aldığı kurs ve seminer bilgileri, ilgili iş kapsamında aldığı eğitimler ve referans bilgileri, mesleki yeterlilik belgesi,  özgeçmiş bilgileri gibi veriler,
Finansal Bilgi; Finansal bilgiler, mali yapıya ilişkin bilgiler, icra takip ve borç bilgileri, banka bilgileri gibi veriler
Görsel Veri; Lokasyonumuzda iş süreçlerinin güvenliği sebebiyle işlenen fotoğraf, kamera kayıt görüntüleri,
İşitsel Veri; Hizmet kalitesi ve talep / şikayet süreçlerinin yerine getirilmesi amacı ile işlenen ses kayıtları,
Özel Nitelikli Kişisel Veri; Özgeçmiş bilgileri, adli sicil kaydı, sağlık beyanına ilişkin bilgiler, nüfus cüzdanı/ehliyet suretinde yer alan veriler,
Çalışma Verisi ; Sicil no, pozisyon adı, departmanı ve birimi, unvanı, SGK giriş bildirgesi ve görevlendirme belgeleri, işe başlama tarihi, unvanı, imza sirküleri, çalıştığı projeler, referans bilgileri, ilgili meslek odası veya kurumundan alınacak faaliyet belgesi, internet ve kurum içi erişim logları,
Diğer;  Araç bilgileri,
İşlenen veriler iş ilişkimiz kapsamında bunlardan bir ya da birkaçı olabilir.
''',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}


