CREATE USER IF NOT EXISTS 'manager'@'%'  IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'analyst'@'%'  IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'director'@'%' IDENTIFIED BY '1234';

GRANT SELECT, INSERT, UPDATE, DELETE ON pawnshop.* TO 'manager'@'%';
GRANT SELECT ON pawnshop.* TO 'analyst'@'%';
GRANT SELECT ON pawnshop.* TO 'director'@'%';