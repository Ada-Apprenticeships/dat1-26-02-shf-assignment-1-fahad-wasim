.open fittrackpro.db
.mode column

-- 4.1 
SELECT 
    classes.class_id,
    classes.name AS class_name,
    staff.first_name || ' ' || staff.last_name AS instructor_name
FROM classes
JOIN class_schedule ON classes.class_id = class_schedule.class_id
JOIN staff ON class_schedule.staff_id = staff.staff_id;

-- 4.2 
SELECT 
    classes.class_id,
    classes.name,
    class_schedule.start_time,
    class_schedule.end_time,
    classes.capacity - COUNT(class_attendance.member_id) AS available_spots
FROM classes
JOIN class_schedule ON classes.class_id = class_schedule.class_id
LEFT JOIN class_attendance 
    ON class_schedule.schedule_id = class_attendance.schedule_id AND class_attendance.attendance_status = 'Registered'
WHERE class_schedule.start_time LIKE '2025-02-01%'
GROUP BY 
    classes.class_id,
    classes.name,
    class_schedule.start_time,
    class_schedule.end_time,
    classes.capacity;

-- 4.3 
INSERT INTO class_attendance (schedule_id, member_id, attendance_status)
VALUES ( 
    (SELECT schedule_id 
     FROM class_schedule 
     WHERE class_id = 1 AND start_time LIKE '2025-02-01%'),
    11,
    'Registered'
);

-- 4.4 
DELETE FROM class_attendance
WHERE schedule_id = 7 AND member_id = 3;

-- 4.5 
SELECT 
    classes.class_id,
    classes.name AS class_name,
    COUNT(class_attendance.member_id) AS registration_count
FROM classes
JOIN class_schedule ON classes.class_id = class_schedule.class_id
JOIN class_attendance 
    ON class_schedule.schedule_id = class_attendance.schedule_id
WHERE class_attendance.attendance_status = 'Registered'
GROUP BY classes.class_id, classes.name
ORDER BY registration_count DESC
LIMIT 1;

-- 4.6
SELECT 
    AVG(count) as average_number_of_classes
FROM (
    SELECT 
        member_id,
        COUNT(schedule_id) AS count
    FROM class_attendance
    WHERE attendance_status IN ('Registered', 'Attended')
    GROUP BY member_id
);