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
JOIN members ON memberships.member_id = members.member_id -- links each membership record to its respective member
WHERE memberships.status = 'Active';

-- 5.2 
SELECT 
    memberships.type AS membership_type,
    AVG(
        (julianday(attendance.check_out_time) - 
         julianday(attendance.check_in_time)) * 24 * 60
    ) AS avg_visit_duration_minutes -- multiplies by 24 and 60 to get time difference in minutes, subtracts and then gets average
FROM memberships
JOIN attendance ON memberships.member_id = attendance.member_id -- connects attendances to members
GROUP BY memberships.type;

-- 5.3 
SELECT 
    members.member_id,
    members.first_name,
    members.last_name,
    members.email,
    memberships.end_date
FROM memberships
JOIN members ON memberships.member_id = members.member_id -- only members with memberships are returned
WHERE memberships.end_date >= '2025-01-01' AND memberships.end_date <= '2025-12-31';
