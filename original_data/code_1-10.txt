-- 連番を作ろう
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

-- 連番を求める：その1　0〜99
SELECT D1.digit + (D2.digit * 10) AS seq
  FROM Digits D1 CROSS JOIN Digits D2
 ORDER BY seq;


-- 連番を求める：その2　1〜542を求める
SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) AS seq
  FROM Digits D1 CROSS JOIN Digits D2
         CROSS JOIN Digits D3
 WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100)
         BETWEEN 1 AND 542 ORDER BY seq;

--欠番を全部求める
CREATE TABLE SeqTbl
 (seq INTEGER PRIMARY KEY); 

INSERT INTO SeqTbl VALUES (1);
INSERT INTO SeqTbl VALUES (2);
INSERT INTO SeqTbl VALUES (4);
INSERT INTO SeqTbl VALUES (5);
INSERT INTO SeqTbl VALUES (6);
INSERT INTO SeqTbl VALUES (7);
INSERT INTO SeqTbl VALUES (8);
INSERT INTO SeqTbl VALUES (11);
INSERT INTO SeqTbl VALUES (12);

-- シーケンスビューを作る（0〜999までをカバー）
CREATE VIEW Sequence (seq) AS
SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100)
  FROM Digits D1
         CROSS JOIN Digits D2
           CROSS JOIN Digits D3;

-- シーケンスビューから1〜100まで取得
SELECT seq
  FROM Sequence
 WHERE seq BETWEEN 1 AND 100
 ORDER BY seq;


-- EXCEPTバージョン
SELECT seq
  FROM Sequence
 WHERE seq BETWEEN 1 AND 12
EXCEPT
SELECT seq
  FROM SeqTbl;

-- NOT INバージョン
SELECT seq
  FROM Sequence
 WHERE seq BETWEEN 1 AND 12
   AND seq NOT IN (SELECT seq FROM SeqTbl);

-- 連番の範囲を動的に決定するクエリ
SELECT seq
  FROM Sequence
 WHERE seq BETWEEN (SELECT MIN(seq) FROM SeqTbl)
   AND (SELECT MAX(seq) FROM SeqTbl)
EXCEPT SELECT seq FROM SeqTbl;

-- 3人なんですけど、座れますか？
CREATE TABLE Seats
(seat   INTEGER NOT NULL  PRIMARY KEY,
 status CHAR(2) NOT NULL
 CHECK (status IN ('空', '占')) ); 

INSERT INTO Seats VALUES (1,  '占');
INSERT INTO Seats VALUES (2,  '占');
INSERT INTO Seats VALUES (3,  '空');
INSERT INTO Seats VALUES (4,  '空');
INSERT INTO Seats VALUES (5,  '空');
INSERT INTO Seats VALUES (6,  '占');
INSERT INTO Seats VALUES (7,  '空');
INSERT INTO Seats VALUES (8,  '空');
INSERT INTO Seats VALUES (9,  '空');
INSERT INTO Seats VALUES (10, '空');
INSERT INTO Seats VALUES (11, '空');
INSERT INTO Seats VALUES (12, '占');
INSERT INTO Seats VALUES (13, '占');
INSERT INTO Seats VALUES (14, '空');
INSERT INTO Seats VALUES (15, '空');


-- 人数分の空席を探す：その1　NOT EXISTS
SELECT S1.seat AS start_seat, '〜' , S2.seat AS end_seat
  FROM Seats S1, Seats S2
 WHERE S2.seat = S1.seat + (:head_cnt -1) --始点と終点を決める
   AND NOT EXISTS
        (SELECT *
           FROM Seats S3
          WHERE S3.seat BETWEEN S1.seat AND S2.seat
            AND S3.status <> '空' );


-- 折り返しも考慮
CREATE TABLE Seats2
 ( seat   INTEGER NOT NULL  PRIMARY KEY,
   line_id CHAR(1) NOT NULL,
   status CHAR(2) NOT NULL
     CHECK (status IN ('空', '占')) ); 

INSERT INTO Seats2 VALUES (1, 'A', '占');
INSERT INTO Seats2 VALUES (2, 'A', '占');
INSERT INTO Seats2 VALUES (3, 'A', '空');
INSERT INTO Seats2 VALUES (4, 'A', '空');
INSERT INTO Seats2 VALUES (5, 'A', '空');
INSERT INTO Seats2 VALUES (6, 'B', '占');
INSERT INTO Seats2 VALUES (7, 'B', '占');
INSERT INTO Seats2 VALUES (8, 'B', '空');
INSERT INTO Seats2 VALUES (9, 'B', '空');
INSERT INTO Seats2 VALUES (10,'B', '空');
INSERT INTO Seats2 VALUES (11,'C', '空');
INSERT INTO Seats2 VALUES (12,'C', '空');
INSERT INTO Seats2 VALUES (13,'C', '空');
INSERT INTO Seats2 VALUES (14,'C', '占');
INSERT INTO Seats2 VALUES (15,'C', '空');


