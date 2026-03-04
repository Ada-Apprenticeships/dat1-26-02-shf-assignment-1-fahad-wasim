.open fittrackpro.db
.mode column

-- 3.1 
SELECT equipment_id, name, next_maintenance_date
FROM equipment
WHERE next_maintenance_date >= '2025-01-01' AND next_maintenance_date <= '2025-01-31';

-- 3.2 
SELECT 
    type AS equipment_type,
    COUNT(*) AS count
FROM equipment
GROUP BY type;

-- 3.3 
SELECT 
    type AS equipment_type,
    AVG(julianday('now') - julianday(purchase_date)) AS average_age_in_days -- average days is calculated by average date difference
FROM equipment
GROUP BY type;
