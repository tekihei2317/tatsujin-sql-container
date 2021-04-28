create database Chapter7;
use Chapter7;

-- 成長・後退・現状維持
CREATE TABLE Sales(
  year INTEGER NOT NULL , 
  sale INTEGER NOT NULL ,
  PRIMARY KEY (year)
);

INSERT INTO Sales VALUES (1990, 50);
INSERT INTO Sales VALUES (1991, 51);
INSERT INTO Sales VALUES (1992, 52);
INSERT INTO Sales VALUES (1993, 52);
INSERT INTO Sales VALUES (1994, 50);
INSERT INTO Sales VALUES (1995, 50);
INSERT INTO Sales VALUES (1996, 49);
INSERT INTO Sales VALUES (1997, 55);

-- 時系列に歯抜けがある場合：直近と比較
CREATE TABLE Sales2(
  year INTEGER NOT NULL , 
  sale INTEGER NOT NULL , 
  PRIMARY KEY (year)
);

INSERT INTO Sales2 VALUES (1990, 50);
INSERT INTO Sales2 VALUES (1992, 50);
INSERT INTO Sales2 VALUES (1993, 52);
INSERT INTO Sales2 VALUES (1994, 55);
INSERT INTO Sales2 VALUES (1997, 55);

-- オーバーラップする期間を調べる
CREATE TABLE Reservations(
  reserver    VARCHAR(30) PRIMARY KEY,
  start_date  DATE  NOT NULL,
  end_date    DATE  NOT NULL
);

INSERT INTO Reservations VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('山本', '2018-11-03', '2018-11-04');
INSERT INTO Reservations VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('水谷', '2018-11-06', '2018-11-06');

-- 山本氏の投宿日が4日の場合
-- DELETE FROM Reservations WHERE reserver = '山本';
-- INSERT INTO Reservations VALUES('山本', '2018-11-04', '2018-11-04');


-- オーバーラップする期間を求める  その1：相関サブクエリの利用
-- 山本・内田・水谷の3人が重複

CREATE TABLE Reservations2(
  reserver    VARCHAR(30) PRIMARY KEY,
  start_date  DATE  NOT NULL,
  end_date    DATE  NOT NULL
);

INSERT INTO Reservations2 VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations2 VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations2 VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations2 VALUES('山本', '2018-11-03', '2018-11-04');
INSERT INTO Reservations2 VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations2 VALUES('水谷', '2018-11-04', '2018-11-06');


-- 山本氏を「日帰り」で登録(相関サブクエリの結果から内田氏が消える)
CREATE TABLE Reservations3(
  reserver    VARCHAR(30) PRIMARY KEY,
  start_date  DATE  NOT NULL,
  end_date    DATE  NOT NULL
);

INSERT INTO Reservations3 VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations3 VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations3 VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations3 VALUES('山本', '2018-11-04', '2018-11-04');
INSERT INTO Reservations3 VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations3 VALUES('水谷', '2018-11-06', '2018-11-06');


-- 演習問題：1-6
CREATE TABLE Accounts(
  prc_date DATE NOT NULL , 
  prc_amt  INTEGER NOT NULL , 
  PRIMARY KEY (prc_date)
);

INSERT INTO Accounts VALUES ('2018-10-26',  12000 );
INSERT INTO Accounts VALUES ('2018-10-28',   2500 );
INSERT INTO Accounts VALUES ('2018-10-31', -15000 );
INSERT INTO Accounts VALUES ('2018-11-03',  34000 );
INSERT INTO Accounts VALUES ('2018-11-04',  -5000 );
INSERT INTO Accounts VALUES ('2018-11-06',   7200 );
INSERT INTO Accounts VALUES ('2018-11-11',  11000 );