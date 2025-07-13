-- =====================================================
-- SUPABASE FORCE RESET - LOCKAPP DATABASE
-- =====================================================
-- Bu script tabloları zorla siler ve yeniden oluşturur

-- ADIM 1: TÜM BAĞLANTILARI KES
-- =====================================================
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = current_database() AND pid <> pg_backend_pid();

-- ADIM 2: TÜM POLİTİKALARI SİL
-- =====================================================
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname, tablename FROM pg_policies WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON ' || r.tablename;
    END LOOP;
END$$;

-- ADIM 3: TABLOLARI ZORLA SİL
-- =====================================================
DROP TABLE IF EXISTS devices CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ADIM 4: ENUM'LARI SİL
-- =====================================================
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS device_status CASCADE;

-- ADIM 5: TRIGGER FONKSİYONLARINI SİL
-- =====================================================
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- ADIM 6: ENUM'LARI YENİDEN OLUŞTUR
-- =====================================================
CREATE TYPE user_role AS ENUM ('parent', 'child');
CREATE TYPE device_status AS ENUM ('active', 'inactive', 'blocked');

-- ADIM 7: USERS TABLOSUNU OLUŞTUR
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

-- ADIM 8: DEVICES TABLOSUNU OLUŞTUR
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

-- ADIM 9: TRIGGER FONKSİYONUNU OLUŞTUR
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- ADIM 10: TRİGGERLERİ OLUŞTUR
-- =====================================================
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_devices_updated_at 
    BEFORE UPDATE ON devices 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ADIM 11: RLS'İ ETKİNLEŞTİR
-- =====================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

-- ADIM 12: USERS POLİTİKALARI
-- =====================================================
CREATE POLICY "users_select_policy" 
    ON users FOR SELECT 
    TO authenticated 
    USING (true);

CREATE POLICY "users_insert_policy" 
    ON users FOR INSERT 
    TO authenticated 
    WITH CHECK (auth.uid() = id);

CREATE POLICY "users_update_policy" 
    ON users FOR UPDATE 
    TO authenticated 
    USING (auth.uid() = id);

-- ADIM 13: DEVICES POLİTİKALARI
-- =====================================================
CREATE POLICY "devices_select_policy" 
    ON devices FOR SELECT 
    TO authenticated 
    USING (user_id = auth.uid());

CREATE POLICY "devices_insert_policy" 
    ON devices FOR INSERT 
    TO authenticated 
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "devices_update_policy" 
    ON devices FOR UPDATE 
    TO authenticated 
    USING (user_id = auth.uid());

-- ADIM 14: İNDEKSLERİ OLUŞTUR
-- =====================================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_devices_user_id ON devices(user_id);
CREATE INDEX idx_devices_device_id ON devices(device_id);
CREATE INDEX idx_devices_status ON devices(status);

-- ADIM 15: KONTROL
-- =====================================================
-- Tabloları kontrol et
SELECT 
    'users' as table_name, 
    count(*) as record_count,
    array_agg(column_name::text ORDER BY ordinal_position) as columns
FROM information_schema.columns 
WHERE table_name = 'users' AND table_schema = 'public'
GROUP BY table_name

UNION ALL

SELECT 
    'devices' as table_name, 
    count(*) as record_count,
    array_agg(column_name::text ORDER BY ordinal_position) as columns
FROM information_schema.columns 
WHERE table_name = 'devices' AND table_schema = 'public'
GROUP BY table_name;

-- Politikaları kontrol et
SELECT tablename, policyname, cmd, permissive 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- BAŞARILI MESAJI
SELECT 'Database reset completed successfully!' as status; 