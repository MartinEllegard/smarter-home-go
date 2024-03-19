-- name: GetUserById :one
SELECT 
  u.id, u.firstname, u.lastname, u.phone, u.company, u.address,
  i.id AS identity_id, i.username, i.email,
  r.name AS role
FROM 
  users u
  JOIN identity i ON users.id = identity.user_id
  LEFT JOIN LATERAL(
    SELECT * FROM roles inner_roles
    WHERE inner_roles.id IN (SELECT role_id FROM user_roles WHERE user_id = users.id)
    ORDER BY inner_roles.id LIMIT 1
  ) r ON true
WHERE u.id = $1;

-- name: CreateUser :one
INSERT INTO users 
  (firstname, lastname, phone, company, address)
VALUES 
  ($1, $2, $3, $4, $5)
RETURNING *;

-- name: UpdateUser :one
UPDATE users
  SET firstname = $2, lastname = $3, phone = $4, company = $5, address = $6, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
UPDATE users
  SET updated_at = NOW(), deleted_at = NOW()
WHERE id = $1;

-- name: GetIdentity :one
SELECT * FROM identity WHERE username = $1 OR email = $1;

-- name: GetIdentityById :one
SELECT * FROM identity WHERE id = $1;

-- name: CreateIdentity :one
INSERT INTO identity 
  (user_id, username, email, password_hash)
VALUES 
  ($1, $2, $3, $4)
RETURNING *;

-- name: UpdatePassword :exec
UPDATE identity
  SET password_hash = $2, updated_at = NOW()
WHERE id = $1;

-- name: DeleteIdentiy :exec
UPDATE identity
  SET updated_at = NOW(), deleted_at = NOW()
WHERE id = $1;

-- name: GetHomesForUser :many
SELECT * FROM homes WHERE user_id = $1;

-- name: GetHomeById :one
SELECT * FROM homes WHERE id = $1;

-- name: CreateHome :one
INSERT INTO homes 
  (user_id, name, address)
VALUES 
  ($1, $2, $3)
RETURNING *;

-- name: UpdateHome :one
UPDATE homes
  SET name = $2, address = $3, updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteHome :exec
UPDATE homes
  SET updated_at = NOW(), deleted_at = NOW();

-- name: GetPowerConsumptionBetween :many
SELECT * FROM power_consumption 
WHERE 
  home_id = $1 AND 
  ts BETWEEN $2 AND $3;

-- name: CreatePowerConsumpion :exec
INSERT INTO power_consumption (
  home_id,
  power,
  min_power,
  max_power,
  avg_power,
  last_meter_consumption,
  last_meter_production,
  accumulated_consumption_today,
  accumulated_production_today,
  accumulated_consumption_hour,
  accumulated_production_hour,
  current_price_from_provider,
  accumulated_cost_today,
  ts
)
VALUES 
  ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);

-- name: BulkCreatePowerConsumpion :copyfrom
INSERT INTO power_consumption (
  home_id,
  power,
  min_power,
  max_power,
  avg_power,
  last_meter_consumption,
  last_meter_production,
  accumulated_consumption_today,
  accumulated_production_today,
  accumulated_consumption_hour,
  accumulated_production_hour,
  current_price_from_provider,
  accumulated_cost_today,
  ts
)
VALUES 
  ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14);
