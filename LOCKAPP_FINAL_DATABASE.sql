-- =====================================================
-- LOCKAPP FINAL DATABASE STRUCTURE
-- =====================================================
-- Bu script LockApp projesi için HATASIZ veritabanı yapısı oluşturur
-- Tüm PostgreSQL hatalar düzeltildi ve test edildi

-- =====================================================
-- BÖLÜM 1: MEVCUT YAPIYI TEMİZLE
-- =====================================================

-- Mevcut politikaları sil
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT policyname, tablename FROM pg_policies WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP POLICY IF EXISTS "' || r.policyname || '" ON ' || r.tablename;
    END LOOP;
END$$;

-- Mevcut tabloları sil (bağımlılık sırasına göre)
DROP TABLE IF EXISTS usage_stats CASCADE;
DROP TABLE IF EXISTS lock_commands CASCADE;
DROP TABLE IF EXISTS app_list CASCADE;
DROP TABLE IF EXISTS device_pairings CASCADE;
DROP TABLE IF EXISTS devices CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Mevcut enum'ları sil
DROP TYPE IF EXISTS user_role CASCADE;
DROP TYPE IF EXISTS device_status CASCADE;
DROP TYPE IF EXISTS device_type CASCADE;
DROP TYPE IF EXISTS lock_status CASCADE;
DROP TYPE IF EXISTS command_status CASCADE;
DROP TYPE IF EXISTS pairing_status CASCADE;

-- Mevcut fonksiyonları sil
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS validate_device_user_role() CASCADE;
DROP FUNCTION IF EXISTS validate_pairing_relationship() CASCADE;
DROP FUNCTION IF EXISTS validate_lock_command_relationship() CASCADE;
DROP FUNCTION IF EXISTS get_user_devices(UUID) CASCADE;
DROP FUNCTION IF EXISTS get_paired_devices(UUID) CASCADE;

-- =====================================================
-- BÖLÜM 2: ENUM TİPLERİNİ OLUŞTUR
-- =====================================================

CREATE TYPE user_role AS ENUM ('parent', 'child');
CREATE TYPE device_status AS ENUM ('active', 'inactive', 'blocked', 'pending');
CREATE TYPE device_type AS ENUM ('parent_device', 'child_device');
CREATE TYPE lock_status AS ENUM ('locked', 'unlocked', 'temporary_unlock');
CREATE TYPE command_status AS ENUM ('pending', 'sent', 'delivered', 'executed', 'failed', 'expired');
CREATE TYPE pairing_status AS ENUM ('pending', 'accepted', 'rejected', 'expired');

-- =====================================================
-- BÖLÜM 3: USERS TABLOSU
-- =====================================================

CREATE TABLE users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role user_role NOT NULL DEFAULT 'parent',
    profile_image_url TEXT,
    phone_number TEXT,
    is_active BOOLEAN DEFAULT true NOT NULL,
    is_verified BOOLEAN DEFAULT false NOT NULL,
    last_login_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Basit CHECK constraints (subquery olmadan)
    CONSTRAINT users_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT users_name_length CHECK (length(name) >= 2 AND length(name) <= 50),
    CONSTRAINT users_phone_format CHECK (phone_number IS NULL OR phone_number ~* '^\+?[1-9]\d{1,14}$')
);

-- =====================================================
-- BÖLÜM 4: DEVICES TABLOSU
-- =====================================================

CREATE TABLE devices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    device_name TEXT NOT NULL,
    device_id TEXT UNIQUE NOT NULL,
    device_type device_type NOT NULL,
    status device_status DEFAULT 'pending' NOT NULL,
    os_version TEXT,
    app_version TEXT,
    device_model TEXT,
    is_online BOOLEAN DEFAULT false NOT NULL,
    last_seen TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    settings JSONB DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Basit CHECK constraints
    CONSTRAINT devices_name_length CHECK (length(device_name) >= 2 AND length(device_name) <= 50),
    CONSTRAINT devices_device_id_format CHECK (length(device_id) >= 10)
);

-- =====================================================
-- BÖLÜM 5: DEVICE PAIRINGS TABLOSU
-- =====================================================

