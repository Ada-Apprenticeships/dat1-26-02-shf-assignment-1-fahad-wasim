.open fittrackpro.db
.mode column

-- 7.1 
SELECT staff_id, first_name, last_name, role
FROM staff
ORDER BY role;

-- 7.2 
SELECT 
    staff.staff_id AS trainer_id,
    staff.first_name || ' ' || staff.last_name AS trainer_name,
    COUNT(personal_training_sessions.session_id) AS session_count
FROM staff
JOIN personal_training_sessions 
    ON staff.staff_id = personal_training_sessions.staff_id
WHERE personal_training_sessions.session_date >= '2025-01-20' AND personal_training_sessions.session_date < DATE('2025-01-20', '+30 days')
GROUP BY staff.staff_id, staff.first_name, staff.last_name
HAVING COUNT(personal_training_sessions.session_id) >= 1;