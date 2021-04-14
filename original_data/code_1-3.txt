CREATE TABLE Products
(name VARCHAR(16) PRIMARY KEY,
 price INTEGER NOT NULL);

--重複順列・順列・組み合わせ
DELETE FROM Products;
INSERT INTO Products VALUES('りんご',	100);
INSERT INTO Products VALUES('みかん',	50);
INSERT INTO Products VALUES('バナナ',	80);


--重複順列を得る SQL 
SELECT P1.name AS name_1, P2.name AS name_2 
  FROM Products P1 CROSS JOIN Products P2;

SELECT P1.name AS name_1, P2.name AS name_2 
  FROM Products P1, Products P2;


--順列を得る SQL 
SELECT P1.name AS name_1, P2.name AS name_2 
  FROM Products P1 INNER JOIN Products P2 
    ON P1.name <> P2.name;


--組み合わせを得るSQL 
SELECT P1.name AS name_1, P2.name AS name_2 
  FROM Products P1 INNER JOIN Products P2 
    ON P1.name > P2.name;

--組み合わせを得るSQL：3列への拡張版 
SELECT P1.name AS name_1, 
       P2.name AS name_2, 
       P3.name AS name_3 
  FROM Products P1 
         INNER JOIN Products P2
          ON P1.name > P2.name 
            INNER JOIN Products P3 
              ON P2.name > P3.name;


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


--重複行を削除する SQLその 1：極値関数の利用 
DELETE FROM Products P1 
 WHERE rowid < ( SELECT MAX(P2.rowid) 
                   FROM Products P2 
                  WHERE P1.name = P2. name 
                    AND P1.price = P2.price );


--重複行を削除する SQLその 2：非等値結合の利用 
DELETE FROM Products P1 
 WHERE EXISTS ( SELECT * 
                  FROM Products P2 
                 WHERE P1.name = P2.name 
                   AND P1.price = P2.price 
                   AND P1.rowid < P2.rowid );


--部分的に不一致なキーの検索
CREATE TABLE Addresses
(name VARCHAR(32),
 family_id INTEGER,
 address VARCHAR(32),
 PRIMARY KEY(name, family_id));

INSERT INTO Addresses VALUES('前田 義明', '100', '東京都港区虎ノ門3-2-29');
INSERT INTO Addresses VALUES('前田 由美', '100', '東京都港区虎ノ門3-2-92');
INSERT INTO Addresses VALUES('加藤 茶',   '200', '東京都新宿区西新宿2-8-1');
INSERT INTO Addresses VALUES('加藤 勝',   '200', '東京都新宿区西新宿2-8-1');
INSERT INTO Addresses VALUES('ホームズ',  '300', 'ベーカー街221B');
INSERT INTO Addresses VALUES('ワトソン',  '400', 'ベーカー街221B');


--同じ家族だけど、住所が違うレコードを検索する SQL 
SELECT DISTINCT A1.name, A1.address 
  FROM Addresses A1 INNER JOIN Addresses A2 
    ON A1.family_id = A2.family_id 
   AND A1.address <> A2.address ;


DELETE FROM Products;
INSERT INTO Products VALUES('りんご',	50);
INSERT INTO Products VALUES('みかん',	100);
INSERT INTO Products VALUES('ぶどう',	50);
INSERT INTO Products VALUES('スイカ',	80);
INSERT INTO Products VALUES('レモン',	30);
INSERT INTO Products VALUES('いちご',	100);
INSERT INTO Products VALUES('バナナ',	100);

--同じ値段だけど、商品名が違うレコードを検索する SQL 
SELECT DISTINCT P1.name, P1.price 
  FROM Products P1 INNER JOIN Products P2 
    ON P1.price = P2.price 
   AND P1.name <> P2.name
 ORDER BY P1.price;


--ランキング算出：ウィンドウ関数の利用
SELECT name, price,
       RANK() OVER (ORDER BY price DESC) AS rank_1,
       DENSE_RANK() OVER (ORDER BY price DESC) AS rank_2
  FROM Products;


--ランキング1位から始まる。同順位が続いた後は不連続
SELECT P1.name, P1.price,
       (SELECT COUNT(P2.price)
          FROM Products P2
         WHERE P2.price > P1.price) + 1 AS rank_1
  FROM Products P1;


--ランキングを求める：自己結合の利用
SELECT P1.name, MAX(P1.price) AS price,
       COUNT(P2.name) +1 AS rank_1
  FROM Products P1 LEFT OUTER JOIN Products P2
    ON P1.price < P2.price GROUP BY P1.name;

--非集約化して、集合の包含関係を調べる
SELECT P1.name, P2.name
  FROM Products P1 LEFT OUTER JOIN Products P2
    ON P1.price < P2.price;



