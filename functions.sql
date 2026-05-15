--активные инциденты на сервере
CREATE OR REPLACE FUNCTION get_active_incidents_count(p_server_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM incidents
    WHERE server_id = p_server_id
      AND resolved_at IS NULL;
    
    RETURN v_count;
END;
$$;

--расчет суммарного потребления мощности в стойке
CREATE OR REPLACE FUNCTION get_rack_power_usage(p_rack_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_power INT;
    v_power_capacity INT;
BEGIN
    SELECT power_capacity INTO v_power_capacity
    FROM racks
    WHERE id = p_rack_id;
        SELECT COUNT(*) * 500
    INTO v_total_power
    FROM servers
    WHERE rack_id = p_rack_id;
    
    RETURN v_total_power;
END;
$$;

--расчет времени простоя за период
CREATE OR REPLACE FUNCTION get_server_downtime(
    p_server_id INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS INTERVAL
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_downtime INTERVAL;
BEGIN
    SELECT SUM(downtime_minutes * INTERVAL '1 minute')
    INTO v_total_downtime
    FROM maintenance_log
    WHERE server_id = p_server_id
      AND performed_at BETWEEN p_start_date AND p_end_date;
    
    RETURN COALESCE(v_total_downtime, INTERVAL '0');
END;
$$;

--проверка доступных ресурсов в стойке
CREATE OR REPLACE FUNCTION can_add_server_to_rack(
    p_rack_id INT,
    p_cpu_cores INT,
    p_ram_gb INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_cpu INT;
    v_total_ram INT;
    v_max_cpu INT := 1000;  -- Максимум CPU ядер в стойке
    v_max_ram INT := 10000;  -- Максимум RAM в стойке
BEGIN
    SELECT COALESCE(SUM(cpu_cores), 0), COALESCE(SUM(ram_gb), 0)
    INTO v_total_cpu, v_total_ram
    FROM servers
    WHERE rack_id = p_rack_id;
    
    IF (v_total_cpu + p_cpu_cores) <= v_max_cpu 
       AND (v_total_ram + p_ram_gb) <= v_max_ram THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;
