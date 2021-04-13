/* 既存のコード体系を新しい体系に変換して集計 */
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);

INSERT INTO PopTbl VALUES ('徳島', 100);

INSERT INTO PopTbl VALUES ('香川', 200);

INSERT INTO PopTbl VALUES ('愛媛', 150);

INSERT INTO PopTbl VALUES ('高知', 200);

INSERT INTO PopTbl VALUES ('福岡', 300);

INSERT INTO PopTbl VALUES ('佐賀', 100);

INSERT INTO PopTbl VALUES ('長崎', 200);

INSERT INTO PopTbl VALUES ('東京', 400);

INSERT INTO PopTbl VALUES ('群馬', 50);

/* 異なる条件の集計を1つのSQLで行う */
CREATE TABLE PopTbl2 (
  pref_name VARCHAR(32),
  sex CHAR(1) NOT NULL,
  population INTEGER NOT NULL,
  PRIMARY KEY(pref_name, sex)
);

INSERT INTO PopTbl2 VALUES ('徳島', '1', 60);

INSERT INTO PopTbl2 VALUES ('徳島', '2', 40);

INSERT INTO PopTbl2 VALUES ('香川', '1', 100);

INSERT INTO PopTbl2 VALUES ('香川', '2', 100);

INSERT INTO PopTbl2 VALUES ('愛媛', '1', 100);

INSERT INTO PopTbl2 VALUES ('愛媛', '2', 50);

INSERT INTO PopTbl2 VALUES ('高知', '1', 100);

INSERT INTO PopTbl2 VALUES ('高知', '2', 100);

INSERT INTO PopTbl2 VALUES ('福岡', '1', 100);

INSERT INTO PopTbl2 VALUES ('福岡', '2', 200);

INSERT INTO PopTbl2 VALUES ('佐賀', '1', 20);

INSERT INTO PopTbl2 VALUES ('佐賀', '2', 80);

INSERT INTO PopTbl2 VALUES ('長崎', '1', 125);

INSERT INTO PopTbl2 VALUES ('長崎', '2', 125);

INSERT INTO PopTbl2 VALUES ('東京', '1', 250);

INSERT INTO PopTbl2 VALUES ('東京', '2', 150);

/* CHECK制約で複数の列の条件関係を定義する */
CREATE TABLE TestSal (
  sex CHAR(1),
  salary INTEGER,
  CONSTRAINT check_salary CHECK (
    CASE
      WHEN sex = '2' THEN CASE
        WHEN salary <= 200000 THEN 1
        ELSE 0
      END
      ELSE 1
    END = 1
  )
);

INSERT INTO TestSal VALUES (1, 200000);

INSERT INTO TestSal VALUES (1, 300000);

INSERT INTO TestSal VALUES (1, NULL);

INSERT INTO TestSal VALUES (2, 200000);

/* 条件を分岐させたUPDATE */
CREATE TABLE SomeTable (
  p_key CHAR(1) PRIMARY KEY,
  col_1 INTEGER NOT NULL,
  col_2 CHAR(2) NOT NULL
);

INSERT INTO SomeTable VALUES ('a', 1, 'あ');
INSERT INTO SomeTable VALUES ('b', 2, 'い');
INSERT INTO SomeTable VALUES ('c', 3, 'う');

/* テーブル同士のマッチング */
CREATE TABLE CourseMaster (
  course_id INTEGER PRIMARY KEY,
  course_name VARCHAR(32) NOT NULL
);

INSERT INTO CourseMaster VALUES (1, '経理入門');

INSERT INTO CourseMaster VALUES (2, '財務知識');

INSERT INTO CourseMaster VALUES (3, '簿記検定');

INSERT INTO CourseMaster VALUES (4, '税理士');

CREATE TABLE OpenCourses (
  month INTEGER,
  course_id INTEGER,
  PRIMARY KEY(month, course_id)
);

INSERT INTO OpenCourses VALUES (200706, 1);

INSERT INTO OpenCourses VALUES (200706, 3);

INSERT INTO OpenCourses VALUES (200706, 4);

INSERT INTO OpenCourses VALUES (200707, 4);

INSERT INTO OpenCourses VALUES (200708, 2);

INSERT INTO OpenCourses VALUES (200708, 4);

/* CASE式の中で集約関数を使う */
CREATE TABLE StudentClub (
  std_id INTEGER,
  club_id INTEGER,
  club_name VARCHAR(32),
  main_club_flg CHAR(1),
  PRIMARY KEY (std_id, club_id)
);

INSERT INTO StudentClub VALUES
  (100, 1, '野球', 'Y');

INSERT INTO StudentClub VALUES
  (100, 2, '吹奏楽', 'N');

INSERT INTO StudentClub VALUES
  (200, 2, '吹奏楽', 'N');

INSERT INTO StudentClub VALUES
  (200, 3, 'バドミントン', 'Y');

INSERT INTO StudentClub VALUES
  (200, 4, 'サッカー', 'N');

INSERT INTO StudentClub VALUES
  (300, 4, 'サッカー', 'N');

INSERT INTO StudentClub VALUES
  (400, 5, '水泳', 'N');

INSERT INTO StudentClub VALUES
  (500, 6, '囲碁', 'N');
