-- Fragmento horizontal: región Sur
CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  region VARCHAR(20),
  saldo NUMERIC(12,2) DEFAULT 0
);

INSERT INTO clientes (nombre, region, saldo) VALUES
('Carlos Mendoza', 'Sur', 1200.00),
('Rosa García', 'Sur', 950.00),
('Pedro Sánchez', 'Sur', 1750.00);
