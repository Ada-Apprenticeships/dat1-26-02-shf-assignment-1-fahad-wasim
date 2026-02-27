.open fittrackpro.db
.mode column

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    phone_number VARCHAR(13) NOT NULL,
    email TEXT NOT NULL UNIQUE
        CHECK (
            email LIKE '%_@_%._%'
        ),
    opening_hours TEXT NOT NULL
        CHECK (
            opening_hours LIKE '__:__-__:__'
        )
);

.tables