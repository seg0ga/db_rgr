-- аудит изменения статуса сервера
CREATE OR REPLACE FUNCTION audit_server_status_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status_id IS DISTINCT FROM NEW.status_id THEN
        INSERT INTO servers_audit (
            server_id,
            old_status_id,
            new_status_id,
            changed_at,
            changed_by
        ) VALUES (
            NEW.id,
            OLD.status_id,
            NEW.status_id,
            CURRENT_TIMESTAMP,
            CURRENT_USER
        );
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_audit_server_status
    AFTER UPDATE OF status_id ON servers
    FOR EACH ROW
    EXECUTE FUNCTION audit_server_status_change();


--автообновление метки времени updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Создание триггера
CREATE TRIGGER trg_update_server_timestamp
    BEFORE UPDATE ON servers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
