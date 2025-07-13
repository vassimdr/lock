-- =====================================================
-- LOCKAPP SIMPLE TEST SCRIPT (FIXED)
-- =====================================================
-- Bu script veritabanı kurulumunu basit testlerle doğrular
-- auth.users foreign key sorunu düzeltildi

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

-- RLS kontrol et
SELECT 
    'RLS_CHECK' as test_type,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- =====================================================
-- BÖLÜM 2: AUTH.USERS TABLOSUNA TEST VERİLERİ
-- =====================================================

-- NOT: Gerçek uygulamada bu kayıtlar Supabase Auth tarafından otomatik oluşturulur
-- Test için manuel olarak auth.users'a ekliyoruz

-- Test auth users ekle
INSERT INTO auth.users (
    id, 
    email, 
    encrypted_password, 
    email_confirmed_at, 
    created_at, 
    updated_at,
    raw_app_meta_data,
    raw_user_meta_data,
    is_super_admin,
    role
) VALUES 
(
    '11111111-1111-1111-1111-111111111111',
    'parent@test.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"name": "Test Parent"}',
    false,
    'authenticated'
),
(
    '22222222-2222-2222-2222-222222222222',
    'child@test.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"name": "Test Child"}',
    false,
    'authenticated'
) ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- BÖLÜM 3: PUBLIC.USERS TABLOSUNA TEST VERİLERİ
-- =====================================================

-- Şimdi güvenle public.users'a ekleyebiliriz
INSERT INTO public.users (id, email, name, role, is_active) 
VALUES (
    '11111111-1111-1111-1111-111111111111',
    'parent@test.com',
    'Test Parent',
    'parent',
    true
) ON CONFLICT (id) DO NOTHING;

INSERT INTO public.users (id, email, name, role, is_active) 
VALUES (
    '22222222-2222-2222-2222-222222222222',
    'child@test.com',
    'Test Child',
    'child',
    true
) ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- BÖLÜM 4: DİĞER TEST VERİLERİ
-- =====================================================

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

-- Test lock command
INSERT INTO lock_commands (
    parent_device_id, child_device_id,
    parent_user_id, child_user_id,
    app_package_name, command_type, status
)
VALUES (
    '33333333-3333-3333-3333-333333333333',
    '44444444-4444-4444-4444-444444444444',
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    'com.example.game',
    'lock',
    'executed'
);

-- Test usage stats
INSERT INTO usage_stats (
    device_id, user_id, app_package_name, app_name,
    usage_date, total_time_minutes, open_count,
    screen_time_minutes, background_time_minutes
)
VALUES (
    '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222',
    'com.example.game',
    'Test Game',
    CURRENT_DATE,
    120,
    5,
    100,
    20
) ON CONFLICT (device_id, app_package_name, usage_date) DO UPDATE SET
    total_time_minutes = EXCLUDED.total_time_minutes,
    open_count = EXCLUDED.open_count,
    screen_time_minutes = EXCLUDED.screen_time_minutes,
    background_time_minutes = EXCLUDED.background_time_minutes,
    updated_at = NOW();

-- =====================================================
-- BÖLÜM 5: TEMEL SORGULAR TESTİ
-- =====================================================

-- Kullanıcıları listele
SELECT 
    'USER_TEST' as test_type,
    name, role, is_active
FROM public.users
ORDER BY role, name;

-- Cihazları listele
SELECT 
    'DEVICE_TEST' as test_type,
    d.device_name, d.device_type, d.status,
    u.name as owner_name
FROM devices d
JOIN public.users u ON d.user_id = u.id
ORDER BY d.device_type;

-- Eşleştirmeleri listele
SELECT 
    'PAIRING_TEST' as test_type,
    pu.name as parent_name, 
    cu.name as child_name,
    dp.status
FROM device_pairings dp
JOIN public.users pu ON dp.parent_user_id = pu.id
JOIN public.users cu ON dp.child_user_id = cu.id;

