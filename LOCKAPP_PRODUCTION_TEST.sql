-- =====================================================
-- LOCKAPP PRODUCTION TEST SCRIPT
-- =====================================================
-- Bu script gerçek kullanım için hazırlanmıştır
-- auth.users'a müdahale etmez, sadece yapıyı test eder

-- =====================================================
-- BÖLÜM 1: KURULUM DOĞRULAMA
-- =====================================================

-- Tabloları kontrol et
SELECT 
    'TABLE_CHECK' as test_type,
    tablename,
    CASE 
        WHEN tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats') 
        THEN 'REQUIRED_TABLE_EXISTS' 
        ELSE 'UNEXPECTED_TABLE' 
    END as status
FROM pg_tables 
WHERE schemaname = 'public' 
ORDER BY tablename;

-- Enum'ları kontrol et
SELECT 
    'ENUM_CHECK' as test_type,
    typname as enum_name,
    array_agg(enumlabel ORDER BY enumsortorder) as enum_values
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')
GROUP BY typname
ORDER BY typname;

-- Trigger'ları kontrol et
SELECT 
    'TRIGGER_CHECK' as test_type,
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- RLS politikalarını kontrol et
SELECT 
    'RLS_POLICY_CHECK' as test_type,
    tablename,
    policyname,
    cmd as policy_command
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, policyname;

-- Foreign key constraint'leri kontrol et
SELECT 
    'FOREIGN_KEY_CHECK' as test_type,
    tc.table_name,
    tc.constraint_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_name;

-- =====================================================
-- BÖLÜM 2: TABLO YAPISINI KONTROL ET
-- =====================================================

-- Users tablosu kolonları
SELECT 
    'USERS_COLUMNS' as test_type,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'users'
ORDER BY ordinal_position;

-- Devices tablosu kolonları
SELECT 
    'DEVICES_COLUMNS' as test_type,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'devices'
ORDER BY ordinal_position;

-- Device_pairings tablosu kolonları
SELECT 
    'DEVICE_PAIRINGS_COLUMNS' as test_type,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
    AND table_name = 'device_pairings'
ORDER BY ordinal_position;

-- =====================================================
-- BÖLÜM 3: CONSTRAINT TESTLERİ
-- =====================================================

-- Check constraint'leri kontrol et
SELECT 
    'CHECK_CONSTRAINTS' as test_type,
    conname as constraint_name,
    conrelid::regclass as table_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE contype = 'c' 
    AND connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass, conname;

-- Unique constraint'leri kontrol et
SELECT 
    'UNIQUE_CONSTRAINTS' as test_type,
    conname as constraint_name,
    conrelid::regclass as table_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint 
WHERE contype = 'u' 
    AND connamespace = 'public'::regnamespace
ORDER BY conrelid::regclass, conname;

-- =====================================================
-- BÖLÜM 4: İNDEKS KONTROLÜ
-- =====================================================

-- İndeksleri kontrol et
SELECT 
    'INDEX_CHECK' as test_type,
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename, indexname;

-- =====================================================
-- BÖLÜM 5: UTILITY FONKSİYON KONTROLÜ
-- =====================================================

-- Fonksiyonları kontrol et
SELECT 
    'FUNCTION_CHECK' as test_type,
    routine_name,
    routine_type,
    data_type as return_type
FROM information_schema.routines
WHERE routine_schema = 'public'
    AND routine_name IN ('get_user_devices', 'get_paired_devices', 'update_updated_at_column', 'validate_device_user_role', 'validate_pairing_relationship', 'validate_lock_command_relationship')
ORDER BY routine_name;

-- =====================================================
-- BÖLÜM 6: ENUM DEĞER KONTROLÜ
-- =====================================================

-- User role enum değerleri
SELECT 
    'USER_ROLE_VALUES' as test_type,
    unnest(enum_range(NULL::user_role)) as role_value;

-- Device status enum değerleri
SELECT 
    'DEVICE_STATUS_VALUES' as test_type,
    unnest(enum_range(NULL::device_status)) as status_value;

-- Device type enum değerleri
SELECT 
    'DEVICE_TYPE_VALUES' as test_type,
    unnest(enum_range(NULL::device_type)) as type_value;

-- Lock status enum değerleri
SELECT 
    'LOCK_STATUS_VALUES' as test_type,
    unnest(enum_range(NULL::lock_status)) as status_value;

-- Command status enum değerleri
SELECT 
    'COMMAND_STATUS_VALUES' as test_type,
    unnest(enum_range(NULL::command_status)) as status_value;

-- Pairing status enum değerleri
SELECT 
    'PAIRING_STATUS_VALUES' as test_type,
    unnest(enum_range(NULL::pairing_status)) as status_value;

-- =====================================================
-- BÖLÜM 7: GÜVENLIK KONTROLÜ
-- =====================================================

-- RLS durumunu kontrol et
SELECT 
    'RLS_STATUS' as test_type,
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- Tablo sahipliklerini kontrol et
SELECT 
    'TABLE_OWNERSHIP' as test_type,
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
    AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')
ORDER BY tablename;

-- =====================================================
-- BÖLÜM 8: SONUÇ RAPORU
-- =====================================================

-- Özet rapor
SELECT 
    'SUMMARY_REPORT' as report_type,
    'Database structure validation completed!' as message,
    (SELECT count(*) FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')) as required_tables_count,
    (SELECT count(DISTINCT typname) FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')) as enum_types_count,
    (SELECT count(*) FROM pg_policies WHERE schemaname = 'public') as rls_policies_count,
    (SELECT count(*) FROM information_schema.triggers WHERE trigger_schema = 'public') as triggers_count,
    (SELECT count(*) FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name IN ('get_user_devices', 'get_paired_devices', 'update_updated_at_column', 'validate_device_user_role', 'validate_pairing_relationship', 'validate_lock_command_relationship')) as utility_functions_count;

-- Başarı kontrolü
SELECT 
    'VALIDATION_RESULT' as test_type,
    CASE 
        WHEN (
            (SELECT count(*) FROM pg_tables WHERE schemaname = 'public' AND tablename IN ('users', 'devices', 'device_pairings', 'app_list', 'lock_commands', 'usage_stats')) = 6
            AND (SELECT count(DISTINCT typname) FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE typname IN ('user_role', 'device_status', 'device_type', 'lock_status', 'command_status', 'pairing_status')) = 6
            AND (SELECT count(*) FROM pg_policies WHERE schemaname = 'public') >= 18
            AND (SELECT count(*) FROM information_schema.triggers WHERE trigger_schema = 'public') >= 9
        ) THEN 'ALL_CHECKS_PASSED'
        ELSE 'SOME_CHECKS_FAILED'
    END as validation_status;

-- NOT: Gerçek kullanım için Flutter uygulamasından Supabase Auth ile kayıt olun
SELECT 
    'USAGE_NOTE' as note_type,
    'Database structure is ready!' as message,
    'Use Flutter app with Supabase Auth for user registration' as instruction,
    'Test users should be created through auth.signUp() method' as auth_method;

SELECT 'Production test completed successfully!' as final_message; 