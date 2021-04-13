
CREATE TABLE Students
(name CHAR(16) PRIMARY KEY,
 age  INTEGER  );

INSERT INTO Students VALUES('ブラウン',  22);
INSERT INTO Students VALUES('ラリー',    19);
INSERT INTO Students VALUES('ジョン',    NULL);
INSERT INTO Students VALUES('ボギー',    21);


SELECT *
  FROM Students
 WHERE age IS DISTINCT FROM 20;


-- 空文字との連結（Oracle）
SELECT 'abc' || '' AS string FROM dual;

-- NULLとの連結（Oracle）
SELECT 'abc' || NULL AS string FROM dual;

CREATE TABLE EmptyStr
( str CHAR(8),
  description CHAR(16));

INSERT INTO EmptyStr VALUES('', 'empty string');
INSERT INTO EmptyStr VALUES(NULL, 'NULL' );


SELECT 'abc' || str AS string, description
  FROM EmptyStr;


