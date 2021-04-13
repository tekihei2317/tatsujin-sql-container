

演習問題1-①：複数列の最大値

CREATE TABLE Greatests
(key CHAR(1) PRIMARY KEY,
 x   INTEGER NOT NULL,
 y   INTEGER NOT NULL,
 z   INTEGER NOT NULL);

INSERT INTO Greatests VALUES('A', 1, 2, 3);
INSERT INTO Greatests VALUES('B', 5, 5, 2);
INSERT INTO Greatests VALUES('C', 4, 7, 1);
INSERT INTO Greatests VALUES('D', 3, 3, 8);


-- xとyの最大値
SELECT key,
       CASE WHEN x < y THEN y
            ELSE x END AS greatest
  FROM Greatests;


-- xとyとzの最大値
SELECT key,
       CASE WHEN CASE WHEN x < y THEN y ELSE x END < z
                      THEN z
                      ELSE CASE WHEN x < y THEN y ELSE x END
        END AS greatest
FROM Greatests;


-- Oracle、MySQL、PostgreSQL
SELECT key, GREATEST(GREATEST(x,y), z) AS greatest
  FROM Greatests;



演習問題1-②：合計と再掲を表頭に出力する行列変換


CREATE TABLE PopTbl2
(pref_name VARCHAR(32),
 sex CHAR(1) NOT NULL,
 population INTEGER NOT NULL,
    PRIMARY KEY(pref_name, sex));

INSERT INTO PopTbl2 VALUES('徳島', '1',	60 );
INSERT INTO PopTbl2 VALUES('徳島', '2',	40 );
INSERT INTO PopTbl2 VALUES('香川', '1',	100);
INSERT INTO PopTbl2 VALUES('香川', '2',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '1',	100);
INSERT INTO PopTbl2 VALUES('愛媛', '2',	50 );
INSERT INTO PopTbl2 VALUES('高知', '1',	100);
INSERT INTO PopTbl2 VALUES('高知', '2',	100);
INSERT INTO PopTbl2 VALUES('福岡', '1',	100);
INSERT INTO PopTbl2 VALUES('福岡', '2',	200);
INSERT INTO PopTbl2 VALUES('佐賀', '1',	20 );
INSERT INTO PopTbl2 VALUES('佐賀', '2',	80 );
INSERT INTO PopTbl2 VALUES('長崎', '1',	125);
INSERT INTO PopTbl2 VALUES('長崎', '2',	125);
INSERT INTO PopTbl2 VALUES('東京', '1',	250);
INSERT INTO PopTbl2 VALUES('東京', '2',	150);

SELECT sex,
       SUM(population) AS total,
       SUM(CASE WHEN pref_name = '徳島' 
                THEN population ELSE 0 END) AS tokushima,
       SUM(CASE WHEN pref_name = '香川' 
                THEN population ELSE 0 END) AS kagawa,
       SUM(CASE WHEN pref_name = '愛媛' 
                THEN population ELSE 0 END) AS ehime,
       SUM(CASE WHEN pref_name = '高知' 
                THEN population ELSE 0 END) AS kouchi,
       SUM(CASE WHEN pref_name IN ('徳島', '香川', '愛媛', '高知')
                THEN population ELSE 0 END) AS saikei
  FROM PopTbl2
 GROUP BY sex;



演習問題1-③：ORDER BYでソート列を作る

SELECT key
  FROM Greatests
 ORDER BY CASE key
          WHEN 'B' THEN 1
          WHEN 'A' THEN 2
          WHEN 'D' THEN 3
          WHEN 'C' THEN 4
          ELSE NULL END;


SELECT key,
       CASE key
       WHEN 'B' THEN 1
       WHEN 'A' THEN 2
       WHEN 'D' THEN 3
       WHEN 'C' THEN 4
       ELSE NULL END AS sort_col
  FROM Greatests
 ORDER BY sort_col;




演習問題2-①：ウィンドウ関数の結果予想　その1


CREATE TABLE ServerLoadSample
(server       CHAR(4) NOT NULL,
 sample_date  DATE    NOT NULL,
 load_val      INTEGER NOT NULL,
    PRIMARY KEY (server, sample_date));

INSERT INTO ServerLoadSample VALUES('A' , '2018-02-01',  1024);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-02',  2366);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-05',  2366);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-07',   985);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-08',   780);
INSERT INTO ServerLoadSample VALUES('A' , '2018-02-12',  1000);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-01',    54);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-02', 39008);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-03',  2900);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-04',   556);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-05', 12600);
INSERT INTO ServerLoadSample VALUES('B' , '2018-02-06',  7309);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-01',  1000);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-07',  2000);
INSERT INTO ServerLoadSample VALUES('C' , '2018-02-16',   500);

SELECT server, sample_date,
       SUM(load_val) OVER () AS sum_load
  FROM ServerLoadSample;