CREATE TABLE device_pairings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    parent_device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    child_device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    parent_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    child_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    status pairing_status DEFAULT 'pending' NOT NULL,
    pairing_code TEXT,
    expires_at TIMESTAMP WITH TIME ZONE,
    paired_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Constraints
    CONSTRAINT device_pairings_different_devices CHECK (parent_device_id != child_device_id),
    CONSTRAINT device_pairings_different_users CHECK (parent_user_id != child_user_id),
    CONSTRAINT device_pairings_unique_pair UNIQUE (parent_device_id, child_device_id)
);

-- =====================================================
-- BÖLÜM 6: APP LIST TABLOSU
-- =====================================================

CREATE TABLE app_list (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    package_name TEXT NOT NULL,
    app_name TEXT NOT NULL,
    version TEXT,
    icon_url TEXT,
    category TEXT,
    is_system_app BOOLEAN DEFAULT false NOT NULL,
    is_locked BOOLEAN DEFAULT false NOT NULL,
    lock_status lock_status DEFAULT 'unlocked' NOT NULL,
    install_date TIMESTAMP WITH TIME ZONE,
    last_updated TIMESTAMP WITH TIME ZONE,
    size_mb INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Constraints
    CONSTRAINT app_list_package_name_format CHECK (length(package_name) >= 3),
    CONSTRAINT app_list_app_name_length CHECK (length(app_name) >= 1 AND length(app_name) <= 100),
    CONSTRAINT app_list_valid_size CHECK (size_mb >= 0),
    CONSTRAINT app_list_unique_device_package UNIQUE (device_id, package_name)
);

-- =====================================================
-- BÖLÜM 7: LOCK COMMANDS TABLOSU
-- =====================================================

CREATE TABLE lock_commands (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    parent_device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    child_device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    parent_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    child_user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    app_package_name TEXT NOT NULL,
    command_type TEXT NOT NULL CHECK (command_type IN ('lock', 'unlock', 'temporary_unlock')),
    status command_status DEFAULT 'pending' NOT NULL,
    duration_minutes INTEGER,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    delivered_at TIMESTAMP WITH TIME ZONE,
    executed_at TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Constraints
    CONSTRAINT lock_commands_different_devices CHECK (parent_device_id != child_device_id),
    CONSTRAINT lock_commands_different_users CHECK (parent_user_id != child_user_id),
    CONSTRAINT lock_commands_valid_duration CHECK (
        (command_type = 'temporary_unlock' AND duration_minutes > 0) OR
        (command_type != 'temporary_unlock' AND duration_minutes IS NULL)
    ),
    CONSTRAINT lock_commands_valid_retry CHECK (retry_count >= 0 AND retry_count <= 5)
);

-- =====================================================
-- BÖLÜM 8: USAGE STATS TABLOSU
-- =====================================================

CREATE TABLE usage_stats (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    app_package_name TEXT NOT NULL,
    app_name TEXT NOT NULL,
    usage_date DATE NOT NULL,
    total_time_minutes INTEGER DEFAULT 0 NOT NULL,
    open_count INTEGER DEFAULT 0 NOT NULL,
    last_used TIMESTAMP WITH TIME ZONE,
    screen_time_minutes INTEGER DEFAULT 0 NOT NULL,
    background_time_minutes INTEGER DEFAULT 0 NOT NULL,
    is_locked_during_usage BOOLEAN DEFAULT false NOT NULL,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    
    -- Constraints
    CONSTRAINT usage_stats_valid_times CHECK (
        total_time_minutes >= 0 AND
        open_count >= 0 AND
        screen_time_minutes >= 0 AND
        background_time_minutes >= 0 AND
        total_time_minutes = screen_time_minutes + background_time_minutes
    ),
    CONSTRAINT usage_stats_unique_device_app_date UNIQUE (device_id, app_package_name, usage_date)
);

-- =====================================================
-- BÖLÜM 9: TRIGGER FONKSİYONLARINI OLUŞTUR
-- =====================================================

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Device-user role validation function
CREATE OR REPLACE FUNCTION validate_device_user_role()
RETURNS TRIGGER AS $$
BEGIN
    -- Parent device parent user'a ait olmalı
    IF NEW.device_type = 'parent_device' THEN
        IF NOT EXISTS (
            SELECT 1 FROM users 
            WHERE id = NEW.user_id AND role = 'parent'
        ) THEN
            RAISE EXCEPTION 'Parent device must belong to a parent user';
        END IF;
    END IF;
    
    -- Child device child user'a ait olmalı
    IF NEW.device_type = 'child_device' THEN
        IF NOT EXISTS (
            SELECT 1 FROM users 
            WHERE id = NEW.user_id AND role = 'child'
        ) THEN
            RAISE EXCEPTION 'Child device must belong to a child user';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Pairing relationship validation function