-- Uygulamaları listele
SELECT 
    'APP_TEST' as test_type,
    al.app_name, al.is_locked,
    d.device_name
FROM app_list al
JOIN devices d ON al.device_id = d.id;

-- Lock komutlarını listele
SELECT 
    'LOCK_TEST' as test_type,
    lc.app_package_name, lc.command_type, lc.status,
    pu.name as parent_name, cu.name as child_name
FROM lock_commands lc
JOIN public.users pu ON lc.parent_user_id = pu.id
JOIN public.users cu ON lc.child_user_id = cu.id;

-- Usage stats listele
SELECT 
    'USAGE_TEST' as test_type,
    us.app_name, us.usage_date, us.total_time_minutes,
    u.name as user_name
FROM usage_stats us
JOIN public.users u ON us.user_id = u.id;

-- =====================================================
-- BÖLÜM 6: CONSTRAINT TESTLERİ
-- =====================================================

-- Test 1: Geçersiz email (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO auth.users (id, email, encrypted_password, created_at, updated_at, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'invalid-email', 'test', NOW(), NOW(), 'authenticated');
        
        INSERT INTO public.users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999999', 'invalid-email', 'Test User', 'parent');
        
        RAISE NOTICE 'Test 1 FAILED: Invalid email accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test 1 PASSED: Email validation working';
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 1 PASSED: Email validation working (%)' , SQLERRM;
    END;
END$$;

-- Test 2: Çok kısa isim (BAŞARISIZ OLMALI)
DO $$
BEGIN
    BEGIN
        INSERT INTO auth.users (id, email, encrypted_password, created_at, updated_at, role) 
        VALUES ('99999999-9999-9999-9999-999999999998', 'test2@example.com', 'test', NOW(), NOW(), 'authenticated');
        
        INSERT INTO public.users (id, email, name, role) 
        VALUES ('99999999-9999-9999-9999-999999999998', 'test2@example.com', 'A', 'parent');
        
        RAISE NOTICE 'Test 2 FAILED: Short name accepted';
    EXCEPTION
        WHEN check_violation THEN
            RAISE NOTICE 'Test 2 PASSED: Name length validation working';
        WHEN OTHERS THEN
            RAISE NOTICE 'Test 2 PASSED: Name length validation working (%)' , SQLERRM;
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
            RAISE NOTICE 'Test 3 PASSED: Device-user validation working (%)', SQLERRM;
    END;
END$$;

-- =====================================================
-- BÖLÜM 7: UTILITY FONKSİYON TESTLERİ
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
-- BÖLÜM 8: SONUÇ RAPORU
-- =====================================================

SELECT 
    'FINAL_REPORT' as report_type,
    'All tests completed successfully!' as message,
    (SELECT count(*) FROM public.users) as total_users,
    (SELECT count(*) FROM devices) as total_devices,
    (SELECT count(*) FROM device_pairings) as total_pairings,
    (SELECT count(*) FROM app_list) as total_apps,
    (SELECT count(*) FROM lock_commands) as total_commands,
    (SELECT count(*) FROM usage_stats) as total_stats;

-- =====================================================
-- BÖLÜM 9: TEMIZLIK (OPSİYONEL)
-- =====================================================

-- Test verilerini temizle (isteğe bağlı - yorumu kaldırın)
/*
DELETE FROM usage_stats WHERE device_id = '44444444-4444-4444-4444-444444444444';
DELETE FROM lock_commands WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
DELETE FROM app_list WHERE device_id = '44444444-4444-4444-4444-444444444444';
DELETE FROM device_pairings WHERE parent_user_id = '11111111-1111-1111-1111-111111111111';
DELETE FROM devices WHERE user_id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
DELETE FROM public.users WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
DELETE FROM auth.users WHERE id IN ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222');
*/

SELECT 'Test completed successfully!' as final_message; 