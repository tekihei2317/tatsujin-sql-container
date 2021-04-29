create database Chapter8;
use Chapter8;

/* 外部結合で行列変換　その1（行→列）：クロス表を作る */
CREATE TABLE Courses(
  name   VARCHAR(32), 
  course VARCHAR(32), 
  PRIMARY KEY(name, course)
);

INSERT INTO Courses VALUES('赤井', 'SQL入門');
INSERT INTO Courses VALUES('赤井', 'UNIX基礎');
INSERT INTO Courses VALUES('鈴木', 'SQL入門');
INSERT INTO Courses VALUES('工藤', 'SQL入門');
INSERT INTO Courses VALUES('工藤', 'Java中級');
INSERT INTO Courses VALUES('吉田', 'UNIX基礎');
INSERT INTO Courses VALUES('渡辺', 'SQL入門');

/* 外部結合で行列変換　その2（列→行）：繰り返し項目を1 列にまとめる */
CREATE TABLE Personnel(
  employee   varchar(32), 
  child_1    varchar(32), 
  child_2    varchar(32), 
  child_3    varchar(32), 
  PRIMARY KEY(employee)
);

INSERT INTO Personnel VALUES('赤井', '一郎', '二郎', '三郎');
INSERT INTO Personnel VALUES('工藤', '春子', '夏子', NULL);
INSERT INTO Personnel VALUES('鈴木', '夏子', NULL,   NULL);
INSERT INTO Personnel VALUES('吉田', NULL,   NULL,   NULL);

/* クロス表で入れ子の表側を作る */
CREATE TABLE TblSex(
  sex_cd   char(1), 
  sex varchar(5), 
  PRIMARY KEY(sex_cd)
);

CREATE TABLE TblAge (
  age_class char(1), 
  age_range varchar(30), 
  PRIMARY KEY(age_class)
);

CREATE TABLE TblPop (
  pref_name  varchar(30), 
  age_class  char(1), 
  sex_cd     char(1), 
  population integer, 
  PRIMARY KEY(pref_name, age_class,sex_cd)
);

INSERT INTO TblSex (sex_cd, sex ) VALUES('m',	'男');
INSERT INTO TblSex (sex_cd, sex ) VALUES('f',	'女');

INSERT INTO TblAge (age_class, age_range ) VALUES('1',	'21〜30歳');
INSERT INTO TblAge (age_class, age_range ) VALUES('2',	'31〜40歳');
INSERT INTO TblAge (age_class, age_range ) VALUES('3',	'41〜50歳');

INSERT INTO TblPop VALUES('秋田', '1', 'm', 400 );
INSERT INTO TblPop VALUES('秋田', '3', 'm', 1000 );
INSERT INTO TblPop VALUES('秋田', '1', 'f', 800 );
INSERT INTO TblPop VALUES('秋田', '3', 'f', 1000 );
INSERT INTO TblPop VALUES('青森', '1', 'm', 700 );
INSERT INTO TblPop VALUES('青森', '1', 'f', 500 );
INSERT INTO TblPop VALUES('青森', '3', 'f', 800 );
INSERT INTO TblPop VALUES('東京', '1', 'm', 900 );
INSERT INTO TblPop VALUES('東京', '1', 'f', 1500 );
INSERT INTO TblPop VALUES('東京', '3', 'f', 1200 );
INSERT INTO TblPop VALUES('千葉', '1', 'm', 900 );
INSERT INTO TblPop VALUES('千葉', '1', 'f', 1000 );
INSERT INTO TblPop VALUES('千葉', '3', 'f', 900 );

/* 掛け算としての結合 */
CREATE TABLE Items(
  item_no INTEGER PRIMARY KEY,
  item    VARCHAR(32) NOT NULL
);

INSERT INTO Items VALUES(10, 'FD');
INSERT INTO Items VALUES(20, 'CD-R');
INSERT INTO Items VALUES(30, 'MO');
INSERT INTO Items VALUES(40, 'DVD');

CREATE TABLE SalesHistory(
  sale_date DATE NOT NULL,
  item_no   INTEGER NOT NULL,
  quantity  INTEGER NOT NULL,
  PRIMARY KEY(sale_date, item_no)
);

INSERT INTO SalesHistory VALUES('2018-10-01',  10,  4);
INSERT INTO SalesHistory VALUES('2018-10-01',  20, 10);
INSERT INTO SalesHistory VALUES('2018-10-01',  30,  3);
INSERT INTO SalesHistory VALUES('2018-10-03',  10, 32);
INSERT INTO SalesHistory VALUES('2018-10-03',  30, 12);
INSERT INTO SalesHistory VALUES('2018-10-04',  20, 22);
INSERT INTO SalesHistory VALUES('2018-10-04',  30,  7);

/* 完全外部結合 */
CREATE TABLE Class_A(
  id char(1), 
  name varchar(30), 
  PRIMARY KEY(id)
);

CREATE TABLE Class_B(
  id   char(1), 
  name varchar(30), 
  PRIMARY KEY(id)
);

INSERT INTO Class_A (id, name) VALUES('1', '田中');
INSERT INTO Class_A (id, name) VALUES('2', '鈴木');
INSERT INTO Class_A (id, name) VALUES('3', '伊集院');

INSERT INTO Class_B (id, name) VALUES('1', '田中');
INSERT INTO Class_B (id, name) VALUES('2', '鈴木');
INSERT INTO Class_B (id, name) VALUES('4', '西園寺');
