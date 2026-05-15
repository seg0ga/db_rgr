CREATE TABLE racks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    power_capacity INT CHECK (power_capacity>0));

CREATE TABLE server_statuses (
    id SERIAL PRIMARY KEY,
    status_name VARCHAR(20) UNIQUE NOT NULL);

CREATE TABLE servers (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR(100) UNIQUE NOT NULL,
    rack_id INT NOT NULL,
    model VARCHAR(50) NOT NULL,
    cpu_cores INT CHECK (cpu_cores>0),
    ram_gb INT CHECK (ram_gb>0),
    status_id INT NOT NULL,
    purchase_date DATE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET UNIQUE,
    serial_number VARCHAR(100),
    os_name VARCHAR(100));

CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    server_id INT NOT NULL,
    port INT CHECK (port BETWEEN 1 AND 65535),
    status VARCHAR(20) DEFAULT 'RUNNING');

CREATE TABLE incident_priorities (
    id SERIAL PRIMARY KEY,
    level VARCHAR(10) UNIQUE NOT NULL,
    response_minutes INT);

CREATE TABLE incidents (
    id SERIAL PRIMARY KEY,
    server_id INT NOT NULL,
    service_id INT,
    priority_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    detected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    CHECK (resolved_at IS NULL OR resolved_at>=detected_at));

CREATE TABLE maintenance_log (
    id SERIAL PRIMARY KEY,
    server_id INT NOT NULL,
    task_type VARCHAR(50) NOT NULL,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    downtime_minutes INT CHECK (downtime_minutes>=0));

CREATE TABLE servers_audit (
    id SERIAL PRIMARY KEY,
    server_id INT,
    old_status_id INT,
    new_status_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(50) DEFAULT CURRENT_USER);

ALTER TABLE servers ADD CONSTRAINT fk_servers_rack FOREIGN KEY (rack_id) REFERENCES racks(id);
ALTER TABLE servers ADD CONSTRAINT fk_servers_status FOREIGN KEY (status_id) REFERENCES server_statuses(id);

ALTER TABLE servers_audit ADD CONSTRAINT fk_audit_server FOREIGN KEY (server_id) REFERENCES servers(id);
ALTER TABLE servers_audit ADD CONSTRAINT fk_audit_old_status FOREIGN KEY (old_status_id) REFERENCES server_statuses(id);
ALTER TABLE servers_audit ADD CONSTRAINT fk_audit_new_status FOREIGN KEY (new_status_id) REFERENCES server_statuses(id);

ALTER TABLE services ADD CONSTRAINT fk_services_server FOREIGN KEY (server_id) REFERENCES servers(id) ON DELETE CASCADE;

ALTER TABLE incidents ADD CONSTRAINT fk_incidents_server FOREIGN KEY (server_id) REFERENCES servers(id);
ALTER TABLE incidents ADD CONSTRAINT fk_incidents_service FOREIGN KEY (service_id) REFERENCES services(id);
ALTER TABLE incidents ADD CONSTRAINT fk_incidents_priority FOREIGN KEY (priority_id) REFERENCES incident_priorities(id);

ALTER TABLE maintenance_log ADD CONSTRAINT fk_maintenance_server FOREIGN KEY (server_id) REFERENCES servers(id);

CREATE INDEX idx_servers_rack_id ON servers(rack_id);
CREATE INDEX idx_servers_status_id ON servers(status_id);
CREATE INDEX idx_servers_hostname ON servers(hostname);
CREATE INDEX idx_servers_ip_address ON servers(ip_address);

CREATE INDEX idx_services_server_id ON services(server_id);
CREATE INDEX idx_services_status ON services(status);

CREATE INDEX idx_incidents_detected_at ON incidents(detected_at);
CREATE INDEX idx_incidents_priority_id ON incidents(priority_id);
CREATE INDEX idx_incidents_server_id ON incidents(server_id);

CREATE INDEX idx_maintenance_log_performed_at ON maintenance_log(performed_at);
CREATE INDEX idx_maintenance_log_server_id ON maintenance_log(server_id);

CREATE INDEX idx_servers_audit_changed_at ON servers_audit(changed_at);
CREATE INDEX idx_servers_audit_server_id ON servers_audit(server_id);
