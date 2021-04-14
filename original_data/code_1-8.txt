/* 外部結合で行列変換　その1（行→列）：クロス表を作る */
CREATE TABLE Courses
(name   VARCHAR(32), 
 course VARCHAR(32), 
 PRIMARY KEY(name, course));

INSERT INTO Courses VALUES('赤井', 'SQL入門');
INSERT INTO Courses VALUES('赤井', 'UNIX基礎');
INSERT INTO Courses VALUES('鈴木', 'SQL入門');
INSERT INTO Courses VALUES('工藤', 'SQL入門');
INSERT INTO Courses VALUES('工藤', 'Java中級');
INSERT INTO Courses VALUES('吉田', 'UNIX基礎');
INSERT INTO Courses VALUES('渡辺', 'SQL入門');

-- クロス表を求める水平展開：その1　外部結合の利用
SELECT C0.name,
       CASE WHEN C1.name IS NOT NULL THEN '○' ELSE NULL END AS "SQL入門",
       CASE WHEN C2.name IS NOT NULL THEN '○' ELSE NULL END AS "UNIX基礎",
       CASE WHEN C3.name IS NOT NULL THEN '○' ELSE NULL END AS "Java中級"
  FROM (SELECT DISTINCT name FROM Courses) C0 --このC0が表側になる
         LEFT OUTER JOIN
          (SELECT name FROM Courses WHERE course = 'SQL入門') C1
           ON C0.name = C1.name
             LEFT OUTER JOIN
              (SELECT name FROM Courses WHERE course = 'UNIX基礎') C2
                ON C0.name = C2.name
                  LEFT OUTER JOIN
                   (SELECT name FROM Courses WHERE course = 'Java中級') C3
                     ON C0.name = C3.name;


-- 水平展開：その2　スカラサブクエリの利用
SELECT C0.name,
       (SELECT '○'
          FROM Courses C1
         WHERE course = 'SQL入門'
           AND C1.name = C0.name) AS "SQL入門",
       (SELECT '○'
          FROM Courses C2
         WHERE course = 'UNIX基礎'
           AND C2.name = C0.name) AS "UNIX基礎",
       (SELECT '○'
          FROM Courses C3
         WHERE course = 'Java中級'
           AND C3.name = C0.name) AS "Java中級"
  FROM (SELECT DISTINCT name FROM Courses) C0; --このC0が表側になる


-- 水平展開：その3　CASE式を入れ子にする
SELECT name,
       CASE WHEN SUM(CASE WHEN course = 'SQL入門' THEN 1 ELSE NULL END) = 1
            THEN '○' ELSE NULL END AS "SQL入門",
       CASE WHEN SUM(CASE WHEN course = 'UNIX基礎' THEN 1 ELSE NULL END) = 1
            THEN '○' ELSE NULL END AS "UNIX基礎",
       CASE WHEN SUM(CASE WHEN course = 'Java中級' THEN 1 ELSE NULL END) = 1
            THEN '○' ELSE NULL END AS "Java中級"
  FROM Courses
 GROUP BY name;



/* 外部結合で行列変換　その2（列→行）：繰り返し項目を1 列にまとめる */
CREATE TABLE Personnel
 (employee   varchar(32), 
  child_1    varchar(32), 
  child_2    varchar(32), 
  child_3    varchar(32), 
  PRIMARY KEY(employee));

INSERT INTO Personnel VALUES('赤井', '一郎', '二郎', '三郎');
INSERT INTO Personnel VALUES('工藤', '春子', '夏子', NULL);
INSERT INTO Personnel VALUES('鈴木', '夏子', NULL,   NULL);
INSERT INTO Personnel VALUES('吉田', NULL,   NULL,   NULL);

-- 列から行への変換：UNION ALLの利用
SELECT employee, child_1 AS child FROM Personnel
UNION ALL
SELECT employee, child_2 AS child FROM Personnel
UNION ALL
SELECT employee, child_3 AS child FROM Personnel;

CREATE VIEW Children(child)
AS SELECT child_1 FROM Personnel
UNION
SELECT child_2 FROM Personnel
UNION
SELECT child_3 FROM Personnel;


-- 社員の子どもリストを得るSQL（子どものいない社員も出力する）
SELECT EMP.employee, Children.child
  FROM Personnel EMP
         LEFT OUTER JOIN Children
           ON Children.child IN (EMP.child_1, EMP.child_2, EMP.child_3);

/* クロス表で入れ子の表側を作る */
CREATE TABLE TblSex
(sex_cd   char(1), 
 sex varchar(5), 
 PRIMARY KEY(sex_cd));

CREATE TABLE TblAge 
(age_class char(1), 
 age_range varchar(30), 
 PRIMARY KEY(age_class));

CREATE TABLE TblPop 
(pref_name  varchar(30), 
 age_class  char(1), 
 sex_cd     char(1), 
 population integer, 
 PRIMARY KEY(pref_name, age_class,sex_cd));

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

-- 外部結合で入れ子の表側を作る：間違ったSQL
SELECT MASTER1.age_class AS age_class,
       MASTER2.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd,
               SUM(CASE WHEN pref_name IN ('青森', '秋田')
                        THEN population ELSE NULL END) AS pop_tohoku,
               SUM(CASE WHEN pref_name IN ('東京', '千葉')
                        THEN population ELSE NULL END) AS pop_kanto
          FROM TblPop
         GROUP BY age_class, sex_cd) DATA
           RIGHT OUTER JOIN TblAge MASTER1 --外部結合1：年齢階級マスタと結合
              ON MASTER1.age_class = DATA.age_class
           RIGHT OUTER JOIN TblSex MASTER2 --外部結合2：性別マスタと結合
              ON MASTER2.sex_cd = DATA.sex_cd;


