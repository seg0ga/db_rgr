INSERT INTO racks (id, name, location, power_capacity) VALUES
    (1, 'RACK-A01', 'DC-1 / Hall A / Row 1', 12000),
    (2, 'RACK-A02', 'DC-1 / Hall A / Row 1', 12000),
    (3, 'RACK-A03', 'DC-1 / Hall A / Row 2', 16000),
    (4, 'RACK-B01', 'DC-1 / Hall B / Row 1', 18000),
    (5, 'RACK-B02', 'DC-1 / Hall B / Row 1', 18000),
    (6, 'RACK-C01', 'DC-2 / Hall C / Row 1', 20000),
    (7, 'RACK-C02', 'DC-2 / Hall C / Row 2', 20000),
    (8, 'RACK-D01', 'DR-Site / Hall D / Row 1', 10000);

INSERT INTO server_statuses (id, status_name) VALUES
    (1, 'ACTIVE'),
    (2, 'MAINTENANCE'),
    (3, 'OFFLINE'),
    (4, 'PROVISIONING'),
    (5, 'DECOMMISSIONED');

INSERT INTO incident_priorities (id, level, response_minutes) VALUES
    (1, 'LOW', 1440),
    (2, 'MEDIUM', 240),
    (3, 'HIGH', 60),
    (4, 'CRITICAL', 15);

INSERT INTO servers (
    id, hostname, rack_id, model, cpu_cores, ram_gb, status_id,
    purchase_date, updated_at, ip_address, serial_number, os_name
) VALUES
    (1, 'srv-app-01', 1, 'Dell R750', 32, 128, 1, '2024-03-14', '2026-05-10 09:30:00', '10.10.1.11', 'DL750-A001', 'Ubuntu Server 24.04'),
    (2, 'srv-app-02', 1, 'Dell R750', 32, 128, 1, '2024-03-14', '2026-05-11 10:00:00', '10.10.1.12', 'DL750-A002', 'Ubuntu Server 24.04'),
    (3, 'srv-web-01', 1, 'HPE DL360', 24, 64, 1, '2023-11-02', '2026-04-29 08:15:00', '10.10.1.21', 'HP360-W001', 'Debian 12'),
    (4, 'srv-web-02', 1, 'HPE DL360', 24, 64, 2, '2023-11-02', '2026-02-01 12:00:00', '10.10.1.22', 'HP360-W002', 'Debian 12'),
    (5, 'srv-db-01', 2, 'Dell R760', 64, 512, 1, '2025-01-19', '2026-05-14 03:20:00', '10.10.2.31', 'DL760-D001', 'Rocky Linux 9'),
    (6, 'srv-db-02', 2, 'Dell R760', 64, 512, 1, '2025-01-19', '2026-05-14 03:45:00', '10.10.2.32', 'DL760-D002', 'Rocky Linux 9'),
    (7, 'srv-cache-01', 2, 'Lenovo SR650', 32, 256, 1, '2024-08-08', '2026-05-01 17:10:00', '10.10.2.41', 'LN650-C001', 'Ubuntu Server 22.04'),
    (8, 'srv-cache-02', 2, 'Lenovo SR650', 32, 256, 3, '2024-08-08', '2026-01-05 07:00:00', '10.10.2.42', 'LN650-C002', 'Ubuntu Server 22.04'),
    (9, 'srv-mon-01', 3, 'Supermicro SYS-120', 16, 64, 1, '2023-05-30', '2026-05-13 16:40:00', '10.10.3.51', 'SM120-M001', 'Debian 12'),
    (10, 'srv-log-01', 3, 'Supermicro SYS-220', 32, 256, 1, '2024-02-12', '2026-04-21 06:20:00', '10.10.3.61', 'SM220-L001', 'Rocky Linux 9'),
    (11, 'srv-bak-01', 3, 'HPE DL380', 48, 384, 1, '2024-06-18', '2026-03-25 23:30:00', '10.10.3.71', 'HP380-B001', 'Ubuntu Server 24.04'),
    (12, 'srv-ai-01', 4, 'Dell XE9680', 128, 1024, 1, '2026-02-04', '2026-05-12 14:05:00', '10.10.4.81', 'DLX9680-AI01', 'Ubuntu Server 24.04'),
    (13, 'srv-ai-02', 4, 'Dell XE9680', 128, 1024, 4, '2026-02-04', '2026-05-15 11:15:00', '10.10.4.82', 'DLX9680-AI02', 'Ubuntu Server 24.04'),
    (14, 'srv-vpn-01', 5, 'HPE DL360', 16, 64, 1, '2022-09-10', '2026-01-20 18:00:00', '10.10.5.91', 'HP360-V001', 'Debian 11'),
    (15, 'srv-edge-01', 5, 'Lenovo SE350', 12, 32, 1, '2026-01-12', '2026-05-05 09:20:00', '10.10.5.101', 'LN350-E001', 'Ubuntu Server 24.04'),
    (16, 'srv-edge-02', 5, 'Lenovo SE350', 12, 32, 1, '2026-01-12', '2026-05-05 09:25:00', '10.10.5.102', 'LN350-E002', 'Ubuntu Server 24.04'),
    (17, 'srv-ci-01', 1, 'Dell R750', 32, 128, 1, '2025-07-22', '2026-05-07 13:50:00', '10.10.6.111', 'DL750-CI01', 'Ubuntu Server 22.04'),
    (18, 'srv-ci-02', 1, 'Dell R750', 32, 128, 2, '2025-07-22', '2026-04-10 15:35:00', '10.10.6.112', 'DL750-CI02', 'Ubuntu Server 22.04'),
    (19, 'srv-dr-01', 8, 'HPE DL380', 48, 384, 1, '2024-12-03', '2026-04-02 04:10:00', '10.20.1.11', 'HP380-DR01', 'Rocky Linux 9'),
    (20, 'srv-legacy-01', 8, 'IBM x3650', 16, 64, 5, '2020-04-17', '2025-12-15 10:00:00', '10.20.1.12', 'IBM3650-L001', 'CentOS 7');

