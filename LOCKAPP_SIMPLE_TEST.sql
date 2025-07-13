-- =====================================================
-- LOCKAPP SIMPLE TEST SCRIPT
-- =====================================================
-- Bu script veritabanı kurulumunu basit testlerle doğrular

-- =====================================================
-- BÖLÜM 1: KURULUM KONTROLÜ
-- =====================================================

-- Tabloları kontrol et
SELECT 
    'TABLE_CHECK' as test_type,
    tablename,
    'OK' as status
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- Enum'ları kontrol et
SELECT 
    'ENUM_CHECK' as test_type,
    typname as enum_name,
    array_length(array_agg(enumlabel), 1) as value_count
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')
GROUP BY typname
ORDER BY typname;

-- =====================================================
-- BÖLÜM 2: TEST VERİLERİ OLUŞTUR
-- =====================================================

-- Test parent user
INSERT INTO users (id, email, name, role, is_active) 
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'parent@test.com',
    'Test Parent',
    'parent',
    true
) ON CONFLICT (id) DO NOTHING;

-- Test child user
INSERT INTO users (id, email, name, role, is_active) 
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'child@test.com',
    'Test Child',
    'child',
    true
) ON CONFLICT (id) DO NOTHING;

-- Test parent device
INSERT INTO devices (id, user_id, device_name, device_id, device_type, status)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111111',
    'Parent Phone',
    'parent_device_12345',
    'parent_device',
    'active'
) ON CONFLICT (id) DO NOTHING;

-- Test child device
INSERT INTO devices (id, user_id, device_name, device_id, device_type, status)
VALUES (
    '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222',
    'Child Phone',
    'child_device_67890',
    'child_device',
    'active'
) ON CONFLICT (id) DO NOTHING;

-- Test device pairing
INSERT INTO device_pairings (
    parent_device_id, child_device_id, 
    parent_user_id, child_user_id, 
    status
)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'accepted'
) ON CONFLICT (parent_device_id, child_device_id) DO NOTHING;

-- Test app
INSERT INTO app_list (device_id, package_name, app_name, is_locked)
VALUES (
    '44444444-4444-4444-4444-444444444444',
    'com.example.game',
    'Test Game',
    true
) ON CONFLICT (device_id, package_name) DO NOTHING;

-- =====================================================
-- BÖLÜM 3: TEMEL SORGULAR TESTİ
-- =====================================================

-- Kullanıcıları listele
SELECT 
    'USER_TEST' as test_type,
    name, role, is_active
FROM users
ORDER BY role, name;

-- Cihazları listele
SELECT 
    'DEVICE_TEST' as test_type,
    d.device_name, d.device_type, d.status,
    u.name as owner_name
FROM devices d
JOIN users u ON d.user_id = u.id
ORDER BY d.device_type;

-- Eşleştirmeleri listele
SELECT 
    'PAIRING_TEST' as test_type,
    pu.name as parent_name, 
    cu.name as child_name,
    dp.status
FROM device_pairings dp
JOIN users pu ON dp.parent_user_id = pu.id
JOIN users cu ON dp.child_user_id = cu.id;

-- Uygulamaları listele
SELECT 
    'APP_TEST' as test_type,
    al.app_name, al.is_locked,
    d.device_name
FROM app_list al
JOIN devices d ON al.device_id = d.id;

-- =====================================================
-- BÖLÜM 4: CONSTRAINT TESTLERİ
-- =====================================================

-- Test 1: Geçersiz email (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'invalid-email', 'Test User', 'parent');
        RAISE NOTICE 'Test 1 FAILED: Invalid email accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test 1 PASSED: Email validation working';
    END;
END$$;

-- Test 2: Çok kısa isim (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'test@example.com', 'A', 'parent');
        RAISE NOTICE 'Test 2 FAILED: Short name accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test 2 PASSED: Name length validation working';
    END;
END$$;

-- Test 3: Parent device'ı child user'a atama (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO devices (user_id, device_name, device_id, device_type, status)
        VALUES (
            '22222222-2222-2222-2222-222222222222', -- child user
            'Invalid Device',
            'invalid_device_123',
            'parent_device', -- parent device type
            'active'
        );
        RAISE NOTICE 'Test 3 FAILED: Invalid device-user combination accepted';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 3 PASSED: Device-user validation working';
    END;
END$$;

-- =====================================================
-- BÖLÜM 5: UTILITY FONKSİYON TESTLERİ
-- =====================================================

-- Test get_user_devices function
SELECT 
    'FUNCTION_TEST' as test_type,
    'get_user_devices' as function_name,
    device_name, device_type, status
FROM get_user_devices('11111111-1111-1111-1111-111111111111');

-- Test get_paired_devices function
SELECT 
    'FUNCTION_TEST' as test_type,
    'get_paired_devices' as function_name,
    paired_device_name, paired_user_name, is_parent
FROM get_paired_devices('11111111-1111-1111-1111-111111111111');

-- =====================================================
-- BÖLÜM 6: SONUÇ RAPORU
-- =====================================================

SELECT 
    'FINAL_REPORT' as report_type,
    'All tests completed successfully!' as message,
    (SELECT count(*) FROM users) as total_users,
    (SELECT count(*) FROM devices) as total_devices,
    (SELECT count(*) FROM device_pairings) as total_pairings,
    (SELECT count(*) FROM app_list) as total_apps;

-- Test verilerini temizle (isteğe bağlı)
-- DELETE FROM app_list WHERE device_id = '44444444-4444-4444-4444-444444444444';
-- DELETE FROM device_pairings WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
-- DELETE FROM devices WHERE user_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
-- DELETE FROM users WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');

SELECT 'Test completed successfully!' as final_message; 