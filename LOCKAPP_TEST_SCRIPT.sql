-- =====================================================
-- LOCKAPP TEST SCRIPT
-- =====================================================
-- Bu script veritabanı kurulumunu test eder ve temel işlevselliği gösterir

-- =====================================================
-- BÖLÜM 1: KURULUM KONTROLÜ
-- =====================================================

-- Tabloları kontrol et
SELECT 
    'TABLES' as check_type,
    tablename,
    'EXISTS' as status
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- Enum'ları kontrol et
SELECT 
    'ENUMS' as check_type,
    typname as name,
    array_agg(enumlabel ORDER BY enumsortorder) as values
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')
GROUP BY typname
ORDER BY typname;

-- RLS politikalarını kontrol et
SELECT 
    'RLS_POLICIES' as check_type,
    tablename,
    count(*) as policy_count
FROM pg_policies 
WHERE schemaname = 'public' 
GROUP BY tablename
ORDER BY tablename;

-- İndeksleri kontrol et
SELECT 
    'INDEXES' as check_type,
    tablename,
    count(*) as index_count
FROM pg_indexes 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
GROUP BY tablename
ORDER BY tablename;

-- =====================================================
-- BÖLÜM 2: TEST VERİLERİ OLUŞTUR
-- =====================================================

-- Test kullanıcıları ekle (sadece test için)
-- NOT: Gerçek uygulamada bu veriler Supabase Auth üzerinden gelir

-- Test parent user
INSERT INTO users (id, email, name, role, is_active, created_at, updated_at) 
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'parent@test.com',
    'Test Parent',
    'parent',
    true,
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Test child user
INSERT INTO users (id, email, name, role, is_active, created_at, updated_at) 
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'child@test.com',
    'Test Child',
    'child',
    true,
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Test parent device
INSERT INTO devices (id, user_id, device_name, device_id, device_type, status, is_online, last_seen, created_at, updated_at)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111111',
    'Parent Phone',
    'parent_device_12345',
    'parent_device',
    'active',
    true,
    NOW(),
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Test child device
INSERT INTO devices (id, user_id, device_name, device_id, device_type, status, is_online, last_seen, created_at, updated_at)
VALUES (
    '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222',
    'Child Phone',
    'child_device_67890',
    'child_device',
    'active',
    true,
    NOW(),
    NOW(),
    NOW()
) ON CONFLICT (id) DO NOTHING;

-- Test device pairing
INSERT INTO device_pairings (
    parent_device_id, child_device_id, 
    parent_user_id, child_user_id, 
    status, paired_at, created_at, updated_at
)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'accepted',
    NOW(),
    NOW(),
    NOW()
) ON CONFLICT (parent_device_id, child_device_id) DO NOTHING;

-- Test app list
INSERT INTO app_list (
    device_id, package_name, app_name, version, 
    is_system_app, is_locked, lock_status, 
    created_at, updated_at
)
VALUES 
(
    '44444444-4444-4444-4444-444444444444',
    'com.example.game',
    'Test Game',
    '1.0.0',
    false,
    true,
    'locked',
    NOW(),
    NOW()
),
(
    '44444444-4444-4444-4444-444444444444',
    'com.android.chrome',
    'Chrome Browser',
    '100.0.0',
    false,
    false,
    'unlocked',
    NOW(),
    NOW()
),
(
    '44444444-4444-4444-4444-444444444444',
    'com.android.settings',
    'Settings',
    '1.0.0',
    true,
    false,
    'unlocked',
    NOW(),
    NOW()
)
ON CONFLICT (device_id, package_name) DO NOTHING;

-- Test lock command
INSERT INTO lock_commands (
    parent_device_id, child_device_id,
    parent_user_id, child_user_id,
    app_package_name, command_type, status,
    created_at, updated_at
)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'com.example.game',
    'lock',
    'executed',
    NOW(),
    NOW()
);

-- Test usage stats
INSERT INTO usage_stats (
    device_id, user_id, app_package_name, app_name,
    usage_date, total_time_minutes, open_count,
    screen_time_minutes, background_time_minutes,
    last_used, created_at, updated_at
)
VALUES 
(
    '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222',
    'com.example.game',
    'Test Game',
    CURRENT_DATE,
    120,
    5,
    100,
    20,
    NOW(),
    NOW(),
    NOW()
),
(
    '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222',
    'com.android.chrome',
    'Chrome Browser',
    CURRENT_DATE,
    60,
    10,
    50,
    10,
    NOW(),
    NOW(),
    NOW()
)
ON CONFLICT (device_id, app_package_name, usage_date) DO UPDATE SET
    total_time_minutes = EXCLUDED.total_time_minutes,
    open_count = EXCLUDED.open_count,
    screen_time_minutes = EXCLUDED.screen_time_minutes,
    background_time_minutes = EXCLUDED.background_time_minutes,
    last_used = EXCLUDED.last_used,
    updated_at = NOW();

-- =====================================================
-- BÖLÜM 3: TEMEL SORGULAR TESTİ
-- =====================================================

