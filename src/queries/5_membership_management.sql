.open fittrackpro.db
.mode column

-- 5.1 
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    memberships.type AS membership_type,
    members.join_date
FROM memberships
JOIN members ON memberships.member_id = members.member_id
WHERE memberships.status = 'Active';

-- 5.2 
SELECT 
    memberships.type AS membership_type,
    AVG(
        (julianday(attendance.check_out_time) - 
         julianday(attendance.check_in_time)) * 24 * 60
    ) AS avg_visit_duration_minutes
FROM memberships
JOIN attendance ON memberships.member_id = attendance.member_id
WHERE attendance.check_out_time IS NOT NULL
GROUP BY memberships.type;

-- 5.3 
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    members.email,
    memberships.end_date
FROM memberships
JOIN members ON memberships.member_id = members.member_id
WHERE memberships.end_date >= '2025-01-01' AND memberships.end_date <= '2025-12-31';
