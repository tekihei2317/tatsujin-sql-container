CREATE TABLE Students (name CHAR(16) PRIMARY KEY, age INTEGER);

INSERT INTO
  Students
VALUES
  ('�u���E��', 22);

INSERT INTO
  Students
VALUES
  ('�����[', 19);

INSERT INTO
  Students
VALUES
  ('�W����', NULL);

INSERT INTO
  Students
VALUES
  ('�{�M�[', 21);

CREATE TABLE EmptyStr (str CHAR(8), description CHAR(16));

INSERT INTO
  EmptyStr
VALUES
  ('', 'empty string');

INSERT INTO
  EmptyStr
VALUES
  (NULL, 'NULL');