演習問題2-②：ウィンドウ関数の結果予想 その2

SELECT server, sample_date,
       SUM(load_val) OVER (PARTITION BY server) AS sum_load
  FROM ServerLoadSample;



演習問題3-①：重複組み合わせ

SELECT P1.name AS name_1, P2.name AS name_2
  FROM Products P1 INNER JOIN Products P2
    ON P1.name >= P2.name;



演習問題3-②：ウィンドウ関数で重複削除

DROP TABLE Products;
CREATE TABLE Products
(name VARCHAR(16) NOT NULL,
 price INTEGER NOT NULL);


--重複するレコード
INSERT INTO Products VALUES('りんご',	50);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('バナナ',	80);

-- (name, price)のパーティションに一意な連番を振ったテーブルを作成
CREATE TABLE Products_NoRedundant
AS
SELECT ROW_NUMBER()
         OVER(PARTITION BY name, price
                  ORDER BY name) AS row_num,
       name, price
  FROM Products;


-- 連番が1以外のレコードを削除
DELETE FROM Products_NoRedundant
  WHERE row_num > 1;



DELETE FROM
        (SELECT ROW_NUMBER()
                  OVER(PARTITION BY name, price
                           ORDER BY name) AS row_num
          FROM Products)
 WHERE row_num > 1;



演習問題5-①：配列テーブル行持ちの場合

/* 5-1：配列テーブル——行持ちの場合 */
CREATE TABLE ArrayTbl2
 (key   CHAR(1) NOT NULL,
    i   INTEGER NOT NULL,
  val   INTEGER,
  PRIMARY KEY (key, i));

/* AはオールNULL、Bは一つだけ非NULL、Cはオール非NULL */
INSERT INTO ArrayTbl2 VALUES('A', 1, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 2, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 3, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 4, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 5, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 6, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 7, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 8, NULL);
INSERT INTO ArrayTbl2 VALUES('A', 9, NULL);
INSERT INTO ArrayTbl2 VALUES('A',10, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 1, 3);
INSERT INTO ArrayTbl2 VALUES('B', 2, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 3, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 4, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 5, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 6, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 7, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 8, NULL);
INSERT INTO ArrayTbl2 VALUES('B', 9, NULL);
INSERT INTO ArrayTbl2 VALUES('B',10, NULL);
INSERT INTO ArrayTbl2 VALUES('C', 1, 1);
INSERT INTO ArrayTbl2 VALUES('C', 2, 1);
INSERT INTO ArrayTbl2 VALUES('C', 3, 1);
INSERT INTO ArrayTbl2 VALUES('C', 4, 1);
INSERT INTO ArrayTbl2 VALUES('C', 5, 1);
INSERT INTO ArrayTbl2 VALUES('C', 6, 1);
INSERT INTO ArrayTbl2 VALUES('C', 7, 1);
INSERT INTO ArrayTbl2 VALUES('C', 8, 1);
INSERT INTO ArrayTbl2 VALUES('C', 9, 1);
INSERT INTO ArrayTbl2 VALUES('C',10, 1);

-- 間違った答え
SELECT DISTINCT key
  FROM ArrayTbl2 AT1
 WHERE NOT EXISTS
        (SELECT *
           FROM ArrayTbl2 AT2
          WHERE AT1.key = AT2.key
            AND AT2.val <> 1);

-- 正しい答え
SELECT DISTINCT key
  FROM ArrayTbl2 A1
 WHERE NOT EXISTS
       (SELECT *
          FROM ArrayTbl2 A2
         WHERE A1.key = A2.key
           AND (A2.val <> 1 OR A2.val IS NULL));

-- 別解1：ALL述語の利用
SELECT DISTINCT key
  FROM ArrayTbl2 A1
 WHERE 1 = ALL
            (SELECT val
               FROM ArrayTbl2 A2
              WHERE A1.key = A2.key);


-- 別解2：HAVING句の利用
SELECT key
  FROM ArrayTbl2
 GROUP BY key
HAVING SUM(CASE WHEN val = 1 THEN 1 ELSE 0 END) = 10;


-- 別解その3：HAVING句で極値関数を利用する
SELECT key
  FROM ArrayTbl2
 GROUP BY key
HAVING MAX(val) = 1
   AND MIN(val) = 1;


演習問題5-②：ALL述語による全称量化


-- 工程1 番まで完了のプロジェクトを選択：ALL述語による解答
SELECT *
  FROM Projects P1
 WHERE '○' = ALL
                (SELECT CASE WHEN step_nbr <= 1 
                              AND status = '完了' 
                             THEN '○'
                             WHEN step_nbr > 1 
                              AND status = '待機' 
                             THEN '○'
                        ELSE '×' END
                   FROM Projects P2
                  WHERE P1.project_id = P2. project_id);


