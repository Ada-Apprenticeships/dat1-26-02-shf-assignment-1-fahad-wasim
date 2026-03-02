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
    email TEXT NOT NULL UNIQUE CHECK (email LIKE '%_@_%._%'),
    opening_hours TEXT NOT NULL CHECK (opening_hours LIKE '__:__-__:__')
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE CHECK (email LIKE '%_@_%._%'),
    phone_number VARCHAR(13) NOT NULL,
    date_of_birth DATE NOT NULL CHECK (date_of_birth LIKE '____-__-__'),
    join_date DATE NOT NULL CHECK (join_date LIKE '____-__-__'),
    emergency_contact_name TEXT,
    emergency_contact_phone VARCHAR(13)
);

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE CHECK (email LIKE '%_@_%._%'),
    phone_number VARCHAR(13) NOT NULL,
    position TEXT NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE NOT NULL CHECK (hire_date LIKE '____-__-__'),
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL CHECK (purchase_date LIKE '____-__-__'),
    last_maintenance_date DATE CHECK (last_maintenance_date LIKE '____-__-__'),
    next_maintenance_date DATE CHECK (next_maintenance_date LIKE '____-__-__'),
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    duration INTEGER NOT NULL CHECK (duration > 0),
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    start_time TEXT NOT NULL CHECK (start_time LIKE '____-__-__ __:__:__'),
    end_time TEXT NOT NULL CHECK (end_time LIKE '____-__-__ __:__:__'),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    start_date DATE NOT NULL CHECK (start_date LIKE '____-__-__'),
    end_date DATE CHECK (end_date LIKE '____-__-__'),
    status TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time TEXT NOT NULL CHECK (check_in_time LIKE '____-__-__ __:__:__'),
    check_out_time TEXT CHECK (check_out_time LIKE '____-__-__ __:__:__'),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount REAL NOT NULL CHECK (amount > 0),
    payment_date TEXT NOT NULL CHECK (payment_date LIKE '____-__-__ __:__:__'),
    payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date DATE NOT NULL CHECK (session_date LIKE '____-__-__'),
    start_time TEXT NOT NULL CHECK (start_time LIKE '__:__:__'),
    end_time TEXT NOT NULL CHECK (end_time LIKE '__:__:__'),
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    measurement_date DATE NOT NULL CHECK (measurement_date LIKE '____-__-__'),
    weight REAL CHECK (weight > 0),
    body_fat_percentage REAL CHECK (body_fat_percentage >= 0 AND body_fat_percentage <= 100),
    muscle_mass REAL CHECK (muscle_mass > 0),
    bmi REAL CHECK (bmi > 0),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL CHECK (maintenance_date LIKE '____-__-__'),
    description TEXT NOT NULL,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE ON UPDATE CASCADE
);

.tables