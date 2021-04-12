/* �����̃R�[�h�̌n��V�����̌n�ɕϊ����ďW�v */
CREATE TABLE PopTbl (
  pref_name VARCHAR(32) PRIMARY KEY,
  population INTEGER NOT NULL
);

INSERT INTO PopTbl VALUES ('����', 100);

INSERT INTO PopTbl VALUES ('����', 200);

INSERT INTO PopTbl VALUES ('���Q', 150);

INSERT INTO PopTbl VALUES ('���m', 200);

INSERT INTO PopTbl VALUES ('����', 300);

INSERT INTO PopTbl VALUES ('����', 100);

INSERT INTO PopTbl VALUES ('����', 200);

INSERT INTO PopTbl VALUES ('����', 400);

INSERT INTO PopTbl VALUES ('�Q�n', 50);

/* �قȂ�����̏W�v��1��SQL�ōs�� */
CREATE TABLE PopTbl2 (
  pref_name VARCHAR(32),
  sex CHAR(1) NOT NULL,
  population INTEGER NOT NULL,
  PRIMARY KEY(pref_name, sex)
);

INSERT INTO PopTbl2 VALUES ('����', '1', 60);

INSERT INTO PopTbl2 VALUES ('����', '2', 40);

INSERT INTO PopTbl2 VALUES ('����', '1', 100);

INSERT INTO PopTbl2 VALUES ('����', '2', 100);

INSERT INTO PopTbl2 VALUES ('���Q', '1', 100);

INSERT INTO PopTbl2 VALUES ('���Q', '2', 50);

INSERT INTO PopTbl2 VALUES ('���m', '1', 100);

INSERT INTO PopTbl2 VALUES ('���m', '2', 100);

INSERT INTO PopTbl2 VALUES ('����', '1', 100);

INSERT INTO PopTbl2 VALUES ('����', '2', 200);

INSERT INTO PopTbl2 VALUES ('����', '1', 20);

INSERT INTO PopTbl2 VALUES ('����', '2', 80);

INSERT INTO PopTbl2 VALUES ('����', '1', 125);

INSERT INTO PopTbl2 VALUES ('����', '2', 125);

INSERT INTO PopTbl2 VALUES ('����', '1', 250);

INSERT INTO PopTbl2 VALUES ('����', '2', 150);

/* CHECK����ŕ����̗�̏����֌W���`���� */
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

-- �Ȃ��db1�̕��̓G���[�ɂȂ�Ȃ������񂾂낤?
-- INSERT INTO
--   TestSal
-- VALUES
--   (2, 300000);

-- error
-- INSERT INTO
--   TestSal
-- VALUES
--   (2, NULL);

-- INSERT INTO
--   TestSal
-- VALUES
--   (1, 300000);

/* �����𕪊򂳂���UPDATE */
CREATE TABLE SomeTable (
  p_key CHAR(1) PRIMARY KEY,
  col_1 INTEGER NOT NULL,
  col_2 CHAR(2) NOT NULL
);

INSERT INTO SomeTable VALUES ('a', 1, '��');
INSERT INTO SomeTable VALUES ('b', 2, '��');
INSERT INTO SomeTable VALUES ('c', 3, '��');

/* �e�[�u�����m�̃}�b�`���O */
CREATE TABLE CourseMaster (
  course_id INTEGER PRIMARY KEY,
  course_name VARCHAR(32) NOT NULL
);

INSERT INTO CourseMaster VALUES (1, '�o������');

INSERT INTO CourseMaster VALUES (2, '�����m��');

INSERT INTO CourseMaster VALUES (3, '��L����');

INSERT INTO CourseMaster VALUES (4, '�ŗ��m');

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

/* CASE���̒��ŏW��֐����g�� */
CREATE TABLE StudentClub (
  std_id INTEGER,
  club_id INTEGER,
  club_name VARCHAR(32),
  main_club_flg CHAR(1),
  PRIMARY KEY (std_id, club_id)
);

INSERT INTO StudentClub VALUES
  (100, 1, '�싅', 'Y');

INSERT INTO StudentClub VALUES
  (100, 2, '���t�y', 'N');

INSERT INTO StudentClub VALUES
  (200, 2, '���t�y', 'N');

INSERT INTO StudentClub VALUES
  (200, 3, '�o�h�~���g��', 'Y');

INSERT INTO StudentClub VALUES
  (200, 4, '�T�b�J�[', 'N');

INSERT INTO StudentClub VALUES
  (300, 4, '�T�b�J�[', 'N');

INSERT INTO StudentClub VALUES
  (400, 5, '���j', 'N');

INSERT INTO StudentClub VALUES
  (500, 6, '�͌�', 'N');
