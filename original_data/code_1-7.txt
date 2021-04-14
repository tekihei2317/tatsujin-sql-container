-- 成長・後退・現状維持
CREATE TABLE Sales
(year INTEGER NOT NULL , 
 sale INTEGER NOT NULL ,
 PRIMARY KEY (year));

INSERT INTO Sales VALUES (1990, 50);
INSERT INTO Sales VALUES (1991, 51);
INSERT INTO Sales VALUES (1992, 52);
INSERT INTO Sales VALUES (1993, 52);
INSERT INTO Sales VALUES (1994, 50);
INSERT INTO Sales VALUES (1995, 50);
INSERT INTO Sales VALUES (1996, 49);
INSERT INTO Sales VALUES (1997, 55);

-- 時系列に歯抜けがある場合：直近と比較
CREATE TABLE Sales2
(year INTEGER NOT NULL , 
 sale INTEGER NOT NULL , 
 PRIMARY KEY (year));

INSERT INTO Sales2 VALUES (1990, 50);
INSERT INTO Sales2 VALUES (1992, 50);
INSERT INTO Sales2 VALUES (1993, 52);
INSERT INTO Sales2 VALUES (1994, 55);
INSERT INTO Sales2 VALUES (1997, 55);


-- 前年と年商が同じ年度を求める：その1　相関サブクエリの利用
SELECT year,sale
  FROM Sales S1
 WHERE sale = (SELECT sale
                 FROM Sales S2
                WHERE S2.year = S1.year - 1)
 ORDER BY year;


-- 前年と年商が同じ年度を求める：その2　ウィンドウ関数の利用
SELECT year, current_sale
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                               RANGE BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales) TMP
 WHERE current_sale = pre_sale
 ORDER BY year;

SELECT year,
       sale AS current_sale,
       SUM(sale) OVER (ORDER BY year
                       RANGE BETWEEN 1 PRECEDING
                                 AND 1 PRECEDING) AS pre_sale
  FROM Sales;


-- 成長、後退、現状維持を一度に求める：その1　相関サブクエリの利用
SELECT year, current_sale AS sale,
       CASE WHEN current_sale = pre_sale
              THEN '→'
            WHEN current_sale > pre_sale
              THEN '↑'
            WHEN current_sale < pre_sale
              THEN '↓'
            ELSE '-' END AS var
  FROM (SELECT year,
               sale AS current_sale,
               (SELECT sale
                  FROM Sales S2
                 WHERE S2.year = S1.year - 1) AS pre_sale
          FROM Sales S1) TMP
 ORDER BY year;


-- 成長、後退、現状維持を一度に求める：その2　ウィンドウ関数の利用
SELECT year, current_sale AS sale,
       CASE WHEN current_sale = pre_sale
             THEN '→'
            WHEN current_sale > pre_sale
             THEN '↑'
            WHEN current_sale < pre_sale
             THEN '↓'
            ELSE '-' END AS var
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                               RANGE BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales) TMP
 ORDER BY year;




-- 直近の年と同じ年商の年を選択する：その1　相関サブクエリ
SELECT year, sale
  FROM Sales2 S1
 WHERE sale =
         (SELECT sale
            FROM Sales2 S2
           WHERE S2.year =
                  (SELECT MAX(year) -- 条件2：条件1を満たす年度の中で最大
                     FROM Sales2 S3
                    WHERE S1.year > S3.year)) -- 条件1：自分より過去である
 ORDER BY year;


-- 直近の年と同じ年商の年を選択する：その2　ウィンドウ関数
SELECT year, current_sale
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                                ROWS BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales2) TMP
         WHERE current_sale = pre_sale
 ORDER BY year;




-- オーバーラップする期間を調べる
CREATE TABLE Reservations
(reserver    VARCHAR(30) PRIMARY KEY,
 start_date  DATE  NOT NULL,
 end_date    DATE  NOT NULL);

INSERT INTO Reservations VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('山本', '2018-11-03', '2018-11-04');
INSERT INTO Reservations VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('水谷', '2018-11-06', '2018-11-06');

--山本氏の投宿日が4日の場合
DELETE FROM Reservations WHERE reserver = '山本';
INSERT INTO Reservations VALUES('山本', '2018-11-04', '2018-11-04');


-- オーバーラップする期間を求める  その1：相関サブクエリの利用
SELECT reserver, start_date, end_date
  FROM Reservations R1
 WHERE EXISTS
        (SELECT *
           FROM Reservations R2
          WHERE R1.reserver <> R2.reserver -- 自分以外の客と比較する
            AND ( R1.start_date BETWEEN R2.start_date AND R2.end_date
                   -- 条件(1)：開始日が他の期間内にある
               OR R1.end_date BETWEEN R2.start_date AND R2.end_date));
                   -- 条件(2)：終了日が他の期間内にある


-- オーバーラップする期間を求める  その2：ウィンドウ関数の利用
SELECT reserver, next_reserver
  FROM (SELECT reserver,
               start_date,
               end_date,
               MAX(start_date) OVER (ORDER BY start_date
                                      ROWS BETWEEN 1 FOLLOWING 
                                               AND 1 FOLLOWING) AS next_start_date,
               MAX(reserver)   OVER (ORDER BY start_date
                                      ROWS BETWEEN 1 FOLLOWING 
                                               AND 1 FOLLOWING) AS next_reserver
          FROM Reservations) TMP
 WHERE next_start_date BETWEEN start_date AND end_date;



--山本・内田・水谷の3人が重複
DELETE FROM Reservations;
INSERT INTO Reservations VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('山本', '2018-11-03', '2018-11-04');
INSERT INTO Reservations VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('水谷', '2018-11-04', '2018-11-06');


--山本氏を「日帰り」で登録(相関サブクエリの結果から内田氏が消える)
DELETE FROM Reservations;
INSERT INTO Reservations VALUES('木村', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('荒木', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('堀',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('山本', '2018-11-04', '2018-11-04');
INSERT INTO Reservations VALUES('内田', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('水谷', '2018-11-06', '2018-11-06');


--演習問題：1-6
CREATE TABLE Accounts
(prc_date DATE NOT NULL , 
 prc_amt  INTEGER NOT NULL , 
 PRIMARY KEY (prc_date)) ;

DELETE FROM Accounts;
INSERT INTO Accounts VALUES ('2018-10-26',  12000 );
INSERT INTO Accounts VALUES ('2018-10-28',   2500 );
INSERT INTO Accounts VALUES ('2018-10-31', -15000 );
INSERT INTO Accounts VALUES ('2018-11-03',  34000 );
INSERT INTO Accounts VALUES ('2018-11-04',  -5000 );
INSERT INTO Accounts VALUES ('2018-11-06',   7200 );
INSERT INTO Accounts VALUES ('2018-11-11',  11000 );

