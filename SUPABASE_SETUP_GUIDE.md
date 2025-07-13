# LockApp Supabase Database Setup Guide

## 📋 Kurulum Adımları

### 1. Supabase Dashboard'a Git
- Supabase projenize login olun
- SQL Editor'ı açın

### 2. Database Reset Script'ini Çalıştır
- `SUPABASE_COMPLETE_RESET.sql` dosyasını açın
- Tüm içeriği kopyalayın
- Supabase SQL Editor'a yapıştırın
- **RUN** butonuna basın

### 3. Sonuçları Kontrol Et
Script çalıştıktan sonra şunları göreceksiniz:
- Tablo sayıları (users: 0, devices: 0)
- Oluşturulan politikalar listesi

### 4. Authentication Test Et
- Flutter uygulamasını çalıştırın
- Kayıt ol sayfasından yeni kullanıcı oluşturun
- Login olun

## 🔧 Script Ne Yapıyor?

### Bölüm 1: Temizlik
- Tüm eski politikaları siler
- Tabloları siler
- Enum'ları siler

### Bölüm 2: Enum'lar
- `user_role`: 'parent', 'child'
- `device_status`: 'active', 'inactive', 'blocked'

### Bölüm 3: Users Tablosu
- `id`: auth.users ile bağlantılı
- `email`: unique
- `name`: kullanıcı adı
- `role`: parent/child
- `profile_image_url`: profil resmi (opsiyonel)
- `is_active`: aktif kullanıcı durumu
- `metadata`: ek bilgiler (JSON)
- `created_at`, `updated_at`: timestamp'ler

### Bölüm 4: Devices Tablosu
- `id`: UUID primary key
- `user_id`: users tablosuna referans
- `device_name`: cihaz adı
- `device_id`: unique cihaz kimliği
- `status`: active/inactive/blocked

### Bölüm 5: Triggers
- `updated_at` otomatik güncelleme

### Bölüm 6: RLS Politikaları
- Users: kimlik doğrulamalı kullanıcılar okuyabilir, kendi profilini güncelleyebilir
- Devices: kullanıcılar sadece kendi cihazlarını görebilir/düzenleyebilir

### Bölüm 7: İndeksler
- Performans için gerekli indeksler

## ⚠️ Önemli Notlar

1. **Bu script tüm mevcut verileri siler!** Production'da dikkatli kullanın.
2. Script çalıştıktan sonra tüm kullanıcılar yeniden kayıt olmalı.
3. RLS politikaları aktif, güvenli bir kurulum.

## 🐛 Sorun Giderme

### Eğer script hata verirse:
1. Supabase dashboard'da Tables sekmesine gidin
2. Mevcut tabloları manuel olarak silin
3. Script'i tekrar çalıştırın

### Eğer login çalışmıyorsa:
1. Supabase Authentication sekmesinde kullanıcıları kontrol edin
2. Users tablosunda kayıtları kontrol edin
3. Her auth.users kaydı için users tablosunda kayıt olmalı

## 📞 Destek
Herhangi bir sorun yaşarsanız script'teki yorumları okuyun ve bölüm bölüm çalıştırın. 