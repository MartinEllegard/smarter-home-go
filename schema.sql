CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  firstname TEXT NOT NULL,
  lastname TEXT NOT NULL,
  phone TEXT,
  company TEXT,
  address TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Identity table for authentication
CREATE TABLE IF NOT EXISTS identity (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL references users(id),
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS user_roles (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL references users(id),
  role_id INT NOT NULL references roles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- User's homes required for power consumption
CREATE TABLE IF NOT EXISTS homes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id INT NOT NULL references users(id),
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Power consumption table. Typical readings from HAN device
CREATE TABLE IF NOT EXISTS power_consumption (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  home_id UUID NOT NULL references homes(id),

  -- Power reading
  power DOUBLE PRECISION,
  min_power DOUBLE PRECISION,
  max_power DOUBLE PRECISION,
  avg_power DOUBLE PRECISION,

  -- Meter reading
  last_meter_consumption DOUBLE PRECISION,
  last_meter_production DOUBLE PRECISION,

  -- Accumulated consumption/production
  accumulated_consumption_today DOUBLE PRECISION,
  accumulated_production_today DOUBLE PRECISION,
  accumulated_consumption_hour DOUBLE PRECISION,
  accumulated_production_hour DOUBLE PRECISION,

  -- Price/cost
  current_price_from_provider DOUBLE PRECISION,
  accumulated_cost_today DOUBLE PRECISION,

  -- Timestamp
  ts TIMESTAMPTZ NOT NULL
);
