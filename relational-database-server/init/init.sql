CREATE DATABASE IF NOT EXISTS studentdb;
USE studentdb;

CREATE TABLE students (
  id INT PRIMARY KEY AUTO_INCREMENT,
  student_id VARCHAR(10),
  fullname VARCHAR(100),
  dob DATE,
  major VARCHAR(50)
);

INSERT INTO students (student_id, fullname, dob, major) VALUES
  ('SV001', 'Nguyen Van An', '2003-05-15', 'Computer Science'),
  ('SV002', 'Tran Thi Bich', '2003-08-22', 'Information Technology'),
  ('SV003', 'Le Hoang Cuong', '2002-12-01', 'Software Engineering');
