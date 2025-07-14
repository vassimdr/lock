# 🔒 LockApp - Ebeveyn Kontrol Mobil Uygulaması

## 📱 Proje Hakkında

LockApp, ebeveynlerin çocuklarının mobil cihaz kullanımını izlemelerine ve kontrol etmelerine yardımcı olan kapsamlı bir ebeveyn kontrol uygulamasıdır. Flutter ve Firebase teknolojileri kullanılarak geliştirilmiştir.

## ✨ Özellikler

### 🔐 Kimlik Doğrulama ve Kullanıcı Yönetimi
- **Güvenli Firebase Authentication** ile email/şifre girişi
- **Rol tabanlı erişim kontrolü** (Ebeveyn/Çocuk hesapları)
- **Gerçek zamanlı kullanıcı oturum yönetimi**
- **Otomatik oturum yenileme**

### 📱 Cihaz Yönetimi
- **QR kod ile cihaz eşleştirme** (Ebeveyn-Çocuk)
- **Gerçek zamanlı cihaz durumu izleme**
- **Cihaz kayıt ve tanımlama sistemi**
- **Çoklu cihaz desteği**

### 🎯 Uygulama Kontrolü
- **Uygulama kilitleme/kilit açma** işlevselliği
- **Yüklü uygulama tespiti ve yönetimi**
- **Özel uygulama kısıtlamaları**
- **Anlık uygulama engelleme**

### ⏰ Zaman Kısıtlamaları
- **Günlük kullanım süre limitleri**
- **Haftalık zaman çizelgesi yönetimi**
- **İzin verilen günler ayarlama**
- **Esnek zaman dilimi kontrolü**

### 📊 Analitik ve İzleme
- **Kullanım istatistikleri** ve zaman takibi
- **Firebase Analytics** entegrasyonu
- **Gerçek zamanlı aktivite izleme**
- **Detaylı raporlama sistemi**

### 🔔 Bildirimler
- **Firebase Cloud Messaging** ile push bildirimler
- **Ebeveynler için gerçek zamanlı uyarılar**
- **Durum güncellemeleri** ve sistem bildirimleri
- **Özelleştirilebilir bildirim ayarları**

## 🛠️ Teknoloji Yığını

### Frontend
- **Flutter** - Çapraz platform mobil framework
- **Dart** - Programlama dili
- **Material Design 3** - UI bileşenleri
- **Riverpod** - Durum yönetimi

### Backend ve Servisler
- **Firebase Core** - Temel servisler
- **Firebase Authentication** - Kullanıcı yönetimi
- **Cloud Firestore** - NoSQL veritabanı
- **Firebase Cloud Messaging** - Push bildirimler
- **Firebase Analytics** - Kullanım takibi
- **Firebase Crashlytics** - Hata raporlama

### Navigasyon ve Mimari
- **GoRouter** - Navigasyon sistemi
- **Freezed** - Değişmez veri sınıfları
- **JSON Annotation** - Serileştirme
- **Build Runner** - Kod üretimi

## 🚀 Kurulum

### Ön Gereksinimler
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Firebase hesabı
- Git

### Adım Adım Kurulum

1. **Depoyu klonlayın**
```bash
git clone https://github.com/vassimdr/lock.git
cd lock/lockapp
```

2. **Bağımlılıkları yükleyin**
```bash
flutter pub get
```

