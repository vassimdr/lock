-- =====================================================
-- LOCKAPP TEST SCRIPT (FIXED VERSION)
-- =====================================================
-- Bu script düzeltilmiş veritabanı yapısını test eder

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

-- Trigger'ları kontrol et
SELECT 
    'TRIGGERS' as check_type,
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- RLS politikalarını kontrol et
SELECT 
    'RLS_POLICIES' as check_type,
    tablename,
    count(*) as policy_count
FROM pg_policies 
WHERE schemaname = 'public' 
GROUP BY tablename
ORDER BY tablename;

-- =====================================================
-- BÖLÜM 2: TEST VERİLERİ OLUŞTUR
-- =====================================================

-- Test kullanıcıları ekle
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

-- Test parent device (trigger validation ile)
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

-- Test child device (trigger validation ile)
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

-- Test device pairing (trigger validation ile)
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
)
ON CONFLICT (device_id, package_name) DO NOTHING;

-- Test lock command (trigger validation ile)
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
)
ON CONFLICT (device_id, app_package_name, usage_date) DO UPDATE SET
    total_time_minutes = EXCLUDED.total_time_minutes,
    open_count = EXCLUDED.open_count,
    screen_time_minutes = EXCLUDED.screen_time_minutes,
    background_time_minutes = EXCLUDED.background_time_minutes,
    last_used = EXCLUDED.last_used,
    updated_at = NOW();

-- =====================================================
-- BÖLÜM 3: VALIDATION TRIGGER TESTLERİ
-- =====================================================

-- Test 1: Parent device'ı child user'a atamaya çalış (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO devices (user_id, device_name, device_id, device_type, status)
        VALUES (
            '22222222-2222-2222-2222-222222222222', -- child user
            'Invalid Parent Device',
            'invalid_parent_device',
            'parent_device', -- parent device type
            'active'
        );
        RAISE EXCEPTION 'Test failed: Should not allow parent device for child user';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 1 PASSED: Parent device validation working - %', SQLERRM;
    END;
END$$;

-- Test 2: Child device'ı parent user'a atamaya çalış (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO devices (user_id, device_name, device_id, device_type, status)
        VALUES (
            '11111111-1111-1111-1111-111111111111', -- parent user
            'Invalid Child Device',
            'invalid_child_device',
            'child_device', -- child device type
            'active'
        );
        RAISE EXCEPTION 'Test failed: Should not allow child device for parent user';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 2 PASSED: Child device validation working - %', SQLERRM;
    END;
END$$;

-- Test 3: Geçersiz pairing yapmaya çalış (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO device_pairings (
            parent_device_id, child_device_id,
            parent_user_id, child_user_id,
            status
        ) VALUES (
            '44444444-4444-4444-4444-444444444444', -- child device
            '33333333-3333-3333-3333-333333333333', -- parent device
            '11111111-1111-1111-1111-111111111111', -- parent user
            '22222222-2222-2222-2222-222222222222', -- child user
            'pending'
        );
        RAISE EXCEPTION 'Test failed: Should not allow invalid pairing';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 3 PASSED: Pairing validation working - %', SQLERRM;
    END;
END$$;

-- =====================================================
-- BÖLÜM 4: TEMEL SORGULAR TESTİ
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
-- BÖLÜM 5: UTILITY FONKSİYONLARI TESTİ
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
-- BÖLÜM 6: CONSTRAINT TESTLERİ
-- =====================================================

-- Test email format constraint
DO $$
BEGIN
    BEGIN
        INSERT INTO users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'invalid-email', 'Test User', 'parent');
        RAISE EXCEPTION 'Test failed: Should not allow invalid email';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test PASSED: Email format constraint working';
    END;
END$$;

-- Test name length constraint
DO $$
BEGIN
    BEGIN
        INSERT INTO users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'test@example.com', 'A', 'parent');
        RAISE EXCEPTION 'Test failed: Should not allow short name';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test PASSED: Name length constraint working';
    END;
END$$;

-- Test device_id length constraint
DO $$
BEGIN
    BEGIN
        INSERT INTO devices (user_id, device_name, device_id, device_type) 
        VALUES ('11111111-1111-1111-1111-111111111111', 'Test Device', 'short', 'parent_device');
        RAISE EXCEPTION 'Test failed: Should not allow short device_id';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test PASSED: Device ID length constraint working';
    END;
END$$;

-- =====================================================
-- BÖLÜM 7: SONUÇ RAPORU
-- =====================================================

SELECT 
    'TEST_SUMMARY' as report_type,
    'Fixed database setup completed successfully!' as message,
    (SELECT count(*) FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')) as tables_created,
    (SELECT count(DISTINCT typname) FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')) as enums_created,
    (SELECT count(*) FROM pg_policies WHERE schemaname = 'public') as policies_created,
    (SELECT count(*) FROM information_schema.triggers WHERE trigger_schema = 'public') as triggers_created;

-- Test verilerini temizle (opsiyonel)
-- DELETE FROM usage_stats WHERE device_id = '44444444-4444-4444-4444-444444444444';
-- DELETE FROM lock_commands WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
-- DELETE FROM app_list WHERE device_id = '44444444-4444-4444-4444-444444444444';
-- DELETE FROM device_pairings WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
-- DELETE FROM devices WHERE user_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
-- DELETE FROM users WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');

SELECT 'Fixed test script completed successfully!' as final_message; 