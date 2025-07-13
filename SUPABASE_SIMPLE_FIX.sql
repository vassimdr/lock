-- =====================================================
-- SUPABASE SIMPLE FIX - LOCKAPP DATABASE
-- =====================================================
-- Bu script mevcut tabloya eksik kolonları ekler

-- ADIM 1: Users tablosuna eksik kolonları ekle
-- =====================================================

-- is_active kolonunu ekle (eğer yoksa)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'is_active') THEN
        ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true NOT NULL;
    END IF;
END $$;

-- profile_image_url kolonunu ekle (eğer yoksa)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'profile_image_url') THEN
        ALTER TABLE users ADD COLUMN profile_image_url TEXT;
    END IF;
END $$;

-- metadata kolonunu ekle (eğer yoksa)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'metadata') THEN
        ALTER TABLE users ADD COLUMN metadata JSONB;
    END IF;
END $$;

-- name kolonunu ekle ve full_name'den kopyala (eğer yoksa)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'name') THEN
        ALTER TABLE users ADD COLUMN name TEXT;
        
        -- Eğer full_name kolonu varsa, değerleri kopyala
        IF EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'full_name') THEN
            UPDATE users SET name = full_name WHERE full_name IS NOT NULL;
        END IF;
        
        -- name kolonunu NOT NULL yap
        ALTER TABLE users ALTER COLUMN name SET NOT NULL;
    END IF;
END $$;

-- ADIM 2: Enum'ları oluştur (eğer yoksa)
-- =====================================================

-- user_role enum'ını oluştur
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'user_role') THEN
        CREATE TYPE user_role AS ENUM ('parent', 'child');
    END IF;
END $$;

-- device_status enum'ını oluştur
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'device_status') THEN
        CREATE TYPE device_status AS ENUM ('active', 'inactive', 'blocked');
    END IF;
END $$;

-- ADIM 3: Role kolonunu enum'a çevir
-- =====================================================

-- Önce role kolonunun tipini kontrol et ve gerekirse güncelle
DO $$ 
BEGIN
    -- Eğer role kolonu text ise, enum'a çevir
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'users' AND column_name = 'role' AND data_type = 'text') THEN
        ALTER TABLE users ALTER COLUMN role TYPE user_role USING role::user_role;
    END IF;
    
    -- Eğer role kolonu yoksa, ekle
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'users' AND column_name = 'role') THEN
        ALTER TABLE users ADD COLUMN role user_role DEFAULT 'parent' NOT NULL;
    END IF;
END $$;

-- ADIM 4: Devices tablosunu oluştur (eğer yoksa)
-- =====================================================

CREATE TABLE IF NOT EXISTS devices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    device_name TEXT NOT NULL,
    device_id TEXT UNIQUE NOT NULL,
    status device_status DEFAULT 'active' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ADIM 5: Trigger fonksiyonu oluştur
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- ADIM 6: Trigger'ları oluştur
-- =====================================================

-- Users tablosu trigger'ı
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Devices tablosu trigger'ı
DROP TRIGGER IF EXISTS update_devices_updated_at ON devices;
CREATE TRIGGER update_devices_updated_at 
    BEFORE UPDATE ON devices 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ADIM 7: RLS'i etkinleştir
-- =====================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

-- ADIM 8: Politikaları oluştur (eğer yoksa)
-- =====================================================

-- Users politikaları
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_select_policy' AND tablename = 'users') THEN
        CREATE POLICY "users_select_policy" 
            ON users FOR SELECT 
            TO authenticated 
            USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_insert_policy' AND tablename = 'users') THEN
        CREATE POLICY "users_insert_policy" 
            ON users FOR INSERT 
            TO authenticated 
            WITH CHECK (auth.uid() = id);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'users_update_policy' AND tablename = 'users') THEN
        CREATE POLICY "users_update_policy" 
            ON users FOR UPDATE 
            TO authenticated 
            USING (auth.uid() = id);
    END IF;
END $$;

-- Devices politikaları
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'devices_select_policy' AND tablename = 'devices') THEN
        CREATE POLICY "devices_select_policy" 
            ON devices FOR SELECT 
            TO authenticated 
            USING (user_id = auth.uid());
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'devices_insert_policy' AND tablename = 'devices') THEN
        CREATE POLICY "devices_insert_policy" 
            ON devices FOR INSERT 
            TO authenticated 
            WITH CHECK (user_id = auth.uid());
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'devices_update_policy' AND tablename = 'devices') THEN
        CREATE POLICY "devices_update_policy" 
            ON devices FOR UPDATE 
            TO authenticated 
            USING (user_id = auth.uid());
    END IF;
END $$;

-- ADIM 9: İndeksleri oluştur
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_devices_user_id ON devices(user_id);
CREATE INDEX IF NOT EXISTS idx_devices_device_id ON devices(device_id);
CREATE INDEX IF NOT EXISTS idx_devices_status ON devices(status);

-- ADIM 10: Kontrol
-- =====================================================

-- Tabloları kontrol et
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('users', 'devices') 
    AND table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- Başarılı mesajı
SELECT 'Database update completed successfully!' as status; 