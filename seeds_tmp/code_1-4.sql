CREATE TABLE Students (name CHAR(16) PRIMARY KEY, age INTEGER);

INSERT INTO
  Students
VALUES
  ('ブラウン', 22);

INSERT INTO
  Students
VALUES
  ('ラリー', 19);

INSERT INTO
  Students
VALUES
  ('ジョン', NULL);

INSERT INTO
  Students
VALUES
  ('ボギー', 21);

CREATE TABLE EmptyStr (str CHAR(8), description CHAR(16));

INSERT INTO
  EmptyStr
VALUES
  ('', 'empty string');

INSERT INTO
  EmptyStr
VALUES
  (NULL, 'NULL');