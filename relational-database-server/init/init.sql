CREATE DATABASE IF NOT EXISTS minicloud;
USE minicloud;

CREATE TABLE notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100)
);

INSERT INTO notes(title) VALUES ("Hello from MariaDB!");
