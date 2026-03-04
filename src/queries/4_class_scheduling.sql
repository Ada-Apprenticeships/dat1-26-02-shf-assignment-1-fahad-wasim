.open fittrackpro.db
.mode column

-- 4.1 
SELECT 
    classes.class_id,
    classes.name AS class_name,
    staff.first_name || ' ' || staff.last_name AS instructor_name -- combines staff first name and last name
FROM classes
JOIN class_schedule ON classes.class_id = class_schedule.class_id -- classes linked to scheduled sessions
JOIN staff ON class_schedule.staff_id = staff.staff_id; -- link sessions to instructors

-- 4.2 
SELECT 
    classes.class_id,
    classes.name,
    class_schedule.start_time,
    class_schedule.end_time,
    classes.capacity - COUNT(class_attendance.member_id) AS available_spots -- calculate the remaining capacity
FROM classes
JOIN class_schedule ON classes.class_id = class_schedule.class_id -- only scheduled classes
LEFT JOIN class_attendance -- ensures lessons are kept even with no members
    ON class_schedule.schedule_id = class_attendance.schedule_id AND class_attendance.attendance_status = 'Registered' -- only count registered members
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
JOIN class_schedule ON classes.class_id = class_schedule.class_id -- restricts to classes that have scheduled sessions
JOIN class_attendance 
    ON class_schedule.schedule_id = class_attendance.schedule_id -- only sessions with attendance records are counted
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