CREATE OR REPLACE FUNCTION validate_pairing_relationship()
RETURNS TRIGGER AS $$
BEGIN
    -- Parent device ve parent user kontrolü
    IF NOT EXISTS (
        SELECT 1 FROM devices d
        JOIN users u ON d.user_id = u.id
        WHERE d.id = NEW.parent_device_id 
        AND u.id = NEW.parent_user_id 
        AND u.role = 'parent'
        AND d.device_type = 'parent_device'
    ) THEN
        RAISE EXCEPTION 'Parent device validation failed';
    END IF;
    
    -- Child device ve child user kontrolü
    IF NOT EXISTS (
        SELECT 1 FROM devices d
        JOIN users u ON d.user_id = u.id
        WHERE d.id = NEW.child_device_id 
        AND u.id = NEW.child_user_id 
        AND u.role = 'child'
        AND d.device_type = 'child_device'
    ) THEN
        RAISE EXCEPTION 'Child device validation failed';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Lock command relationship validation function
CREATE OR REPLACE FUNCTION validate_lock_command_relationship()
RETURNS TRIGGER AS $$
BEGIN
    -- Parent device ve parent user kontrolü
    IF NOT EXISTS (
        SELECT 1 FROM devices d
        JOIN users u ON d.user_id = u.id
        WHERE d.id = NEW.parent_device_id 
        AND u.id = NEW.parent_user_id 
        AND u.role = 'parent'
        AND d.device_type = 'parent_device'
    ) THEN
        RAISE EXCEPTION 'Parent device validation failed for lock command';
    END IF;
    
    -- Child device ve child user kontrolü
    IF NOT EXISTS (
        SELECT 1 FROM devices d
        JOIN users u ON d.user_id = u.id
        WHERE d.id = NEW.child_device_id 
        AND u.id = NEW.child_user_id 
        AND u.role = 'child'
        AND d.device_type = 'child_device'
    ) THEN
        RAISE EXCEPTION 'Child device validation failed for lock command';
    END IF;
    
    -- Pairing kontrolü
    IF NOT EXISTS (
        SELECT 1 FROM device_pairings dp
        WHERE dp.parent_device_id = NEW.parent_device_id 
        AND dp.child_device_id = NEW.child_device_id
        AND dp.status = 'accepted'
    ) THEN
        RAISE EXCEPTION 'Devices are not paired or pairing is not accepted';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- BÖLÜM 10: TRİGGERLERİ OLUŞTUR
-- =====================================================

-- Updated_at triggers
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_devices_updated_at 
    BEFORE UPDATE ON devices 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_device_pairings_updated_at 
    BEFORE UPDATE ON device_pairings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_list_updated_at 
    BEFORE UPDATE ON app_list 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lock_commands_updated_at 
    BEFORE UPDATE ON lock_commands 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_usage_stats_updated_at 
    BEFORE UPDATE ON usage_stats 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Validation triggers
CREATE TRIGGER validate_device_user_role_trigger
    BEFORE INSERT OR UPDATE ON devices
    FOR EACH ROW EXECUTE FUNCTION validate_device_user_role();

CREATE TRIGGER validate_pairing_relationship_trigger
    BEFORE INSERT OR UPDATE ON device_pairings
    FOR EACH ROW EXECUTE FUNCTION validate_pairing_relationship();

CREATE TRIGGER validate_lock_command_relationship_trigger
    BEFORE INSERT OR UPDATE ON lock_commands
    FOR EACH ROW EXECUTE FUNCTION validate_lock_command_relationship();

-- =====================================================
-- BÖLÜM 11: ROW LEVEL SECURITY'Yİ ETKİNLEŞTİR
-- =====================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;
ALTER TABLE device_pairings ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_list ENABLE ROW LEVEL SECURITY;
ALTER TABLE lock_commands ENABLE ROW LEVEL SECURITY;
ALTER TABLE usage_stats ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- BÖLÜM 12: RLS POLİTİKALARINI OLUŞTUR
-- =====================================================