3. **Kod üretimini çalıştırın**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Firebase Kurulumu**
   - Firebase Console'da yeni proje oluşturun
   - Android/iOS uygulamalarınızı ekleyin
   - `google-services.json` dosyasını `android/app/` klasörüne yerleştirin
   - `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne yerleştirin

5. **Firebase Servislerini Etkinleştirin**
   - Authentication (Email/Password)
   - Firestore Database
   - Analytics
   - Cloud Messaging
   - Crashlytics

6. **Uygulamayı çalıştırın**
```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
└── src/
    ├── api/                  # Firebase servisleri
    │   ├── auth_service.dart
    │   ├── firebase_auth_service.dart
    │   ├── firestore_service.dart
    │   └── ...
    ├── config/               # Yapılandırma dosyaları
    │   └── firebase_config.dart
    ├── constants/            # Uygulama sabitleri
    │   ├── app_constants.dart
    │   └── app_routes.dart
    ├── navigation/           # Navigasyon mantığı
    │   └── app_router.dart
    ├── screens/              # UI ekranları
    │   ├── auth/            # Giriş/Kayıt ekranları
    │   ├── child/           # Çocuk paneli
    │   ├── parent/          # Ebeveyn paneli
    │   ├── onboarding/      # Tanıtım ekranları
    │   └── permissions/     # İzin ekranları
    ├── services/             # Cihaz servisleri
    │   ├── app_blocking_service.dart
    │   ├── time_restriction_service.dart
    │   ├── usage_stats_service.dart
    │   └── ...
    ├── store/                # Durum yönetimi
    │   └── auth/
    ├── theme/                # Uygulama teması
    │   ├── app_colors.dart
    │   ├── app_text_styles.dart
    │   └── app_theme.dart
    ├── types/                # Veri modelleri
    │   ├── user_model.dart
    │   ├── device_model.dart
    │   ├── app_usage_stats.dart
    │   └── ...
    └── utils/                # Yardımcı fonksiyonlar
        └── error_handler.dart
```

## 🔧 Yapılandırma

### Firebase Yapılandırması
1. **Authentication**: Email/Password ile etkinleştirin
2. **Firestore**: Veritabanı oluşturun ve güvenlik kurallarını ayarlayın
3. **Analytics**: Kullanım takibi için etkinleştirin
4. **Cloud Messaging**: Push bildirimleri ayarlayın
5. **Crashlytics**: Hata raporlama için yapılandırın

### Android Yapılandırması
- Minimum SDK: 23
- Hedef SDK: 34
- **Gerekli İzinler**: 
  - Internet
  - Wake Lock
  - Receive Boot Completed
  - Device Admin
  - Accessibility Service

### Firebase İndeksleri
Aşağıdaki composite index'leri Firebase Console'da oluşturun:

1. **pairing_requests** koleksiyonu:
   - `isUsed`, `qrCode`, `expiresAt`, `__name__`
   - `isUsed`, `parentUserId`, `createdAt`, `expiresAt`, `__name__`

2. **block_attempt_logs** koleksiyonu:
   - `childUserId`, `attemptTime`, `__name__`

## 🎯 Kullanım Kılavuzu

### Ebeveynler İçin

1. **Kayıt Olma**
   - Uygulamayı açın
   - "Ebeveyn" rolünü seçin
   - Email ve şifre ile kayıt olun

2. **Çocuk Cihazı Eşleştirme**
   - "QR Kod Oluştur" butonuna tıklayın
   - QR kodu çocuğun cihazında taratın
   - Eşleştirme talebini onaylayın

3. **Uygulama Kontrolü**
   - "Uygulama Engelleme" sekmesine gidin
   - Engellemek istediğiniz uygulamaları seçin
   - Anlık olarak uygulama erişimini kontrol edin

4. **Zaman Kısıtlamaları**
   - "Zaman Kısıtlamaları" sekmesinde
   - Günlük kullanım limitlerini ayarlayın
   - İzin verilen günleri belirleyin

5. **İstatistikleri İzleme**
   - "Kullanım İstatistikleri" ile
   - Detaylı raporları görüntüleyin
   - Haftalık/günlük analizleri inceleyin

### Çocuklar İçin

1. **Kayıt Olma**
   - "Çocuk" rolünü seçin
   - Email ve şifre ile kayıt olun

2. **Ebeveyn Cihazına Bağlanma**
   - "QR Kod Tara" butonuna tıklayın
   - Ebeveynin gösterdiği QR kodu tarayın
   - Bağlantı isteğini gönderin

3. **Kısıtlamalı Kullanım**
   - Belirlenen sınırlar içinde cihazı kullanın
   - Gerektiğinde uygulama erişimi isteğinde bulunun
   - Zaman limitlerini takip edin

## 🔒 Güvenlik

- **Firebase Güvenlik Kuralları** ile veri koruması
- **Rol tabanlı erişim kontrolü**
- **Şifrelenmiş veri iletimi**
- **Güvenli kimlik doğrulama akışları**
- **GDPR uyumlu veri işleme**

## 📱 Desteklenen Platformlar

- ✅ **Android** (API 23+)
- ✅ **iOS** (iOS 12+)
- 🔄 **Web** (Planlanıyor)
- 🔄 **Desktop** (Planlanıyor)

## 🐛 Bilinen Sorunlar ve Çözümler

### Çözülen Sorunlar
- ✅ **RangeError**: Gün indeksi doğrulama hatası düzeltildi
- ✅ **Firebase Index**: Eksik composite indeksler oluşturuldu
- ✅ **UI Overflow**: Login ekranında taşma sorunu giderildi
- ✅ **Type Cast**: Güvenli tip dönüştürme eklendi
- ✅ **Widget Lifecycle**: Context güvenliği sağlandı
- ✅ **Serialization**: AppUsageStats serileştirme düzeltildi

### Performans İyileştirmeleri
- Bellek kullanımı optimize edildi
- Async işlemler iyileştirildi
- Error handling geliştirildi
- Cache mekanizması eklendi

## 🔄 Güncellemeler

### v1.0.0 (Mevcut)
- Temel ebeveyn kontrol özellikleri
- QR kod eşleştirme sistemi
- Uygulama engelleme
- Zaman kısıtlamaları
- Kullanım istatistikleri
- Firebase entegrasyonu

### Gelecek Güncellemeler
- 📍 Konum takibi
- 📞 Arama/SMS kontrolü
- 🌐 Web filtresi
- 📚 Eğitici içerik önerileri
- 🤖 AI destekli analiz

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/YeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`)
4. Branch'i push edin (`git push origin feature/YeniOzellik`)
5. Pull Request oluşturun

