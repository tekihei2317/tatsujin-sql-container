/* テーブル同士のコンペア　集合の相等性チェック */
CREATE TABLE Tbl_A
 (keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER);

CREATE TABLE Tbl_B
 (keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER);

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
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', 2, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', 5, 1, 6);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', 2, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 8);
INSERT INTO Tbl_B VALUES('C', 5, 1, 6);


/* NULLを含むケース（等しい） */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', NULL, NULL, NULL);


/* NULLを含むケース（「C」の行が異なる） */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', 0, NULL, NULL);


/* 3. 差集合で関係除算を表現する */
CREATE TABLE Skills 
(skill VARCHAR(32),
 PRIMARY KEY(skill));

CREATE TABLE EmpSkills 
(emp   VARCHAR(32), 
 skill VARCHAR(32),
 PRIMARY KEY(emp, skill));

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
CREATE TABLE SupParts
(sup  CHAR(32) NOT NULL,
 part CHAR(32) NOT NULL,
 PRIMARY KEY(sup, part));

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
CREATE TABLE Products
(name  CHAR(16),
 price INTEGER);

INSERT INTO Products VALUES('りんご',  50);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('みかん', 100);
INSERT INTO Products VALUES('バナナ',  80);

/* テーブル同士のコンペア：基本編*/
SELECT COUNT(*) AS row_cnt
  FROM ( SELECT * 
           FROM   tbl_A 
         UNION
         SELECT * 
           FROM   tbl_B ) TMP;

/* テーブル同士のコンペア：応用編（Oracleでは通らない） */
SELECT CASE WHEN COUNT(*) = 0 
            THEN '等しい'
            ELSE '異なる' END AS result
  FROM ((SELECT * FROM  tbl_A
         UNION
         SELECT * FROM  tbl_B) 
         EXCEPT
        (SELECT * FROM  tbl_A
         INTERSECT 
         SELECT * FROM  tbl_B)) TMP;

/* テーブルに対するdiff：排他的和集合を求める */
(SELECT * FROM  tbl_A
   EXCEPT
 SELECT * FROM  tbl_B)
 UNION ALL
(SELECT * FROM  tbl_B
   EXCEPT
 SELECT * FROM  tbl_A);

/* 差集合で関係除算（剰余を持った除算） */
SELECT DISTINCT emp
  FROM EmpSkills ES1
 WHERE NOT EXISTS
        (SELECT skill
           FROM Skills
         EXCEPT
         SELECT skill
           FROM EmpSkills ES2
          WHERE ES1.emp = ES2.emp);

/* 等しい部分集合を見つける(p.134) */
SELECT SP1.sup, SP2.sup
  FROM SupParts SP1, SupParts SP2 
 WHERE SP1.sup < SP2.sup              /* 業者の組み合わせを作る */
   AND SP1.part = SP2.part            /* 条件１．同じ種類の部品を扱う */
GROUP BY SP1.sup, SP2.sup 
HAVING COUNT(*) = (SELECT COUNT(*)    /* 条件２．同数の部品を扱う */
                     FROM SupParts SP3 
                    WHERE SP3.sup = SP1.sup)
   AND COUNT(*) = (SELECT COUNT(*) 
                     FROM SupParts SP4 
                    WHERE SP4.sup = SP2.sup);

/* 重複行を削除する高速なクエリ１：補集合をEXCEPTで求める */
DELETE FROM Products
 WHERE rowid IN ( SELECT rowid
                    FROM Products 
                  EXCEPT
                  SELECT MAX(rowid)
                    FROM Products 
                   GROUP BY name, price);

/* 重複行を削除する高速なクエリ２：補集合をNOT IN で求める */
DELETE FROM Products 
 WHERE rowid NOT IN ( SELECT MAX(rowid)
                        FROM Products 
                       GROUP BY name, price);