INSERT INTO services (id, name, server_id, port, status) VALUES
    (1, 'billing-api', 1, 8080, 'RUNNING'),
    (2, 'billing-worker', 2, 8081, 'RUNNING'),
    (3, 'customer-portal', 3, 443, 'RUNNING'),
    (4, 'nginx-edge', 4, 443, 'DEGRADED'),
    (5, 'postgres-primary', 5, 5432, 'RUNNING'),
    (6, 'postgres-replica', 6, 5432, 'RUNNING'),
    (7, 'redis-cache', 7, 6379, 'RUNNING'),
    (8, 'redis-cache', 8, 6379, 'STOPPED'),
    (9, 'prometheus', 9, 9090, 'RUNNING'),
    (10, 'grafana', 9, 3000, 'RUNNING'),
    (11, 'loki', 10, 3100, 'RUNNING'),
    (12, 'backup-agent', 11, 9102, 'RUNNING'),
    (13, 'ml-inference', 12, 8443, 'RUNNING'),
    (14, 'ml-training', 13, 8444, 'DEGRADED'),
    (15, 'wireguard', 14, 51820, 'RUNNING'),
    (16, 'cdn-cache', 15, 8080, 'RUNNING'),
    (17, 'cdn-cache', 16, 8080, 'RUNNING'),
    (18, 'gitlab-runner', 17, 9252, 'RUNNING'),
    (19, 'jenkins-agent', 18, 50000, 'DEGRADED'),
    (20, 'dr-replication', 19, 9443, 'RUNNING'),
    (21, 'legacy-crm', 20, 8088, 'STOPPED'),
    (22, 'node-exporter', 1, 9100, 'RUNNING'),
    (23, 'node-exporter', 5, 9100, 'RUNNING'),
    (24, 'node-exporter', 12, 9100, 'RUNNING');