演習問題5-③：素数を求める

CREATE TABLE Digits
 (digit INTEGER PRIMARY KEY); 

INSERT INTO Digits VALUES (0);
INSERT INTO Digits VALUES (1);
INSERT INTO Digits VALUES (2);
INSERT INTO Digits VALUES (3);
INSERT INTO Digits VALUES (4);
INSERT INTO Digits VALUES (5);
INSERT INTO Digits VALUES (6);
INSERT INTO Digits VALUES (7);
INSERT INTO Digits VALUES (8);
INSERT INTO Digits VALUES (9);

DROP TABLE Numbers;
CREATE TABLE Numbers
AS
SELECT D1.digit + (D2.digit * 10) AS num
  FROM Digits D1 CROSS JOIN Digits D2
 WHERE D1.digit + (D2.digit * 10) BETWEEN 1 AND 100;

-- 答え： NOT EXISTSで全称量化を表現
SELECT num AS prime
  FROM Numbers Dividend
 WHERE num > 1
   AND NOT EXISTS
        (SELECT *
           FROM Numbers Divisor
          WHERE Divisor.num <= Dividend.num / 2
            AND Divisor.num <> 1 --1 は約数に含まない
            AND MOD(Dividend.num, Divisor.num) = 0)
 ORDER BY prime;




演習問題6-①：歯抜けを探す——改良版

SELECT ' 歯抜けあり' AS gap
  FROM SeqTbl
HAVING COUNT(*) <> MAX(seq)
UNION ALL
SELECT ' 歯抜けなし' AS gap
  FROM SeqTbl
HAVING COUNT(*) = MAX(seq);


SELECT CASE WHEN COUNT(*) <> MAX(seq)
            THEN '歯抜けあり'
            ELSE '歯抜けなし' END AS gap
  FROM SeqTbl;



演習問題6-②：特性関数の練習

-- 全員が9月中に提出済みの学部を選択する　その1：BETWEEN述語の利用
SELECT dpt
  FROM Students
 GROUP BY dpt
HAVING COUNT(*) = SUM(CASE WHEN sbmt_date BETWEEN '2018-09-01' 
                                              AND '2018-09-30'
                           THEN 1 ELSE 0 END);


SELECT dpt
  FROM Students
 GROUP BY dpt
HAVING COUNT(*) = SUM(CASE WHEN EXTRACT (YEAR FROM sbmt_date) = 2018
                            AND EXTRACT (MONTH FROM sbmt_date) = 09
                           THEN 1 ELSE 0 END);


演習問題6-③：関係除算の改良

SELECT SI.shop,
       COUNT(SI.item) AS my_item_cnt,
       (SELECT COUNT(item) FROM Items) - COUNT(SI.item) AS diff_cnt
  FROM ShopItems SI INNER JOIN Items I
    ON SI.item = I.item
 GROUP BY SI.shop;



演習問題7-①：移動平均


-- 相関サブクエリで移動平均を求める
SELECT prc_date, A1.prc_amt,
       (SELECT AVG(prc_amt)
          FROM Accounts A2
         WHERE A1.prc_date >= A2.prc_date
           AND (SELECT COUNT(*)
                  FROM Accounts A3
                 WHERE A3.prc_date
                         BETWEEN A2.prc_date 
                             AND A1.prc_date ) <= 3 ) AS mvg_sum
  FROM Accounts A1
ORDER BY prc_date;

-- 非グループ化して表示
SELECT A1.prc_date AS A1_date,
       A2.prc_date AS A2_date,
       A2.prc_amt AS amt
  FROM Accounts A1, Accounts A2
 WHERE A1.prc_date >= A2.prc_date
   AND (SELECT COUNT(*)
          FROM Accounts A3
         WHERE A3.prc_date BETWEEN A2.prc_date 
                               AND A1.prc_date ) <= 3
 ORDER BY A1_date, A2_date;


演習問題7-②：移動平均　その2

