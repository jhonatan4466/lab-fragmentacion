-- Fragmento horizontal: región Norte
CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  region VARCHAR(20),
  saldo NUMERIC(12,2) DEFAULT 0
);

INSERT INTO clientes (nombre, region, saldo) VALUES
('Ana Torres', 'Norte', 1500.00),
('Luis Ramírez', 'Norte', 2300.00),
('María López', 'Norte', 800.00);
