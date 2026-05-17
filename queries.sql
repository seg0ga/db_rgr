-- 6 ПРОСТЫХ ВЫБОРОК(SELECT)
--базовая информация о всех серверах
SELECT id, hostname, model, ram_gb, cpu_cores, purchase_date FROM servers ORDER BY id;

--все инциденты(заголовок и даты)
SELECT id, title, detected_at, resolved_at FROM incidents ORDER BY detected_at DESC;

--все журналы обслуживания
SELECT id, task_type, performed_at, downtime_minutes FROM maintenance_log ORDER BY performed_at DESC;

--все стойки(название, локация и энергоемкость)
SELECT id, name, location, power_capacity FROM racks ORDER BY name;

--все сервисы(имя, id сервера и порт)
SELECT id, name, server_id, port, status FROM services ORDER BY name;

--все приоритеты инцидентов и нормативное время реакции
SELECT id, level, response_minutes FROM incident_priorities ORDER BY response_minutes;

--4 ЗАПРОСА С УСЛОВИЯМИ ФИЛЬТРАЦИИ(WHERE)
--Серверы с ОЗУ>32gb
SELECT hostname, model, ram_gb, cpu_cores FROM servers WHERE ram_gb>64 ORDER BY ram_gb DESC;

--Серверы, купленные после 2025 года
SELECT hostname, model, purchase_date, os_name FROM servers WHERE purchase_date>'2025-12-31' ORDER BY purchase_date DESC;

--неразрешенные инциденты
SELECT i.title, ip.level, i.detected_at FROM incidents i JOIN incident_priorities ip ON i.priority_id=ip.id
WHERE i.resolved_at IS NULL AND ip.level IN ('CRITICAL','HIGH');

--сервера, обновлявшиеся более 90 дней назад
SELECT hostname, model, updated_at, status_id FROM servers
WHERE updated_at<CURRENT_DATE-INTERVAL '90 days'
ORDER BY updated_at ASC;


-- 4 ЗАПРОСА С ОБЪЕДИНЕНИЕМ ТАБЛИЦ (JOIN)
--серверы+стойки+статусы
SELECT s.hostname,r.name AS rack, r.location, st.status_name
FROM servers s
JOIN racks r ON s.rack_id=r.id
JOIN server_statuses st ON s.status_id=st.id;

--инциденты(неразрешненные)+серверы+приоритеты
SELECT i.title, s.hostname, ip.level, ip.response_minutes, i.detected_at
FROM incidents i
JOIN servers s ON i.server_id=s.id
JOIN incident_priorities ip ON i.priority_id=ip.id
WHERE i.resolved_at IS NULL;

--сервисы+серверы+стойки
SELECT sv.name AS service_name, s.hostname, r.name AS rack, sv.port, sv.status
FROM services sv
JOIN servers s ON sv.server_id=s.id
JOIN racks r ON s.rack_id=r.id;

--аудит изменений+серверы+статусы
SELECT s.hostname,old_st.status_name AS old_status, new_st.status_name AS new_status, a.changed_at, a.changed_by
FROM servers_audit a
JOIN servers s ON a.server_id=s.id
JOIN server_statuses old_st ON a.old_status_id=old_st.id
JOIN server_statuses new_st ON a.new_status_id=new_st.id
ORDER BY a.changed_at DESC LIMIT 50;

-- 6 ЗАПРОСОВ С АГРЕГАЦИЕЙ ДАННЫХ(GROUP BY И ФУНКЦИИ COUNT/SUM/AVG)
--количество серверов в кажой стойке
SELECT r.name AS rack, COUNT(s.id) AS server_count
FROM racks r
LEFT JOIN servers s ON r.id = s.rack_id
GROUP BY r.name ORDER BY server_count DESC;

--среднее время отключения при обслуживании
SELECT task_type, AVG(downtime_minutes) AS avg_downtime_minutes, COUNT(*) AS operations_count
FROM maintenance_log
GROUP BY task_type ORDER BY avg_downtime_minutes DESC;

--кол-во инцидентов по приоритетам
SELECT ip.level, COUNT(i.id) AS incident_count
FROM incident_priorities ip
LEFT JOIN incidents i ON ip.id=i.priority_id
GROUP BY ip.level ORDER BY incident_count DESC;

--суммарно ядер по моделям серверов
SELECT model, SUM(cpu_cores) AS total_cores, COUNT(*) AS servers_count
FROM servers GROUP BY model ORDER BY total_cores DESC;

--общая озу по статусам серверов
SELECT st.status_name, SUM(s.ram_gb) AS total_ram_gb, AVG(s.ram_gb) AS avg_ram_gb
FROM servers s
JOIN server_statuses st ON s.status_id=st.id
GROUP BY st.status_name ORDER BY total_ram_gb DESC;

--кол-во обслуживаний по серверам
SELECT s.hostname, COUNT(m.id) AS maintenance_count, SUM(m.downtime_minutes) AS total_downtime
FROM servers s
LEFT JOIN maintenance_log m ON s.id=m.server_id
GROUP BY s.id, s.hostname ORDER BY maintenance_count DESC;

--2 ЗАПРОСА С HAVING
--стойки, где больше 5 серверов
SELECT r.name AS rack, COUNT(s.id) AS server_count
FROM racks r
LEFT JOIN servers s ON r.id=s.rack_id
GROUP BY r.id, r.name HAVING COUNT(s.id)>5
ORDER BY server_count DESC;

--модели серверов со средним кол-ом озу > 32
SELECT model, AVG(ram_gb) AS avg_ram, COUNT(*) AS count
FROM servers
GROUP BY model HAVING AVG(ram_gb)>32
ORDER BY avg_ram DESC;

--2 ЗАПРОСА С CTE
--топ 3 сервера по количеству проблем
WITH incident_stats AS (SELECT server_id, COUNT(*) AS total_incidents FROM incidents GROUP BY server_id)
SELECT s.hostname, s.model, COALESCE(incident_stats.total_incidents, 0) AS incident_count
FROM servers s
LEFT JOIN incident_stats ON s.id=incident_stats.server_id
ORDER BY incident_count DESC LIMIT 3;

--серверы с просоем больше среднего
WITH avg_downtime AS (SELECT AVG(downtime_minutes) AS avg_all FROM maintenance_log)
SELECT s.hostname, SUM(m.downtime_minutes) AS total_downtime
FROM servers s
JOIN maintenance_log m ON s.id=m.server_id
CROSS JOIN avg_downtime
GROUP BY s.id, s.hostname, avg_downtime.avg_all
HAVING SUM(m.downtime_minutes)>avg_downtime.avg_all
ORDER BY total_downtime DESC;

--2 ЗАПРОСА С ORDER BY + LIMIT
--последние 5 инцидентов
SELECT i.title, s.hostname, ip.level, i.detected_at
FROM incidents i
JOIN servers s ON i.server_id=s.id
JOIN incident_priorities ip ON i.priority_id=ip.id
ORDER BY i.detected_at DESC LIMIT 5;

--топ 5 серверов с наибольшим обьемом озу
SELECT hostname, model, ram_gb, os_name FROM servers
ORDER BY ram_gb DESC LIMIT 5;
