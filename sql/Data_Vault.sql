
-- ============================================
-- LABORATORY WORK 2
-- DATA VAULT MODEL
-- Household Service Order Processing System
-- ============================================

-- Create Data Vault schema
CREATE SCHEMA IF NOT EXISTS data_vault;

-- ============================================
-- HUB TABLES
-- ============================================

-- 1. Hub Client
CREATE TABLE data_vault.hub_client (
    hub_client_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 2. Hub Employee
CREATE TABLE data_vault.hub_employee (
    hub_employee_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 3. Hub Service
CREATE TABLE data_vault.hub_service (
    hub_service_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    service_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 4. Hub Order
CREATE TABLE data_vault.hub_order (
    hub_order_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 5. Hub Status
CREATE TABLE data_vault.hub_status (
    hub_status_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 6. Hub Order Item
CREATE TABLE data_vault.hub_order_item (
    hub_order_item_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_item_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- 7. Hub Payment
CREATE TABLE data_vault.hub_payment (
    hub_payment_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_bk INT NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL
);

-- ============================================
-- LINK TABLES
-- ============================================

-- 1. Link Order - Client
CREATE TABLE data_vault.link_order_client (
    link_order_client_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    hub_client_key INT NOT NULL REFERENCES data_vault.hub_client(hub_client_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_order_key, hub_client_key)
);

-- 2. Link Order - Employee
CREATE TABLE data_vault.link_order_employee (
    link_order_employee_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    hub_employee_key INT NOT NULL REFERENCES data_vault.hub_employee(hub_employee_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_order_key, hub_employee_key)
);

-- 3. Link Order - Status
CREATE TABLE data_vault.link_order_status (
    link_order_status_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    hub_status_key INT NOT NULL REFERENCES data_vault.hub_status(hub_status_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_order_key, hub_status_key)
);

-- 4. Link Order Item - Order
CREATE TABLE data_vault.link_order_item_order (
    link_order_item_order_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_order_item_key INT NOT NULL REFERENCES data_vault.hub_order_item(hub_order_item_key),
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_order_item_key, hub_order_key)
);

-- 5. Link Order Item - Service
CREATE TABLE data_vault.link_order_item_service (
    link_order_item_service_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_order_item_key INT NOT NULL REFERENCES data_vault.hub_order_item(hub_order_item_key),
    hub_service_key INT NOT NULL REFERENCES data_vault.hub_service(hub_service_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_order_item_key, hub_service_key)
);

-- 6. Link Payment - Order
CREATE TABLE data_vault.link_payment_order (
    link_payment_order_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    hub_payment_key INT NOT NULL REFERENCES data_vault.hub_payment(hub_payment_key),
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    UNIQUE (hub_payment_key, hub_order_key)
);

-- ============================================
-- SATELLITE TABLES
-- ============================================

-- 1. Satellite Client
CREATE TABLE data_vault.sat_client (
    hub_client_key INT NOT NULL REFERENCES data_vault.hub_client(hub_client_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(200),
    PRIMARY KEY (hub_client_key, load_dts)
);

-- 2. Satellite Employee
CREATE TABLE data_vault.sat_employee (
    hub_employee_key INT NOT NULL REFERENCES data_vault.hub_employee(hub_employee_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    position VARCHAR(100),
    phone VARCHAR(20),
    PRIMARY KEY (hub_employee_key, load_dts)
);

-- 3. Satellite Service
CREATE TABLE data_vault.sat_service (
    hub_service_key INT NOT NULL REFERENCES data_vault.hub_service(hub_service_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    service_name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    PRIMARY KEY (hub_service_key, load_dts)
);

-- 4. Satellite Order
CREATE TABLE data_vault.sat_order (
    hub_order_key INT NOT NULL REFERENCES data_vault.hub_order(hub_order_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    order_date TIMESTAMP,
    PRIMARY KEY (hub_order_key, load_dts)
);

-- 5. Satellite Status
CREATE TABLE data_vault.sat_status (
    hub_status_key INT NOT NULL REFERENCES data_vault.hub_status(hub_status_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    status_name VARCHAR(50),
    PRIMARY KEY (hub_status_key, load_dts)
);

-- 6. Satellite Order Item
CREATE TABLE data_vault.sat_order_item (
    hub_order_item_key INT NOT NULL REFERENCES data_vault.hub_order_item(hub_order_item_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    quantity INT,
    unit_price DECIMAL(10, 2),
    PRIMARY KEY (hub_order_item_key, load_dts)
);

-- 7. Satellite Payment
CREATE TABLE data_vault.sat_payment (
    hub_payment_key INT NOT NULL REFERENCES data_vault.hub_payment(hub_payment_key),
    load_dts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(100) NOT NULL,
    hashdiff VARCHAR(64),
    payment_date TIMESTAMP,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    PRIMARY KEY (hub_payment_key, load_dts)
);