-- 人数分の空席を探す：その2　ウィンドウ関数
SELECT seat, '〜', seat + (:head_cnt -1)
  FROM (SELECT seat,
               MAX(seat)
                 OVER(ORDER BY seat
                       ROWS BETWEEN (:head_cnt -1) FOLLOWING
                                AND (:head_cnt -1) FOLLOWING ) AS end_seat
          FROM Seats
         WHERE status = '空') TMP
 WHERE end_seat - seat = (:head_cnt -1);


-- 人数分の空席を探す：ラインの折り返しも考慮する　NOT EXISTS
SELECT S1.seat AS start_seat, '〜' , S2.seat AS end_seat
  FROM Seats2 S1, Seats2 S2
 WHERE S2.seat = S1.seat + (:head_cnt -1) --始点と終点を決める
   AND NOT EXISTS
        (SELECT *
           FROM Seats2 S3
          WHERE S3.seat BETWEEN S1.seat AND S2.seat
            AND ( S3.status <> '空' OR S3.line_id <> S1.line_id));

-- 人数分の空席を探す：行の折り返しも考慮する　ウィンドウ関数
SELECT seat, '〜', seat + (:head_cnt - 1)
  FROM (SELECT seat,
               MAX(seat)
                 OVER(PARTITION BY line_id
                          ORDER BY seat
                           ROWS BETWEEN (:head_cnt - 1) FOLLOWING
                                    AND (:head_cnt - 1) FOLLOWING ) AS end_seat
          FROM Seats2
         WHERE status = '空') TMP
  WHERE end_seat - seat = (:head_cnt - 1);



-- 単調増加と単調減少
CREATE TABLE MyStock
 (deal_date  DATE PRIMARY KEY,
  price      INTEGER ); 

INSERT INTO MyStock VALUES ('2018-01-06', 1000);
INSERT INTO MyStock VALUES ('2018-01-08', 1050);
INSERT INTO MyStock VALUES ('2018-01-09', 1050);
INSERT INTO MyStock VALUES ('2018-01-12', 900);
INSERT INTO MyStock VALUES ('2018-01-13', 880);
INSERT INTO MyStock VALUES ('2018-01-14', 870);
INSERT INTO MyStock VALUES ('2018-01-16', 920);
INSERT INTO MyStock VALUES ('2018-01-17', 1000);
INSERT INTO MyStock VALUES ('2018-01-18', 2000);

-- 前回取引から上昇したかどうかを判断する
SELECT deal_date, price,
       CASE SIGN(price - MAX(price)
                           OVER(ORDER BY deal_date
                                 ROWS BETWEEN 1 PRECEDING
                                          AND 1 PRECEDING))
       WHEN 1 THEN 'up'
       WHEN 0 THEN 'stay'
       WHEN -1 THEN 'down' ELSE NULL END AS diff
  FROM MyStock;


CREATE VIEW MyStockUpSeq(deal_date, price, row_num)
AS
SELECT deal_date, price, row_num
  FROM (SELECT deal_date, price,
               CASE SIGN(price - MAX(price)
                                   OVER(ORDER BY deal_date
                                         ROWS BETWEEN 1 PRECEDING
                                                  AND 1 PRECEDING))
               WHEN 1 THEN 'up'
               WHEN 0 THEN 'stay'
               WHEN -1 THEN 'down' ELSE NULL END AS diff,
               ROW_NUMBER() OVER(ORDER BY deal_date) AS row_num
          FROM MyStock) TMP
  WHERE diff = 'up';


-- 自己結合でシーケンスをグループ化
SELECT MIN(deal_date) AS start_date,
       '〜',
       MAX(deal_date) AS end_date
  FROM (SELECT M1.deal_date,
               COUNT(M2.row_num) - MIN(M1.row_num) AS gap
          FROM MyStockUpSeq M1 INNER JOIN MyStockUpSeq M2
            ON M2.row_num <= M1.row_num
         GROUP BY M1.deal_date) TMP
 GROUP BY gap;


SELECT M1.deal_date,
       COUNT(M2.row_num) cnt,
       MIN(M1.row_num) min_row_num,
       COUNT(M2.row_num) - MIN(M1.row_num) AS gap
  FROM MyStockUpSeq M1 INNER JOIN MyStockUpSeq M2
    ON M2.row_num <= M1.row_num
 GROUP BY M1.deal_date;