-- USERS POLICIES
CREATE POLICY "users_select_policy" ON users FOR SELECT TO authenticated USING (true);
CREATE POLICY "users_insert_policy" ON users FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);
CREATE POLICY "users_update_policy" ON users FOR UPDATE TO authenticated USING (auth.uid() = id);

-- DEVICES POLICIES
CREATE POLICY "devices_select_policy" ON devices FOR SELECT TO authenticated USING (
    user_id = auth.uid() OR
    EXISTS (
        SELECT 1 FROM device_pairings dp
        WHERE (dp.parent_device_id = devices.id AND dp.child_user_id = auth.uid()) OR
              (dp.child_device_id = devices.id AND dp.parent_user_id = auth.uid())
    )
);
CREATE POLICY "devices_insert_policy" ON devices FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "devices_update_policy" ON devices FOR UPDATE TO authenticated USING (user_id = auth.uid());

-- DEVICE PAIRINGS POLICIES
CREATE POLICY "device_pairings_select_policy" ON device_pairings FOR SELECT TO authenticated USING (
    parent_user_id = auth.uid() OR child_user_id = auth.uid()
);
CREATE POLICY "device_pairings_insert_policy" ON device_pairings FOR INSERT TO authenticated WITH CHECK (
    parent_user_id = auth.uid() AND
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'parent')
);
CREATE POLICY "device_pairings_update_policy" ON device_pairings FOR UPDATE TO authenticated USING (
    parent_user_id = auth.uid() OR child_user_id = auth.uid()
);

-- APP LIST POLICIES
CREATE POLICY "app_list_select_policy" ON app_list FOR SELECT TO authenticated USING (
    EXISTS (
        SELECT 1 FROM devices d
        WHERE d.id = app_list.device_id AND (
            d.user_id = auth.uid() OR
            EXISTS (
                SELECT 1 FROM device_pairings dp
                WHERE (dp.parent_device_id = d.id AND dp.child_user_id = auth.uid()) OR
                      (dp.child_device_id = d.id AND dp.parent_user_id = auth.uid())
            )
        )
    )
);
CREATE POLICY "app_list_insert_policy" ON app_list FOR INSERT TO authenticated WITH CHECK (
    EXISTS (SELECT 1 FROM devices d WHERE d.id = app_list.device_id AND d.user_id = auth.uid())
);
CREATE POLICY "app_list_update_policy" ON app_list FOR UPDATE TO authenticated USING (
    EXISTS (SELECT 1 FROM devices d WHERE d.id = app_list.device_id AND d.user_id = auth.uid())
);

-- LOCK COMMANDS POLICIES
CREATE POLICY "lock_commands_select_policy" ON lock_commands FOR SELECT TO authenticated USING (
    parent_user_id = auth.uid() OR child_user_id = auth.uid()
);
CREATE POLICY "lock_commands_insert_policy" ON lock_commands FOR INSERT TO authenticated WITH CHECK (
    parent_user_id = auth.uid() AND
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'parent')
);
CREATE POLICY "lock_commands_update_policy" ON lock_commands FOR UPDATE TO authenticated USING (
    parent_user_id = auth.uid() OR child_user_id = auth.uid()
);

-- USAGE STATS POLICIES
CREATE POLICY "usage_stats_select_policy" ON usage_stats FOR SELECT TO authenticated USING (
    user_id = auth.uid() OR
    EXISTS (
        SELECT 1 FROM devices d
        JOIN device_pairings dp ON (
            (dp.parent_device_id = d.id AND dp.child_user_id = auth.uid()) OR
            (dp.child_device_id = d.id AND dp.parent_user_id = auth.uid())
        )
        WHERE d.id = usage_stats.device_id
    )
);
CREATE POLICY "usage_stats_insert_policy" ON usage_stats FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "usage_stats_update_policy" ON usage_stats FOR UPDATE TO authenticated USING (user_id = auth.uid());

-- =====================================================
-- BÖLÜM 13: İNDEKSLERİ OLUŞTUR
-- =====================================================

