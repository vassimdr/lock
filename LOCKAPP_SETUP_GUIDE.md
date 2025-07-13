# 🔐 LockApp Database Setup Guide

## 📋 Kurulum Adımları

### 1. Supabase Dashboard'a Giriş
- [Supabase Dashboard](https://app.supabase.com) adresine gidin
- Projenizi seçin
- **SQL Editor** sekmesine tıklayın

### 2. Veritabanı Yapısını Oluştur
- `LOCKAPP_COMPLETE_DATABASE.sql` dosyasını açın
- Tüm içeriği kopyalayın
- Supabase SQL Editor'a yapıştırın
- **RUN** butonuna basın

### 3. Kurulum Sonuçlarını Kontrol Et
Script başarıyla çalıştıktan sonra şunları göreceksiniz:
- ✅ 6 tablo oluşturuldu
- ✅ 6 enum tipi oluşturuldu
- ✅ RLS politikaları aktif
- ✅ Tüm indeksler ve trigger'lar hazır

## 🗄️ Veritabanı Yapısı

### 📊 Tablolar

| Tablo | Açıklama | Bağımlılık |
|-------|----------|------------|
| `users` | Kullanıcı bilgileri | `auth.users` |
| `devices` | Cihaz bilgileri | `users` |
| `device_pairings` | Ebeveyn-çocuk cihaz eşleştirmeleri | `devices`, `users` |
| `app_list` | Cihazlardaki uygulamalar | `devices` |
| `lock_commands` | Uygulama kilitleme komutları | `devices`, `users` |
| `usage_stats` | Uygulama kullanım istatistikleri | `devices`, `users` |

### 🏷️ Enum Tipleri

```sql
-- Kullanıcı rolleri
user_role: 'parent', 'child'

-- Cihaz durumları
device_status: 'active', 'inactive', 'blocked', 'pending'

-- Cihaz tipleri
device_type: 'parent_device', 'child_device'

-- Kilit durumları
lock_status: 'locked', 'unlocked', 'temporary_unlock'

-- Komut durumları
command_status: 'pending', 'sent', 'delivered', 'executed', 'failed', 'expired'

-- Eşleştirme durumları
pairing_status: 'pending', 'accepted', 'rejected', 'expired'
```

### 🔐 Güvenlik Özellikleri

#### Row Level Security (RLS)
- ✅ Tüm tablolarda RLS aktif
- ✅ Kullanıcılar sadece kendi verilerine erişebilir
- ✅ Ebeveyn-çocuk ilişkisi korunuyor

#### Veri Doğrulama
- ✅ Email format kontrolü
- ✅ Telefon numarası format kontrolü
- ✅ Kullanıcı adı uzunluk kontrolü
- ✅ Cihaz-kullanıcı rol uyumluluk kontrolü

#### Trigger'lar
- ✅ Otomatik `updated_at` güncellemesi
- ✅ Cihaz sahiplik doğrulaması
- ✅ Ebeveyn-çocuk ilişki doğrulaması

## 🔧 Flutter Entegrasyonu

### 1. Auth Service Düzeltmesi
`lockapp/lib/src/api/supabase_auth_service.dart` dosyasındaki hata düzeltilmeli:

```dart
// HATALI KOD (64. satır)
} catch (e) {
  throw error_handler.AuthException('Registration failed: ${e.toString()}');
}

// DOĞRU KOD
} catch (e) {
  throw error_handler.AuthException('Registration failed: ${e.toString()}');
}
```

### 2. User Model Güncellenmesi
`lockapp/lib/src/types/user_model.dart` dosyasına yeni alanlar eklenebilir:

```dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImageUrl;
  final String? phoneNumber;  // YENİ
  final bool isActive;
  final bool isVerified;      // YENİ
  final DateTime? lastLoginAt; // YENİ
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;
  
  // ... rest of the class
}
```

### 3. Device Model Oluşturulması
`lockapp/lib/src/types/device_model.dart` dosyası güncellenmeli:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'device_name')
  final String deviceName;
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'device_type')
  final String deviceType;
  final String status;
  @JsonKey(name: 'os_version')
  final String? osVersion;
  @JsonKey(name: 'app_version')
  final String? appVersion;
  @JsonKey(name: 'device_model')
  final String? deviceModel;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  @JsonKey(name: 'last_seen')
  final DateTime lastSeen;
  final Map<String, dynamic>? settings;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const DeviceModel({
    required this.id,
    required this.userId,
    required this.deviceName,
    required this.deviceId,
    required this.deviceType,
    required this.status,
    this.osVersion,
    this.appVersion,
    this.deviceModel,
    required this.isOnline,
    required this.lastSeen,
    this.settings,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
```

## 📝 Kullanım Örnekleri

### 1. Kullanıcı Kaydı
```dart
// Register new parent user
final user = await authService.register(
  email: 'parent@example.com',
  password: 'securepassword',
  name: 'Parent Name',
  role: UserRole.parent,
);
```

### 2. Cihaz Kaydı
```sql
-- Register parent device
INSERT INTO devices (user_id, device_name, device_id, device_type, status)
VALUES (
  'user-uuid-here',
  'Parent Phone',
  'unique-device-id-here',
  'parent_device',
  'active'
);
```

### 3. Cihaz Eşleştirme
```sql
-- Create device pairing
INSERT INTO device_pairings (
  parent_device_id, child_device_id, 
  parent_user_id, child_user_id, 
  status, expires_at
)
VALUES (
  'parent-device-uuid',
  'child-device-uuid',
  'parent-user-uuid',
  'child-user-uuid',
  'pending',
  NOW() + INTERVAL '1 hour'
);
```

### 4. Uygulama Kilitleme
```sql
-- Lock an app
INSERT INTO lock_commands (
  parent_device_id, child_device_id,
  parent_user_id, child_user_id,
  app_package_name, command_type, status
)
VALUES (
  'parent-device-uuid',
  'child-device-uuid',
  'parent-user-uuid',
  'child-user-uuid',
  'com.example.game',
  'lock',
  'pending'
);
```

## 🔍 Sorun Giderme

### Yaygın Hatalar ve Çözümleri

#### 1. "relation does not exist" hatası
```sql
-- Tabloları kontrol et
SELECT tablename FROM pg_tables WHERE schemaname = 'public';
```

#### 2. "permission denied" hatası
```sql
-- RLS politikalarını kontrol et
SELECT * FROM pg_policies WHERE schemaname = 'public';
```

#### 3. "constraint violation" hatası
```sql
-- Constraint'leri kontrol et
SELECT conname, contype FROM pg_constraint 
WHERE connamespace = 'public'::regnamespace;
```

### Performans Optimizasyonu

#### 1. İndeks Kullanımını Kontrol Et
```sql
-- Yavaş sorguları bul
SELECT query, calls, mean_time 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;
```

#### 2. Tablo İstatistiklerini Güncelle
```sql
-- İstatistikleri güncelle
ANALYZE users;
ANALYZE devices;
ANALYZE device_pairings;
ANALYZE app_list;
ANALYZE lock_commands;
ANALYZE usage_stats;
```

## 🚀 Sonraki Adımlar

1. **Flutter Service Layer**: Database'e bağlanan service sınıfları oluştur
2. **Riverpod Providers**: State management için provider'ları kur
3. **Real-time Subscriptions**: Supabase realtime özelliklerini entegre et
4. **Testing**: Unit ve integration testler yaz
5. **Error Handling**: Kapsamlı hata yönetimi ekle

## 📞 Destek

Kurulum sırasında sorun yaşarsanız:
1. Supabase logs'ları kontrol edin
2. SQL Editor'daki hata mesajlarını inceleyin
3. Constraint ve trigger hatalarını gözden geçirin

---

**✅ Başarılı kurulum sonrası LockApp tam işlevsel veritabanı yapısına sahip olacak!** 