# LockApp - Ebeveyn Kontrol Uygulaması

Flutter ile geliştirilmiş kapsamlı ebeveyn kontrol uygulaması. Çocukların dijital alışkanlıklarını yönetmek ve güvenli internet kullanımı sağlamak için tasarlanmıştır.

## 🚀 Özellikler

### ✅ Tamamlanan Özellikler
- **Modern UI/UX**: Material 3 tasarım sistemi
- **Rol Tabanlı Giriş**: Ebeveyn ve Çocuk rolleri
- **Kapsamlı İzin Yönetimi**: 
  - Kullanım erişimi izni
  - Erişilebilirlik servisi izni
  - Cihaz yöneticisi izni
  - Üstte gösterme izni
- **Otomatik İzin İsteme**: Bazı izinler için otomatik yönlendirme
- **Native Android Entegrasyonu**: Gerçek izin kontrolleri
- **Akıllı Fallback Sistemi**: Çoklu alternatif yönlendirme
- **Responsive Tasarım**: Farklı ekran boyutları desteği

### 🔄 Geliştirme Aşamasında
- Firebase Authentication entegrasyonu
- QR kod ile cihaz eşleştirme
- Uygulama kullanım istatistikleri
- Uzaktan uygulama kilitleme
- Gerçek zamanlı bildirimler

## 🏗️ Mimari

### Klasör Yapısı
```
lib/src/
├── api/             # API clients ve çağrıları
├── assets/          # Resimler, fontlar, animasyonlar
├── components/      # Yeniden kullanılabilir UI bileşenleri
├── config/          # Çevre değişkenleri ve konfigürasyon
├── constants/       # Uygulama sabitleri
├── hooks/           # Custom React hooks
├── navigation/      # React Navigation mantığı
├── screens/         # Ekran bileşenleri
├── store/           # Redux Toolkit state yönetimi
├── theme/           # Styling ve tema
├── types/           # Global TypeScript tipleri
└── utils/           # Yardımcı fonksiyonlar
```

### Teknoloji Stack
- **Framework**: Flutter 3.32.5
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Styling**: Flutter ScreenUtil + Google Fonts
- **Database**: Cloud Firestore (gelecek)
- **Authentication**: Firebase Auth (gelecek)
- **Native Integration**: MethodChannel

## 📱 İzin Sistemi

### Gerekli İzinler
1. **Kullanım Erişimi İzni**: Uygulama kullanım istatistikleri
2. **Erişilebilirlik Servisi**: Uygulama kontrolü
3. **Cihaz Yöneticisi**: Uzaktan cihaz yönetimi
4. **Üstte Gösterme**: Kilit ekranı gösterimi

### Otomatik İzin İsteme
- Accessibility Service için doğrudan ayar sayfası
- Device Admin için otomatik yetkilendirme dialogu
- Akıllı fallback sistemi ile alternatif yollar

## 🛠️ Kurulum

### Gereksinimler
- Flutter SDK 3.8.1+
- Android SDK 21+
- Kotlin support

### Adımlar
```bash
# Repository'yi klonla
git clone https://github.com/vassimdr/lock.git
cd lock/lockapp

# Bağımlılıkları yükle
flutter pub get

# Android emülatörde çalıştır
flutter run -d android

# Windows'ta çalıştır
flutter run -d windows
```

## 🔧 Geliştirme

### Native Android Entegrasyonu
- **MainActivity.kt**: MethodChannel ile Flutter-Android köprüsü
- **LockAppAccessibilityService**: Erişilebilirlik servisi
- **LockAppDeviceAdminReceiver**: Cihaz yöneticisi receiver
- **Native İzin Kontrolleri**: Gerçek zamanlı izin durumu

### Tema Sistemi
- **AppColors**: Kapsamlı renk paleti
- **AppTextStyles**: Google Fonts (Poppins) tipografi
- **AppSpacing**: Tutarlı spacing değerleri
- **Material 3**: Modern tasarım sistemi

## 📋 TODO

### Yüksek Öncelik
- [ ] Firebase Authentication entegrasyonu
- [ ] QR kod ile cihaz eşleştirme
- [ ] Gerçek uygulama kullanım istatistikleri
- [ ] Uzaktan uygulama kilitleme

### Orta Öncelik
- [ ] Push notification sistemi
- [ ] Ebeveyn dashboard geliştirme
- [ ] Çocuk profil yönetimi
- [ ] Zaman bazlı kısıtlamalar

### Düşük Öncelik
- [ ] iOS desteği
- [ ] Web dashboard
- [ ] Çoklu dil desteği
- [ ] Dark mode

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 📞 İletişim

Proje Sahibi: [@vassimdr](https://github.com/vassimdr)

Proje Linki: [https://github.com/vassimdr/lock](https://github.com/vassimdr/lock)

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! 