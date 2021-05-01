create database Chapter9;
use Chapter9;


/* テーブル同士のコンペア　集合の相等性チェック */
CREATE TABLE Tbl_A(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER
);

CREATE TABLE Tbl_B(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER
);

/* 等しいテーブル同士のケース */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', 2, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', 5, 1, 6);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', 2, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', 5, 1, 6);


/* 「B」の行が相違するケース */
CREATE TABLE Tbl_A2(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER
);

CREATE TABLE Tbl_B2(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER
);

DELETE FROM Tbl_A2;
INSERT INTO Tbl_A2 VALUES('A', 2, 3, 4);
INSERT INTO Tbl_A2 VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A2 VALUES('C', 5, 1, 6);

DELETE FROM Tbl_B2;
INSERT INTO Tbl_B2 VALUES('A', 2, 3, 4);
INSERT INTO Tbl_B2 VALUES('B', 0, 7, 8);
INSERT INTO Tbl_B2 VALUES('C', 5, 1, 6);


/* NULLを含むケース（等しい） */
CREATE TABLE Tbl_A3(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER
);

CREATE TABLE Tbl_B3(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER
);

DELETE FROM Tbl_A3;
INSERT INTO Tbl_A3 VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A3 VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A3 VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B3;
INSERT INTO Tbl_B3 VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B3 VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B3 VALUES('C', NULL, NULL, NULL);


/* NULLを含むケース（「C」の行が異なる） */
CREATE TABLE Tbl_A4(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER
);

CREATE TABLE Tbl_B4(
  keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER
);

DELETE FROM Tbl_A4;
INSERT INTO Tbl_A4 VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A4 VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A4 VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B4;
INSERT INTO Tbl_B4 VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B4 VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B4 VALUES('C', 0, NULL, NULL);


/* 3. 差集合で関係除算を表現する */
CREATE TABLE Skills (
  skill VARCHAR(32),
  PRIMARY KEY(skill)
);

CREATE TABLE EmpSkills (
  emp   VARCHAR(32), 
  skill VARCHAR(32),
  PRIMARY KEY(emp, skill)
);

INSERT INTO Skills VALUES('Oracle');
INSERT INTO Skills VALUES('UNIX');
INSERT INTO Skills VALUES('Java');

INSERT INTO EmpSkills VALUES('相田', 'Oracle');
INSERT INTO EmpSkills VALUES('相田', 'UNIX');
INSERT INTO EmpSkills VALUES('相田', 'Java');
INSERT INTO EmpSkills VALUES('相田', 'C#');
INSERT INTO EmpSkills VALUES('神崎', 'Oracle');
INSERT INTO EmpSkills VALUES('神崎', 'UNIX');
INSERT INTO EmpSkills VALUES('神崎', 'Java');
INSERT INTO EmpSkills VALUES('平井', 'UNIX');
INSERT INTO EmpSkills VALUES('平井', 'Oracle');
INSERT INTO EmpSkills VALUES('平井', 'PHP');
INSERT INTO EmpSkills VALUES('平井', 'Perl');
INSERT INTO EmpSkills VALUES('平井', 'C++');
INSERT INTO EmpSkills VALUES('若田部', 'Perl');
INSERT INTO EmpSkills VALUES('渡来', 'Oracle');

/* 4. 等しい部分集合を見つける */
CREATE TABLE SupParts(
  sup  CHAR(32) NOT NULL,
  part CHAR(32) NOT NULL,
  PRIMARY KEY(sup, part)
);

INSERT INTO SupParts VALUES('A',  'ボルト');
INSERT INTO SupParts VALUES('A',  'ナット');
INSERT INTO SupParts VALUES('A',  'パイプ');
INSERT INTO SupParts VALUES('B',  'ボルト');
INSERT INTO SupParts VALUES('B',  'パイプ');
INSERT INTO SupParts VALUES('C',  'ボルト');
INSERT INTO SupParts VALUES('C',  'ナット');
INSERT INTO SupParts VALUES('C',  'パイプ');
INSERT INTO SupParts VALUES('D',  'ボルト');
INSERT INTO SupParts VALUES('D',  'パイプ');
INSERT INTO SupParts VALUES('E',  'ヒューズ');
INSERT INTO SupParts VALUES('E',  'ナット');
INSERT INTO SupParts VALUES('E',  'パイプ');
INSERT INTO SupParts VALUES('F',  'ヒューズ');

/* 5. 重複行を削除する高速なクエリ
PostgreSQLでは「with oids」をCREATE TABLE文の最後に追加すること */
CREATE TABLE Products(
  name  CHAR(16),
  price INTEGER
);

INSERT INTO Products VALUES('りんご',  50);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('バナナ',  80);