-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- Devices table indexes
CREATE INDEX idx_devices_user_id ON devices(user_id);
CREATE INDEX idx_devices_device_id ON devices(device_id);
CREATE INDEX idx_devices_status ON devices(status);
CREATE INDEX idx_devices_device_type ON devices(device_type);
CREATE INDEX idx_devices_is_online ON devices(is_online);

-- Device pairings table indexes
CREATE INDEX idx_device_pairings_parent_device ON device_pairings(parent_device_id);
CREATE INDEX idx_device_pairings_child_device ON device_pairings(child_device_id);
CREATE INDEX idx_device_pairings_parent_user ON device_pairings(parent_user_id);
CREATE INDEX idx_device_pairings_child_user ON device_pairings(child_user_id);
CREATE INDEX idx_device_pairings_status ON device_pairings(status);

-- App list table indexes
CREATE INDEX idx_app_list_device_id ON app_list(device_id);
CREATE INDEX idx_app_list_package_name ON app_list(package_name);
CREATE INDEX idx_app_list_is_locked ON app_list(is_locked);

-- Lock commands table indexes
CREATE INDEX idx_lock_commands_parent_device ON lock_commands(parent_device_id);
CREATE INDEX idx_lock_commands_child_device ON lock_commands(child_device_id);
CREATE INDEX idx_lock_commands_status ON lock_commands(status);
CREATE INDEX idx_lock_commands_created_at ON lock_commands(created_at);

-- Usage stats table indexes
CREATE INDEX idx_usage_stats_device_id ON usage_stats(device_id);
CREATE INDEX idx_usage_stats_user_id ON usage_stats(user_id);
CREATE INDEX idx_usage_stats_usage_date ON usage_stats(usage_date);
CREATE INDEX idx_usage_stats_device_date ON usage_stats(device_id, usage_date);

-- =====================================================
-- BÖLÜM 14: UTILITY FONKSİYONLARI
-- =====================================================

-- Get user's devices
CREATE OR REPLACE FUNCTION get_user_devices(user_uuid UUID)
RETURNS TABLE (
    device_id UUID,
    device_name TEXT,
    device_type device_type,
    status device_status,
    is_online BOOLEAN,
    last_seen TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT d.id, d.device_name, d.device_type, d.status, d.is_online, d.last_seen
    FROM devices d
    WHERE d.user_id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get paired devices
CREATE OR REPLACE FUNCTION get_paired_devices(user_uuid UUID)
RETURNS TABLE (
    pairing_id UUID,
    paired_device_id UUID,
    paired_device_name TEXT,
    paired_user_name TEXT,
    pairing_status pairing_status,
    is_parent BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        dp.id,
        CASE 
            WHEN dp.parent_user_id = user_uuid THEN dp.child_device_id
            ELSE dp.parent_device_id
        END,
        CASE 
            WHEN dp.parent_user_id = user_uuid THEN cd.device_name
            ELSE pd.device_name
        END,
        CASE 
            WHEN dp.parent_user_id = user_uuid THEN cu.name
            ELSE pu.name
        END,
        dp.status,
        dp.parent_user_id = user_uuid
    FROM device_pairings dp
    JOIN devices pd ON dp.parent_device_id = pd.id
    JOIN devices cd ON dp.child_device_id = cd.id
    JOIN users pu ON dp.parent_user_id = pu.id
    JOIN users cu ON dp.child_user_id = cu.id
    WHERE dp.parent_user_id = user_uuid OR dp.child_user_id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- BÖLÜM 15: KONTROL VE DOĞRULAMA
-- =====================================================

-- Tabloları kontrol et
SELECT 
    'TABLES_CREATED' as status,
    count(*) as table_count
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats');

-- Enum'ları kontrol et
SELECT 
    'ENUMS_CREATED' as status,
    count(DISTINCT typname) as enum_count
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status');

-- Politikaları kontrol et
SELECT 
    'POLICIES_CREATED' as status,
    count(*) as policy_count
FROM pg_policies 
WHERE schemaname = 'public';

-- Trigger'ları kontrol et
SELECT 
    'TRIGGERS_CREATED' as status,
    count(*) as trigger_count
FROM information_schema.triggers
WHERE trigger_schema = 'public';

-- Başarı mesajı
SELECT 'LockApp Final Database Structure Created Successfully!' as final_status; 