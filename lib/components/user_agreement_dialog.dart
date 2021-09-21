import 'package:flutter/material.dart';

showUserAgreementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Kullanıcı Sözleşmesi'),
      content: SingleChildScrollView(
        child: Text(
          '''1-ÇEREZ KULLANIM UYARISI \n
Uygulamamızdan en iyi şekilde faydalanabilmeniz için yasal düzenlemelere uygun çerezler kullanılmaktadır. Bu uygulamaya giriş yaparak çerez kullanımını kabul etmiş sayılıyorsunuz. Detaylı bilgiye gizlilik, KVK ve çerez politikasi sayfamızdan ulaşabilirsiniz. \n
2-ERİŞİM İZNİ \n
Deprem Riskim öğesi telefonunuzdaki GPS alıcı, Kamera ve Fotoğraf Galerisi klasörlerine erişim izni istiyor. \n
3-BİLDİRİM GÖNDERME İZNİ \n
Deprem Riskim öğesinin size bildirim göndermesine izin verilsin. \n
4- UYARI: \n
Oluşturulan rapor tamamen Kullanıcının sunmuş olduğu bilgiler doğrultusunda hazırlanacak olup, kısmi analize dayalı olarak oluşturduğundan söz konusu rapor %100 doğruluk taşımamaktadır. Söz konusu rapor resmi işlemlerde kullanılamamaktadır. Belirtilen nedenlerle Şirketimizin herhangi bir sorumluluğu olmayacağı kullanıcı tarafından kabul edilmektedir. \n
5- GİZLİLİK, KVK POLİTİKASI VE ÇEREZ UYARISI \n
İşbu gizlilik ve Kişisel verilerin korunması(KVK) politikası, Başarsoft Bilgi Teknolojileri A.Ş. (“Şirket”) tarafından işletilmekte olan Deprem Riskim (“APP”) işletilmesi sırasında APP kullanıcıları (“Veri Sahibi”) tarafından Şirket ile paylaşılan veya Şirketin, Veri Sahibinin APP kullanımı sırasında sunulan kişisel verilerin kullanımına ilişkin koşul ve şartları açıklamaktadır. \n
İşbu Gizlilik Politikası ile KVK’ya ilişkin olarak, Veri Sahibi aydınlatılmış olduğunu ve kişisel verilerinin burada belirtilen şekilde kullanımına muvafakat ettiğini beyan eder.  \n
İşlenen Veriler: \n
6698 sayılı Kişisel Verilerin Korunması Kanunu (“Kanun”) uyarınca kişisel veri, gerçek kişileri belirli veya belirlenebilir kılan her türlü veridir. Genel olarak “Kişisel Veri” ifadesi;  iletişim bilgisini, kullanıcı bilgisini,  Kullanıcı İşlem Bilgisini, İşlem Güvenliği Bilgisini,  Talep/Şikayet Yönetimi Bilgisini kapsamaktadır. \n
KVK kanunu gereğince anonim hale getirilen veriler Kişisel Veri olarak kabul edilmeyecek ve bu verilere ilişkin işleme faaliyetleri gerçekleştirilebilecektir. \n
Verilerin kullanım amacı: \n
Kişisel Veriler, Şirket tarafından sunulan ürün ve hizmetlerin ilgili kişilerin ihtiyaçlarına göre şekillendirilmsi ve sunulması amacıyla işlenebilecektir. \n
KVK kanunu  5 ve 8. maddeleri uyarınca veya ilgili mevzuattaki istisnaların varlığı halinde Kişisel Veriler, Veri Sahibinin ayrıca rızasını almaksızın işlenebilecek ve üçüncü kişilerle paylaşılabilecektir.  \n
Verilere erişim: \n
Kişisel Veriler ve bu Kişisel Verileri kullanılarak elde edilen yeni veriler, işbu Gizlilik Politikası ile belirlenen amaçların gerçekleştirilebilmesi için Şirketin hizmetlerinden faydalandığı üçüncü kişilere, söz konusu hizmetlerin temini amacıyla sınırlı olmak üzere aktarılabilecektir. Şirket ayrıca, işbu gizlilik politikasında belirtilen amaçlar dahilinde verileri, Şirketin iş ortakları, tedarikçileri ve hukuken yetkili kurum ve kuruluşlara aktarabilecektir. \n
Veri Sahibi, yukarıda belirtilen amaçlarla sınırlı olmak kaydı ile bahsi geçen Kişisel Verilerini şirketin sunucularında saklayabileceğini, bu hususa peşinen muvafakat ettiğini kabul eder. \n
Verilere Erişim Hakkı ve Düzeltme Talepleri Hakkında \n
KVKK  11. maddesi uyarınca veri sahipleri,   Kişisel veri işlenip işlenmediğini öğrenme,  Kişisel verileri işlenmişse buna ilişkin bilgi talep etme, Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,  Yurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri bilme,  Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme ve bu kapsamda yapılan işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme, Kanun ve ilgili diğer kanun hükümlerine uygun olarak işlenmiş olmasına rağmen, işlenmesini gerektiren sebeplerin ortadan kalkması hâlinde kişisel verilerin silinmesini veya yok edilmesini isteme ve bu kapsamda yapılan işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme, İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz etme,    Kişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme haklarına sahiptir. \n
Söz konusu haklar, kişisel veri sahipleri tarafından www.basarsoft.com.tr adresine yazılı olarak veya Kişisel Verileri Koruma Kurulu tarafından belirlenen yöntemlerle iletilmesi halinde en kısa sürede ve en egç 30 (otuz) gün içerisinde sonuçlandırılacaktır.  \n
Veri Sahibinin doğru bilgileri sağlamamış olması halinde Şirketin herhangi bir sorumluluğu olmayacaktır. Veri Sahibi, herhangi bir Kişisel Verisinin Şirket tarafından kullanılamaması ile sonuçlanacak bir talepte bulunması halinde APP’in işleyişinden tam olarak faydalanamayabileceğini kabul ile bu kapsamda doğacak her türlü sorumluluğun kendisine ait olacağını beyan eder.    \n
Kişisel Verilerin Saklanma Süresi \n
Şirket, Kişisel Verileri, yukarıda belirtilen işleme amaçlarının gerektirdiği süre boyunca 5 yılı aşmamak kaydıyla saklayacaktır. Ancak, Veri Sahibi ile Şirket arasında doğabilecek herhangi bir uyuşmazlık durumunda, uyuşmazlık kapsamında gerekli savunmaların gerçekleştirilebilmesi amacıyla sınırlı olmak üzere ve ilgili mevzuat uyarınca belirlenen zamanaşımı süreleri boyunca Kişisel Verileri saklayabilecektir. \n
Çerez (“Cookie”) Kullanımı \n
Veri Sahiplerinin APP’den daha iyi faydalanabilmesi ve kullanıcı deneyiminin geliştirilmesi için yasal düzenlemelere uygun çerezler kullanılmaktadır. Çerez kullanılmasını tercih etmezseniz tarayıcınızın ayarlarından çerezleri silebilir ya da engelleyebilirsiniz. Ancak bu durum APP kullanımınızı etkileyebileceğini hatırlatmak isteriz. Tarayıcınızdan Cookie ayarlarınızı değiştirmediğiniz sürece bu APP’de çerez kullanımını kabul ettiğinizi varsayacağız. \n
· Çerez Nedir ve Neden Kullanılmaktadır? \n
Çerez, ziyaret ettiğiniz internet siteleri tarafından tarayıcılar aracılığıyla cihazınıza veya ağ sunucusuna depolanan küçük metin dosyalarıdır. Çerezler konusundan daha detaylı bilgi için www.aboutcookies.org ve www.allaboutcookies.org adreslerini ziyaret edebilirisiniz. \n
· APP’de Kullanılan Çerezlerin Kategorileri \n
Teknik Çerezler(Technical Cookies), Kişiselleştirme Çerezleri(Customization Cookies), Analitik Çerezler(Analytical Cookies) \n
Gizlilik Politikasındaki Değişiklikler \n
Şirket, işbu gizlilik politikası hükümlerini dilediği zaman değiştirebilir. Güncel gizlilik politikası, benzer yöntemle sunulduğu tarihte yürürlük kazanır.\n
Bina Analizi\n
Bir kullanıcı maksimum beş (5) bina analizi yapabilir. ''',
          style: TextStyle(fontSize: 13),
        ),
      ),
      actions: [
        MaterialButton(
          child: Text('TAMAM'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