### Geliştirme Kuralları
- Kod temizliği ve okunabilirlik
- Comprehensive test coverage
- Documentation güncellemeleri
- Commit mesajları Türkçe

## 📄 Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasını inceleyin.

## 👨‍💻 Geliştirici

**Vasim** - [GitHub Profili](https://github.com/vassimdr)

## 🙏 Teşekkürler

- Flutter ekibine harika framework için
- Firebase ekibine backend servisleri için
- Topluluk katkısında bulunanlar ve test edicilere
- Türk geliştirici topluluğuna destekleri için

## 📞 İletişim

- **GitHub**: [@vassimdr](https://github.com/vassimdr)
- **E-posta**: vasim@example.com
- **Proje Repository**: https://github.com/vassimdr/lock

## 📋 SSS (Sık Sorulan Sorular)

### Uygulama nasıl çalışıyor?
LockApp, ebeveyn ve çocuk cihazları arasında güvenli bir bağlantı kurarak, ebeveynlerin çocuklarının cihaz kullanımını uzaktan kontrol etmesine olanak tanır.

### Hangi cihazlar destekleniyor?
Şu anda Android cihazlar (API 23+) ve iOS cihazlar (iOS 12+) desteklenmektedir.

### Veri güvenliği nasıl sağlanıyor?
Tüm veriler Firebase'in güvenli altyapısında şifrelenerek saklanır ve Firebase güvenlik kuralları ile korunur.

### Ücretsiz mi?
Evet, LockApp açık kaynak kodlu ve ücretsiz bir uygulamadır.

---

**❤️ ile Türkiye'de geliştirildi**

> **Not**: Bu uygulama ebeveynlerin çocuklarının dijital güvenliğini sağlamalarına yardımcı olmak amacıyla geliştirilmiştir. Kullanım sırasında çocukların mahremiyetine saygı gösterilmesi önerilir. 