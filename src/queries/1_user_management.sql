.open fittrackpro.db
.mode column

-- 1.1
SELECT member_id, first_name, last_name, email, join_date
FROM members;

-- 1.2
UPDATE members
SET 
    phone_number = '07000 100005',
    email = 'emily.jones.updated@email.com'
WHERE member_id = 5;

-- 1.3
SELECT COUNT(*) AS total_members
FROM members;

-- 1.4
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    COUNT(class_attendance.class_attendance_id) AS registrations
FROM members
JOIN class_attendance 
    ON members.member_id = class_attendance.member_id -- only members with registrations
GROUP BY 
    members.member_id, 
    members.first_name, 
    members.last_name
ORDER BY registrations DESC
LIMIT 1;

-- 1.5
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    COUNT(class_attendance.class_attendance_id) AS registrations
FROM members
LEFT JOIN class_attendance
    ON members.member_id = class_attendance.member_id -- includes members with zero registrations
GROUP BY members.member_id
ORDER BY registrations ASC
LIMIT 1;

-- 1.6
SELECT COUNT(*) AS two_or_more_attendance_member_count
FROM (
    SELECT member_id
    FROM class_attendance
    WHERE attendance_status = 'Attended'
    GROUP BY member_id
    HAVING COUNT(class_attendance_id) >= 2 -- count is only equal to or greater than two
);