-- 最初の外部結合で止めた場合：年齢階級「2」も結果に現われる
SELECT MASTER1.age_class AS age_class,
       DATA.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd,
               SUM(CASE WHEN pref_name IN ('青森', '秋田')
                        THEN population ELSE NULL END) AS pop_tohoku,
               SUM(CASE WHEN pref_name IN ('東京', '千葉')
                        THEN population ELSE NULL END) AS pop_kanto
          FROM TblPop
         GROUP BY age_class, sex_cd) DATA
          RIGHT OUTER JOIN TblAge MASTER1
             ON MASTER1.age_class = DATA.age_class;


-- 外部結合で入れ子の表側を作る：正しいSQL
SELECT MASTER.age_class AS age_class,
       MASTER.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd
          FROM TblAge CROSS JOIN TblSex ) MASTER --クロス結合でマスタ同士の直積を作る
            LEFT OUTER JOIN
             (SELECT age_class, sex_cd,
                     SUM(CASE WHEN pref_name IN ('青森', '秋田')
                              THEN population ELSE NULL END) AS pop_tohoku,
                     SUM(CASE WHEN pref_name IN ('東京', '千葉')
                              THEN population ELSE NULL END) AS pop_kanto
                FROM TblPop
               GROUP BY age_class, sex_cd) DATA
    ON MASTER.age_class = DATA.age_class
   AND MASTER.sex_cd = DATA.sex_cd;


/* 掛け算としての結合 */
CREATE TABLE Items
 (item_no INTEGER PRIMARY KEY,
  item    VARCHAR(32) NOT NULL);

INSERT INTO Items VALUES(10, 'FD');
INSERT INTO Items VALUES(20, 'CD-R');
INSERT INTO Items VALUES(30, 'MO');
INSERT INTO Items VALUES(40, 'DVD');

CREATE TABLE SalesHistory
 (sale_date DATE NOT NULL,
  item_no   INTEGER NOT NULL,
  quantity  INTEGER NOT NULL,
  PRIMARY KEY(sale_date, item_no));

INSERT INTO SalesHistory VALUES('2018-10-01',  10,  4);
INSERT INTO SalesHistory VALUES('2018-10-01',  20, 10);
INSERT INTO SalesHistory VALUES('2018-10-01',  30,  3);
INSERT INTO SalesHistory VALUES('2018-10-03',  10, 32);
INSERT INTO SalesHistory VALUES('2018-10-03',  30, 12);
INSERT INTO SalesHistory VALUES('2018-10-04',  20, 22);
INSERT INTO SalesHistory VALUES('2018-10-04',  30,  7);

-- 答え：その1　結合の前に集約することで、1対1の関係を作る
SELECT I.item_no, SH.total_qty
  FROM Items I LEFT OUTER JOIN
                (SELECT item_no, SUM(quantity) AS total_qty
                   FROM SalesHistory
                  GROUP BY item_no) SH
    ON I.item_no = SH.item_no;

-- 答え：その2　集約の前に1対多の結合を行なう
SELECT I.item_no, SUM(SH.quantity) AS total_qty
  FROM Items I LEFT OUTER JOIN SalesHistory SH
    ON I.item_no = SH.item_no --1対多の結合
 GROUP BY I.item_no;


/* 完全外部結合 */
CREATE TABLE Class_A
(id char(1), 
 name varchar(30), 
 PRIMARY KEY(id));

CREATE TABLE Class_B
(id   char(1), 
 name varchar(30), 
 PRIMARY KEY(id));

INSERT INTO Class_A (id, name) VALUES('1', '田中');
INSERT INTO Class_A (id, name) VALUES('2', '鈴木');
INSERT INTO Class_A (id, name) VALUES('3', '伊集院');

INSERT INTO Class_B (id, name) VALUES('1', '田中');
INSERT INTO Class_B (id, name) VALUES('2', '鈴木');
INSERT INTO Class_B (id, name) VALUES('4', '西園寺');


-- 完全外部結合は情報を「完全」に保存する
SELECT COALESCE(A.id, B.id) AS id,
       A.name AS A_name,
       B.name AS B_name
  FROM Class_A A FULL OUTER JOIN Class_B B
    ON A.id = B.id;


-- 完全外部結合が使えない環境での代替方法
SELECT A.id AS id, A.name, B.name
  FROM Class_A A LEFT OUTER JOIN Class_B B
    ON A.id = B.id
UNION
SELECT B.id AS id, A.name, B.name
  FROM Class_A A RIGHT OUTER JOIN Class_B B
    ON A.id = B.id;


SELECT A.id AS id, A.name AS A_name
  FROM Class_A A LEFT OUTER JOIN Class_B B
    ON A.id = B.id
 WHERE B.name IS NULL;

SELECT B.id AS id, B.name AS B_name
  FROM Class_A A RIGHT OUTER JOIN Class_B B
    ON A.id = B.id
 WHERE A.name IS NULL;

SELECT COALESCE(A.id, B.id) AS id,
       COALESCE(A.name , B.name ) AS name
  FROM Class_A A FULL OUTER JOIN Class_B B
    ON A.id = B.id
 WHERE A.name IS NULL
    OR B.name IS NULL;

-- 外部結合で関係除算：差集合の応用
SELECT DISTINCT shop
  FROM ShopItems SI1
 WHERE NOT EXISTS
        (SELECT I.item
           FROM Items I LEFT OUTER JOIN ShopItems SI2
             ON I.item = SI2.item
            AND SI1.shop = SI2.shop
          WHERE SI2.item IS NULL) ;


