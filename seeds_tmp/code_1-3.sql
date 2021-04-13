CREATE TABLE Products (
  name VARCHAR(16) PRIMARY KEY,
  price INTEGER NOT NULL
);

--重複順列・順列・組み合わせ
DELETE FROM
  Products;

INSERT INTO
  Products
VALUES
  ('りんご', 100);

INSERT INTO
  Products
VALUES
  ('みかん', 50);

INSERT INTO
  Products
VALUES
  ('バナナ', 80);

CREATE TABLE Products (
  name VARCHAR(16) NOT NULL,
  price INTEGER NOT NULL
);

--重複するレコード
INSERT INTO
  Products
VALUES
  ('りんご', 50);

INSERT INTO
  Products
VALUES
  ('みかん', 100);

INSERT INTO
  Products
VALUES
  ('みかん', 100);

INSERT INTO
  Products
VALUES
  ('みかん', 100);

INSERT INTO
  Products
VALUES
  ('バナナ', 80);

--部分的に不一致なキーの検索
CREATE TABLE Addresses (
  name VARCHAR(32),
  family_id INTEGER,
  address VARCHAR(32),
  PRIMARY KEY(name, family_id)
);

INSERT INTO
  Addresses
VALUES
  ('前田 義明', '100', '東京都港区虎ノ門3-2-29');

INSERT INTO
  Addresses
VALUES
  ('前田 由美', '100', '東京都港区虎ノ門3-2-92');

INSERT INTO
  Addresses
VALUES
  ('加藤 茶', '200', '東京都新宿区西新宿2-8-1');

INSERT INTO
  Addresses
VALUES
  ('加藤 勝', '200', '東京都新宿区西新宿2-8-1');

INSERT INTO
  Addresses
VALUES
  ('ホームズ', '300', 'ベーカー街221B');

INSERT INTO
  Addresses
VALUES
  ('ワトソン', '400', 'ベーカー街221B');

DELETE FROM
  Products;

INSERT INTO
  Products
VALUES
  ('りんご', 50);

INSERT INTO
  Products
VALUES
  ('みかん', 100);

INSERT INTO
  Products
VALUES
  ('ぶどう', 50);

INSERT INTO
  Products
VALUES
  ('スイカ', 80);

INSERT INTO
  Products
VALUES
  ('レモン', 30);

INSERT INTO
  Products
VALUES
  ('いちご', 100);

INSERT INTO
  Products
VALUES
  ('バナナ', 100);