-- ウィンドウ関数
SELECT prc_date, prc_amt,
       CASE WHEN cnt < 3 THEN NULL
            ELSE mvg_avg END AS mvg_avg
  FROM (SELECT prc_date, prc_amt,
               AVG(prc_amt)
                 OVER(ORDER BY prc_date
                       ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) mvg_avg,
               COUNT(*)
                 OVER (ORDER BY prc_date
                        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS cnt
          FROM Accounts) TMP;


-- 相関サブクエリ
SELECT prc_date, A1.prc_amt,
       (SELECT AVG(prc_amt)
          FROM Accounts A2
         WHERE A1.prc_date >= A2.prc_date
           AND (SELECT COUNT(*)
                  FROM Accounts A3
                 WHERE A3.prc_date
                         BETWEEN A2.prc_date AND A1.prc_date ) <= 3
                HAVING COUNT(*) =3) AS mvg_sum --3 行未満は非表示
  FROM Accounts A1
 ORDER BY prc_date;



演習問題8-①：結合が先か、集約が先か？


-- インラインビューを1つ削除した修正版
SELECT MASTER.age_class AS age_class,
       MASTER.sex_cd AS sex_cd,
       SUM(CASE WHEN pref_name IN ('青森', '秋田')
                THEN population ELSE NULL END) AS pop_tohoku,
       SUM(CASE WHEN pref_name IN ('東京', '千葉')
                THEN population ELSE NULL END) AS pop_kanto
  FROM (SELECT age_class, sex_cd
          FROM TblAge CROSS JOIN TblSex) MASTER
                 LEFT OUTER JOIN TblPop DATA
            ON MASTER.age_class = DATA.age_class
           AND MASTER.sex_cd = DATA.sex_cd
 GROUP BY MASTER.age_class, MASTER.sex_cd;


演習問題8-②：子どもの数にご用心


SELECT EMP.employee, COUNT(*) AS child_cnt
  FROM Personnel EMP
         LEFT OUTER JOIN Children
    ON CHILDREN.child IN (EMP.child_1, EMP.child_2, EMP.child_3)
 GROUP BY EMP.employee;


SELECT EMP.employee, COUNT(CHILDREN.child) AS child_cnt
  FROM Personnel EMP
         LEFT OUTER JOIN Children
    ON CHILDREN.child IN (EMP.child_1, EMP.child_2, EMP.child_3)
 GROUP BY EMP.employee;


演習問題8-③：完全外部結合とMERGE文

MERGE INTO Class_A A
  USING (SELECT *
           FROM Class_B ) B
             ON (A.id = B.id)
  WHEN MATCHED THEN
       UPDATE SET A.name = B.name
  WHEN NOT MATCHED THEN
       INSERT (id, name)
       VALUES (B.id, B.name);



演習問題9-①：UNIONだけを使うコンペアの改良


SELECT CASE WHEN COUNT(*) = (SELECT COUNT(*) FROM tbl_A )
             AND COUNT(*) = (SELECT COUNT(*) FROM tbl_B )
            THEN '等しい'
            ELSE '異なる' END AS result
  FROM ( SELECT *
           FROM tbl_A
         UNION
         SELECT *
           FROM tbl_B ) TMP;


演習問題9-②：厳密な関係除算

SELECT DISTINCT emp
  FROM EmpSkills ES1
 WHERE NOT EXISTS
        (SELECT skill
           FROM Skills
         EXCEPT
         SELECT skill
           FROM EmpSkills ES2
          WHERE ES1.emp = ES2.emp)
   AND NOT EXISTS
        (SELECT skill
           FROM EmpSkills ES3
          WHERE ES1.emp = ES3.emp
         EXCEPT
         SELECT skill
           FROM Skills );


SELECT emp
  FROM EmpSkills ES1
 WHERE NOT EXISTS
        (SELECT skill
           FROM Skills
         EXCEPT
         SELECT skill
           FROM EmpSkills ES2
          WHERE ES1.emp = ES2.emp)
 GROUP BY emp
HAVING COUNT(*) = (SELECT COUNT(*) FROM Skills);


演習問題10-①：欠番をすべて求める—— NOT EXISTSと外部結合


-- NOT EXISTS バージョン
SELECT seq
  FROM Sequence N
 WHERE seq BETWEEN 1 AND 12
   AND NOT EXISTS
        (SELECT *
           FROM SeqTbl S
          WHERE N.seq = S.seq );

SELECT N.seq
  FROM Sequence N LEFT OUTER JOIN SeqTbl S
    ON N.seq = S.seq
 WHERE N.seq BETWEEN 1 AND 12
   AND S.seq IS NULL;

演習問題10-②：シーケンスを求める——集合指向的発想

SELECT S1.seat AS start_seat, ' ～ ' , S2.seat AS end_seat
  FROM Seats S1, Seats S2, Seats S3
 WHERE S2.seat = S1.seat + (:head_cnt - 1)
   AND S3.seat BETWEEN S1.seat AND S2.seat
 GROUP BY S1.seat, S2.seat
HAVING COUNT(*) = SUM(CASE WHEN S3.status = '空' THEN 1 ELSE 0 END);


-- 行に折り返しがある場合
SELECT S1.seat AS start_seat, ' ～ ' , S2.seat AS end_seat
  FROM Seats2 S1, Seats2 S2, Seats2 S3
 WHERE S2.seat = S1.seat + (:head_cnt -1)
   AND S3.seat BETWEEN S1.seat AND S2.seat
 GROUP BY S1.seat, S2.seat
HAVING COUNT(*) = SUM(CASE WHEN S3.status = '空'
                            AND S3.line_id = S1.line_id
                           THEN 1 ELSE 0 END);
