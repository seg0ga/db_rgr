\echo '============================================================'
\echo '1. Общая проверка наполнения базы'
\echo '============================================================'

SELECT 'racks' AS table_name, COUNT(*) AS rows_count FROM racks
UNION ALL SELECT 'server_statuses', COUNT(*) FROM server_statuses
UNION ALL SELECT 'servers', COUNT(*) FROM servers
UNION ALL SELECT 'services', COUNT(*) FROM services
UNION ALL SELECT 'incident_priorities', COUNT(*) FROM incident_priorities
UNION ALL SELECT 'incidents', COUNT(*) FROM incidents
UNION ALL SELECT 'maintenance_log', COUNT(*) FROM maintenance_log
UNION ALL SELECT 'servers_audit', COUNT(*) FROM servers_audit
ORDER BY table_name;

\echo '============================================================'
\echo '2. Структура: таблицы, ограничения и индексы'
\echo '============================================================'

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT tc.table_name, tc.constraint_name, tc.constraint_type
FROM information_schema.table_constraints tc
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;

SELECT tablename, indexname
FROM pg_catalog.pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

\echo '============================================================'
\echo '3. Связи между таблицами: серверы, стойки, статусы, сервисы'
\echo '============================================================'

SELECT s.hostname,
       r.name AS rack,
       r.location,
       st.status_name,
       s.cpu_cores,
       s.ram_gb,
       COUNT(sv.id) AS services_count
FROM servers s
JOIN racks r ON s.rack_id = r.id
JOIN server_statuses st ON s.status_id = st.id
LEFT JOIN services sv ON s.id = sv.server_id
GROUP BY s.id, s.hostname, r.name, r.location, st.status_name, s.cpu_cores, s.ram_gb
ORDER BY r.name, s.hostname
LIMIT 20;

\echo '============================================================'
\echo '4. Инциденты с приоритетами и привязкой к серверу/сервису'
\echo '============================================================'

SELECT i.title,
       s.hostname,
       sv.name AS service_name,
       ip.level,
       ip.response_minutes,
       i.detected_at,
       i.resolved_at
FROM incidents i
JOIN servers s ON i.server_id = s.id
LEFT JOIN services sv ON i.service_id = sv.id
JOIN incident_priorities ip ON i.priority_id = ip.id
ORDER BY i.detected_at DESC
LIMIT 10;

\echo '============================================================'
\echo '5. Аналитика: агрегации, HAVING, CTE, ORDER BY LIMIT'
\echo '============================================================'

SELECT r.name AS rack, COUNT(s.id) AS server_count, SUM(s.cpu_cores) AS total_cpu, SUM(s.ram_gb) AS total_ram_gb
FROM racks r
LEFT JOIN servers s ON r.id = s.rack_id
GROUP BY r.id, r.name
ORDER BY server_count DESC, r.name;

SELECT r.name AS rack, COUNT(s.id) AS server_count
FROM racks r
LEFT JOIN servers s ON r.id = s.rack_id
GROUP BY r.id, r.name
HAVING COUNT(s.id) > 5
ORDER BY server_count DESC;

WITH incident_stats AS (
    SELECT server_id, COUNT(*) AS incidents_count
    FROM incidents
    GROUP BY server_id
)
SELECT s.hostname, COALESCE(ist.incidents_count, 0) AS incidents_count
FROM servers s
LEFT JOIN incident_stats ist ON s.id = ist.server_id
ORDER BY incidents_count DESC, s.hostname
LIMIT 5;

\echo '============================================================'
\echo '6. Демонстрация всех 4 функций'
\echo '============================================================'

SELECT get_active_incidents_count(8) AS active_incidents_on_srv_cache_02;

SELECT get_rack_power_usage(1) AS rack_a01_estimated_power_usage_watts;

SELECT get_server_downtime(8, '2026-01-01', '2026-12-31') AS srv_cache_02_downtime;

SELECT can_add_server_to_rack(1, 16, 64) AS can_add_small_server_to_rack_a01;

\echo '============================================================'
\echo '7. Демонстрация триггеров: аудит статуса и updated_at'
\echo '============================================================'

SELECT s.hostname, st.status_name, s.updated_at
FROM servers s
JOIN server_statuses st ON s.status_id = st.id
WHERE s.hostname = 'srv-app-01';

UPDATE servers
SET status_id = (SELECT id FROM server_statuses WHERE status_name = 'MAINTENANCE')
WHERE hostname = 'srv-app-01';

UPDATE servers
SET status_id = (SELECT id FROM server_statuses WHERE status_name = 'ACTIVE')
WHERE hostname = 'srv-app-01';

SELECT s.hostname, st.status_name, s.updated_at
FROM servers s
JOIN server_statuses st ON s.status_id = st.id
WHERE s.hostname = 'srv-app-01';

SELECT s.hostname,
       old_st.status_name AS old_status,
       new_st.status_name AS new_status,
       a.changed_at,
       a.changed_by
FROM servers_audit a
JOIN servers s ON a.server_id = s.id
JOIN server_statuses old_st ON a.old_status_id = old_st.id
JOIN server_statuses new_st ON a.new_status_id = new_st.id
WHERE s.hostname = 'srv-app-01'
ORDER BY a.changed_at DESC
LIMIT 6;

\echo '============================================================'
\echo '8. Демонстрация ON DELETE CASCADE для services -> servers'
\echo '============================================================'

BEGIN;

INSERT INTO servers (
    hostname, rack_id, model, cpu_cores, ram_gb, status_id,
    purchase_date, ip_address, serial_number, os_name
) VALUES (
    'srv-demo-cascade', 1, 'Demo Server', 4, 16, 1,
    CURRENT_DATE, '10.99.99.99', 'DEMO-CASCADE-001', 'Ubuntu Server 24.04'
);

INSERT INTO services (name, server_id, port, status)
SELECT 'demo-service', id, 8088, 'RUNNING'
FROM servers
WHERE hostname = 'srv-demo-cascade';

SELECT s.hostname, COUNT(sv.id) AS services_before_server_delete
FROM servers s
LEFT JOIN services sv ON s.id = sv.server_id
WHERE s.hostname = 'srv-demo-cascade'
GROUP BY s.hostname;

DELETE FROM servers
WHERE hostname = 'srv-demo-cascade';

SELECT COUNT(*) AS demo_services_after_server_delete
FROM services
WHERE name = 'demo-service';

ROLLBACK;

\echo '============================================================'
\echo '9. Итог: база готова к проверке'
\echo '============================================================'

SELECT 'demo completed successfully' AS result;
