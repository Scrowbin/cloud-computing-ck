CREATE DATABASE IF NOT EXISTS minicloud;
USE minicloud;

CREATE TABLE IF NOT EXISTS notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO notes (title) VALUES ('Hello from MariaDB!');

-- Advanced Requirement: Create studentdb and students table
CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

CREATE TABLE IF NOT EXISTS students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(50) NOT NULL UNIQUE,
  fullname VARCHAR(100) NOT NULL,
  dob DATE NOT NULL,
  major VARCHAR(100) NOT NULL
);

INSERT INTO students (student_id, fullname, dob, major) VALUES
  ('SV001', 'Nguyen Van A', '2000-01-01', 'Computer Science'),
  ('SV002', 'Tran Thi B', '2001-05-15', 'Information Technology'),
  ('SV003', 'Le Van C', '2002-10-20', 'Software Engineering');