-- 1. Kullanıcıları listele
SELECT 
    'USER_LIST' as test_name,
    id, email, name, role, is_active
FROM users
ORDER BY role, name;

-- 2. Cihazları listele
SELECT 
    'DEVICE_LIST' as test_name,
    d.id, d.device_name, d.device_type, d.status, d.is_online,
    u.name as owner_name, u.role as owner_role
FROM devices d
JOIN users u ON d.user_id = u.id
ORDER BY d.device_type, d.device_name;

-- 3. Cihaz eşleştirmelerini listele
SELECT 
    'DEVICE_PAIRINGS' as test_name,
    dp.id, dp.status,
    pu.name as parent_name, pd.device_name as parent_device,
    cu.name as child_name, cd.device_name as child_device
FROM device_pairings dp
JOIN users pu ON dp.parent_user_id = pu.id
JOIN users cu ON dp.child_user_id = cu.id
JOIN devices pd ON dp.parent_device_id = pd.id
JOIN devices cd ON dp.child_device_id = cd.id
ORDER BY dp.created_at;

-- 4. Uygulama listesini göster
SELECT 
    'APP_LIST' as test_name,
    al.app_name, al.package_name, al.is_locked, al.lock_status,
    d.device_name, u.name as device_owner
FROM app_list al
JOIN devices d ON al.device_id = d.id
JOIN users u ON d.user_id = u.id
ORDER BY d.device_name, al.app_name;

-- 5. Kilit komutlarını listele
SELECT 
    'LOCK_COMMANDS' as test_name,
    lc.app_package_name, lc.command_type, lc.status,
    pu.name as parent_name, cu.name as child_name,
    lc.created_at
FROM lock_commands lc
JOIN users pu ON lc.parent_user_id = pu.id
JOIN users cu ON lc.child_user_id = cu.id
ORDER BY lc.created_at DESC;

-- 6. Kullanım istatistiklerini göster
SELECT 
    'USAGE_STATS' as test_name,
    us.app_name, us.usage_date, us.total_time_minutes, us.open_count,
    u.name as user_name, d.device_name
FROM usage_stats us
JOIN devices d ON us.device_id = d.id
JOIN users u ON us.user_id = u.id
ORDER BY us.usage_date DESC, us.total_time_minutes DESC;

-- =====================================================
-- BÖLÜM 4: UTILITY FONKSİYONLARI TESTİ
-- =====================================================

-- Test get_user_devices function
SELECT 
    'GET_USER_DEVICES' as test_name,
    device_name, device_type, status, is_online
FROM get_user_devices('11111111-1111-1111-1111-111111111111');

-- Test get_paired_devices function
SELECT 
    'GET_PAIRED_DEVICES' as test_name,
    paired_device_name, paired_user_name, pairing_status, is_parent
FROM get_paired_devices('11111111-1111-1111-1111-111111111111');

-- =====================================================
-- BÖLÜM 5: PERFORMANS TESTİ
-- =====================================================

-- Index kullanımını kontrol et
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM devices WHERE user_id = '11111111-1111-1111-1111-111111111111';

EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM app_list WHERE device_id = '44444444-4444-4444-4444-444444444444';

EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM usage_stats WHERE device_id = '44444444-4444-4444-4444-444444444444' AND usage_date = CURRENT_DATE;

-- =====================================================
-- BÖLÜM 6: GÜVENLIK TESTİ
-- =====================================================

-- RLS politikalarının aktif olduğunu kontrol et
SELECT 
    'RLS_STATUS' as test_name,
    schemaname, tablename, rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- Constraint'lerin aktif olduğunu kontrol et
SELECT 
    'CONSTRAINTS' as test_name,
    conname, contype, 
    CASE contype 
        WHEN 'c' THEN 'CHECK'
        WHEN 'f' THEN 'FOREIGN KEY'
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'u' THEN 'UNIQUE'
        ELSE contype::text
    END as constraint_type
FROM pg_constraint 
WHERE connamespace = 'public'::regnamespace
ORDER BY conname;

-- =====================================================
-- BÖLÜM 7: SONUÇ RAPORU
-- =====================================================

SELECT 
    'TEST_SUMMARY' as report_type,
    'Database setup completed successfully!' as message,
    (SELECT count(*) FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')) as tables_created,
    (SELECT count(DISTINCT typname) FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')) as enums_created,
    (SELECT count(*) FROM pg_policies WHERE schemaname = 'public') as policies_created,
    (SELECT count(*) FROM pg_indexes WHERE schemaname = 'public' AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')) as indexes_created;

-- Test verilerini temizle (opsiyonel)
-- DELETE FROM usage_stats WHERE device_id = '44444444-4444-4444-4444-444444444444';
-- DELETE FROM lock_commands WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
-- DELETE FROM app_list WHERE device_id = '44444444-4444-4444-4444-444444444444';
-- DELETE FROM device_pairings WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
-- DELETE FROM devices WHERE user_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
-- DELETE FROM users WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');

SELECT 'Test script completed successfully!' as final_message; 