.open fittrackpro.db
.mode column

-- 6.1 
INSERT INTO attendance (member_id, location_id, check_in_time)
VALUES (7, 1, '2025-02-14 16:30:00');

-- 6.2 
SELECT 
    DATE(check_in_time) AS visit_date,
    check_in_time,
    check_out_time
FROM attendance
WHERE member_id = 5
ORDER BY check_in_time;

-- 6.3 
SELECT 
    strftime('%w', check_in_time) AS day_of_week,
    COUNT(attendance_id) AS visit_count
FROM attendance
GROUP BY strftime('%w', check_in_time)
ORDER BY visit_count DESC
LIMIT 1;

-- 6.4 
SELECT 
    locations.name AS location_name,
    AVG(daily_counts.daily_total) AS avg_daily_attendance
FROM locations
LEFT JOIN (
    SELECT 
        location_id,
        DATE(check_in_time) AS visit_date,
        COUNT(attendance_id) AS daily_total
    FROM attendance
    GROUP BY location_id, DATE(check_in_time)
) AS daily_counts
ON locations.location_id = daily_counts.location_id
GROUP BY locations.name;
