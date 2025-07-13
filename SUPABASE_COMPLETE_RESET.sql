-- =====================================================
-- SUPABASE COMPLETE RESET - LOCKAPP DATABASE
-- =====================================================
-- Bu script tüm tabloları, politikaları ve bağımlılıkları siler
-- ve temiz bir şekilde yeniden oluşturur

-- BÖLÜM 1: MEVCUT TABLOLARI VE POLİTİKALARI SİL
-- =====================================================

-- Önce tüm RLS politikalarını sil
DROP POLICY IF EXISTS "Allow authenticated users to select profiles" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to insert profiles" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to update profiles" ON users;
DROP POLICY IF EXISTS "Allow users to select own profile" ON users;
DROP POLICY IF EXISTS "Allow users to insert own profile" ON users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON users;

-- Devices tablosu politikalarını sil (eğer varsa)
DROP POLICY IF EXISTS "Allow authenticated users to select devices" ON devices;
DROP POLICY IF EXISTS "Allow authenticated users to insert devices" ON devices;
DROP POLICY IF EXISTS "Allow authenticated users to update devices" ON devices;

-- Tabloları sil (bağımlılık sırasına göre)
DROP TABLE IF EXISTS devices CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Enum'ları sil
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS device_status CASCADE;

-- BÖLÜM 2: ENUM TİPLERİNİ OLUŞTUR
-- =====================================================

-- User role enum
CREATE TYPE user_role AS ENUM ('parent', 'child');

-- Device status enum
CREATE TYPE device_status AS ENUM ('active', 'inactive', 'blocked');

-- BÖLÜM 3: USERS TABLOSUNU OLUŞTUR
-- =====================================================

CREATE TABLE users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role user_role NOT NULL DEFAULT 'parent',
    profile_image_url TEXT,
    is_active BOOLEAN DEFAULT true NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- BÖLÜM 4: DEVICES TABLOSUNU OLUŞTUR
-- =====================================================

CREATE TABLE devices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    device_name TEXT NOT NULL,
    device_id TEXT UNIQUE NOT NULL,
    status device_status DEFAULT 'active' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- BÖLÜM 5: UPDATED_AT TRİGGERLERİNİ OLUŞTUR
-- =====================================================

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Users tablosu için trigger
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Devices tablosu için trigger
CREATE TRIGGER update_devices_updated_at 
    BEFORE UPDATE ON devices 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- BÖLÜM 6: RLS POLİTİKALARINI OLUŞTUR
-- =====================================================

-- Users tablosu için RLS etkinleştir
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users tablosu politikaları
CREATE POLICY "Allow authenticated users to select profiles" 
    ON users FOR SELECT 
    TO authenticated 
    USING (true);

CREATE POLICY "Allow users to insert own profile" 
    ON users FOR INSERT 
    TO authenticated 
    WITH CHECK (auth.uid() = id);

CREATE POLICY "Allow users to update own profile" 
    ON users FOR UPDATE 
    TO authenticated 
    USING (auth.uid() = id);

-- Devices tablosu için RLS etkinleştir
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

-- Devices tablosu politikaları
CREATE POLICY "Allow users to select own devices" 
    ON devices FOR SELECT 
    TO authenticated 
    USING (user_id = auth.uid());

CREATE POLICY "Allow users to insert own devices" 
    ON devices FOR INSERT 
    TO authenticated 
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Allow users to update own devices" 
    ON devices FOR UPDATE 
    TO authenticated 
    USING (user_id = auth.uid());

-- BÖLÜM 7: İNDEKSLERİ OLUŞTUR
-- =====================================================

-- Users tablosu indeksleri
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

-- Devices tablosu indeksleri
CREATE INDEX IF NOT EXISTS idx_devices_user_id ON devices(user_id);
CREATE INDEX IF NOT EXISTS idx_devices_device_id ON devices(device_id);
CREATE INDEX IF NOT EXISTS idx_devices_status ON devices(status);

-- BÖLÜM 8: TEST VERİLERİ (OPSİYONEL)
-- =====================================================
-- Bu bölümü sadece test için kullanın, production'da çalıştırmayın

-- INSERT INTO users (id, email, full_name, role) VALUES 
-- ('11111111-1111-1111-1111-111111111111', 'test@example.com', 'Test User', 'parent');

-- =====================================================
-- SCRIPT TAMAMLANDI
-- =====================================================

-- Tabloları kontrol et
SELECT 'users' as table_name, count(*) as record_count FROM users
UNION ALL
SELECT 'devices' as table_name, count(*) as record_count FROM devices;

-- Politikaları kontrol et
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname; 