INSERT INTO incidents (id, server_id, service_id, priority_id, title, detected_at, resolved_at) VALUES
    (1, 8, 8, 3, 'Узел Redis недоступен', '2026-01-05 07:10:00', NULL),
    (2, 4, 4, 2, 'Увеличение HTTP 5xx ответов', '2026-02-01 12:05:00', '2026-02-01 13:20:00'),
    (3, 5, 5, 4, 'Всплеск задержки основной базы данных', '2026-03-03 02:15:00', '2026-03-03 02:42:00'),
    (4, 6, 6, 3, 'Задержка реплики превысила порог', '2026-03-03 02:20:00', '2026-03-03 03:10:00'),
    (5, 10, 11, 2, 'Задержка приёма логов', '2026-03-18 11:30:00', '2026-03-18 12:05:00'),
    (6, 12, 13, 4, 'Таймаут эндпоинта GPU инференса', '2026-04-06 09:00:00', '2026-04-06 09:18:00'),
    (7, 13, 14, 3, 'Очередь обучения зависла', '2026-04-08 15:45:00', NULL),
    (8, 18, 19, 2, 'Сборщики сборки работают медленно', '2026-04-10 15:40:00', NULL),
    (9, 20, 21, 1, 'Legacy CRM остановилась после окна патчей', '2026-04-12 04:00:00', NULL),
    (10, 1, 1, 2, 'Уровень ошибок платежного API выше базового', '2026-04-20 10:25:00', '2026-04-20 10:55:00'),
    (11, 2, 2, 1, 'Очередь воркеров увеличилась', '2026-04-22 13:10:00', '2026-04-22 14:00:00'),
    (12, 3, 3, 2, 'Предупреждение о TLS-сертификате портала', '2026-04-25 08:35:00', '2026-04-25 09:05:00'),
    (13, 7, 7, 3, 'Высокое потребление памяти кеша', '2026-04-29 21:00:00', '2026-04-29 21:32:00'),
    (14, 9, 9, 1, 'Пропуски скрейпинга Prometheus', '2026-05-02 06:10:00', '2026-05-02 06:25:00'),
    (15, 11, 12, 2, 'Порог повторов бэкапа достигнут', '2026-05-03 02:30:00', '2026-05-03 03:25:00'),
    (16, 14, 15, 3, 'Потеря пакетов VPN выше SLA', '2026-05-06 18:15:00', NULL),
    (17, 15, 16, 1, 'Задержка прогрева кеша CDN', '2026-05-08 09:45:00', '2026-05-08 10:05:00'),
    (18, 19, 20, 4, 'Канал репликации DR прерван', '2026-05-09 23:40:00', '2026-05-10 00:08:00');

INSERT INTO maintenance_log (id, server_id, task_type, performed_at, description, downtime_minutes) VALUES
    (1, 1, 'OS_PATCH', '2026-01-12 01:00:00', 'Установка патчей безопасности', 12),
    (2, 2, 'OS_PATCH', '2026-01-12 01:30:00', 'Установка патчей безопасности', 10),
    (3, 3, 'FIRMWARE_UPDATE', '2026-01-19 02:00:00', 'Обновление прошивки сетевого адаптера', 25),
    (4, 4, 'DIAGNOSTICS', '2026-02-01 13:30:00', 'Диагностика сети после ошибок HTTP', 35),
    (5, 5, 'STORAGE_CHECK', '2026-03-03 03:00:00', 'Проверка состояния NVMe', 18),
    (6, 6, 'REPLICATION_CHECK', '2026-03-03 03:15:00', 'Исследование задержки репликации', 20),
    (7, 7, 'RAM_UPGRADE', '2026-03-20 01:00:00', 'Замена модуля памяти', 45),
    (8, 8, 'HARDWARE_REPAIR', '2026-01-05 08:00:00', 'Замена блока питания', 90),
    (9, 9, 'OS_PATCH', '2026-04-01 00:30:00', 'Установка патчей для стека мониторинга', 8),
    (10, 10, 'DISK_EXPANSION', '2026-04-21 06:00:00', 'Расширение раздела с логами', 22),
    (11, 11, 'BACKUP_TEST', '2026-04-30 03:00:00', 'Проверка восстановления из бэкапа', 0),
    (12, 12, 'GPU_DRIVER_UPDATE', '2026-04-06 09:30:00', 'Обновление драйвера NVIDIA', 30),
    (13, 13, 'GPU_DIAGNOSTICS', '2026-04-08 16:15:00', 'Диагностика очереди обучения', 40),
    (14, 14, 'NETWORK_CHECK', '2026-05-06 19:00:00', 'Проверка маршрутизации VPN', 15),
    (15, 15, 'CACHE_RESTART', '2026-05-08 10:00:00', 'Перезапуск кеш-сервиса', 5),
    (16, 16, 'OS_PATCH', '2026-05-08 10:30:00', 'Установка патчей на граничный узел', 7),
    (17, 18, 'CI_AGENT_REPAIR', '2026-04-10 16:00:00', 'Очистка и перезапуск раннера', 28),
    (18, 19, 'DR_TEST', '2026-05-10 00:15:00', 'Тренировка переключения репликации', 32);

SELECT setval('racks_id_seq', (SELECT MAX(id) FROM racks));
SELECT setval('server_statuses_id_seq', (SELECT MAX(id) FROM server_statuses));
SELECT setval('incident_priorities_id_seq', (SELECT MAX(id) FROM incident_priorities));
SELECT setval('servers_id_seq', (SELECT MAX(id) FROM servers));
SELECT setval('services_id_seq', (SELECT MAX(id) FROM services));
SELECT setval('incidents_id_seq', (SELECT MAX(id) FROM incidents));
SELECT setval('maintenance_log_id_seq', (SELECT MAX(id) FROM maintenance_log));
