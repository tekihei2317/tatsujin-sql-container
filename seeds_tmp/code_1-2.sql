CREATE TABLE Shohin (
  shohin_id CHAR(4) NOT NULL,
  shohin_mei VARCHAR(100) NOT NULL,
  shohin_bunrui VARCHAR(32) NOT NULL,
  hanbai_tanka INTEGER,
  shiire_tanka INTEGER,
  torokubi DATE,
  PRIMARY KEY (shohin_id)
);

INSERT INTO
  Shohin
VALUES
  ('0001', 'Tシャツ', '衣服', 1000, 500, '2009-09-20');

INSERT INTO
  Shohin
VALUES
  ('0002', '穴あけパンチ', '事務用品', 500, 320, '2009-09-11');

INSERT INTO
  Shohin
VALUES
  ('0003', 'カッターシャツ', '衣服', 4000, 2800, NULL);

INSERT INTO
  Shohin
VALUES
  ('0004', '包丁', 'キッチン用品', 3000, 2800, '2009-09-20');

INSERT INTO
  Shohin
VALUES
  (
    '0005',
    '圧力鍋',
    'キッチン用品',
    6800,
    5000,
    '2009-01-15'
  );

INSERT INTO
  Shohin
VALUES
  (
    '0006',
    'フォーク',
    'キッチン用品',
    500,
    NULL,
    '2009-09-20'
  );

INSERT INTO
  Shohin
VALUES
  (
    '0007',
    'おろしがね',
    'キッチン用品',
    880,
    790,
    '2008-04-28'
  );

CREATE TABLE LoadSample (
  sample_date DATE PRIMARY KEY,
  load_val INTEGER NOT NULL
);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-01', 1024);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-02', 2366);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-05', 2366);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-07', 985);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-08', 780);

INSERT INTO
  LoadSample
VALUES
  ('2018-02-12', 1000);