-- =====================================================
-- Nodo coordinador: vista transparente con postgres_fdw
-- =====================================================

-- 1. Habilitar la extensión postgres_fdw
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. Servidores foráneos (el host es el nombre del servicio en Docker Compose)
CREATE SERVER servidor_norte
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'pg_nodo_norte', port '5432', dbname 'labdb');

CREATE SERVER servidor_sur
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'pg_nodo_sur', port '5432', dbname 'labdb');

-- 3. Mapeo de usuario local -> usuario remoto
CREATE USER MAPPING FOR labuser SERVER servidor_norte
  OPTIONS (user 'labuser', password 'labpass');

CREATE USER MAPPING FOR labuser SERVER servidor_sur
  OPTIONS (user 'labuser', password 'labpass');

-- 4. Tablas foráneas que apuntan a cada fragmento
--    Nota: se usa INTEGER (no SERIAL) porque el id lo genera el nodo remoto.
--    El CHECK describe el predicado de fragmentación; no se valida en el
--    remoto, pero el planificador lo usa (constraint_exclusion) para
--    descartar el fragmento que no puede contener las filas pedidas.
CREATE FOREIGN TABLE clientes_norte (
  id     INTEGER,
  nombre VARCHAR(100),
  region VARCHAR(20) CHECK (region = 'Norte'),
  saldo  NUMERIC(12,2)
)
SERVER servidor_norte
OPTIONS (schema_name 'public', table_name 'clientes');

CREATE FOREIGN TABLE clientes_sur (
  id     INTEGER,
  nombre VARCHAR(100),
  region VARCHAR(20) CHECK (region = 'Sur'),
  saldo  NUMERIC(12,2)
)
SERVER servidor_sur
OPTIONS (schema_name 'public', table_name 'clientes');

-- 5. Vista transparente que reconstruye la relación global
CREATE VIEW clientes_todos AS
  SELECT id, nombre, region, saldo FROM clientes_norte
  UNION ALL
  SELECT id, nombre, region, saldo FROM clientes_sur;
