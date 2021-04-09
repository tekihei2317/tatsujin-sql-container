/* �O�������ōs��ϊ��@����1�i�s����j�F�N���X�\����� */
CREATE TABLE Courses
(name   VARCHAR(32), 
 course VARCHAR(32), 
 PRIMARY KEY(name, course));

INSERT INTO Courses VALUES('�Ԉ�', 'SQL����');
INSERT INTO Courses VALUES('�Ԉ�', 'UNIX��b');
INSERT INTO Courses VALUES('���', 'SQL����');
INSERT INTO Courses VALUES('�H��', 'SQL����');
INSERT INTO Courses VALUES('�H��', 'Java����');
INSERT INTO Courses VALUES('�g�c', 'UNIX��b');
INSERT INTO Courses VALUES('�n��', 'SQL����');

-- �N���X�\�����߂鐅���W�J�F����1�@�O�������̗��p
SELECT C0.name,
       CASE WHEN C1.name IS NOT NULL THEN '��' ELSE NULL END AS "SQL����",
       CASE WHEN C2.name IS NOT NULL THEN '��' ELSE NULL END AS "UNIX��b",
       CASE WHEN C3.name IS NOT NULL THEN '��' ELSE NULL END AS "Java����"
  FROM (SELECT DISTINCT name FROM Courses) C0 --����C0���\���ɂȂ�
         LEFT OUTER JOIN
          (SELECT name FROM Courses WHERE course = 'SQL����') C1
           ON C0.name = C1.name
             LEFT OUTER JOIN
              (SELECT name FROM Courses WHERE course = 'UNIX��b') C2
                ON C0.name = C2.name
                  LEFT OUTER JOIN
                   (SELECT name FROM Courses WHERE course = 'Java����') C3
                     ON C0.name = C3.name;


-- �����W�J�F����2�@�X�J���T�u�N�G���̗��p
SELECT C0.name,
       (SELECT '��'
          FROM Courses C1
         WHERE course = 'SQL����'
           AND C1.name = C0.name) AS "SQL����",
       (SELECT '��'
          FROM Courses C2
         WHERE course = 'UNIX��b'
           AND C2.name = C0.name) AS "UNIX��b",
       (SELECT '��'
          FROM Courses C3
         WHERE course = 'Java����'
           AND C3.name = C0.name) AS "Java����"
  FROM (SELECT DISTINCT name FROM Courses) C0; --����C0���\���ɂȂ�


-- �����W�J�F����3�@CASE�������q�ɂ���
SELECT name,
       CASE WHEN SUM(CASE WHEN course = 'SQL����' THEN 1 ELSE NULL END) = 1
            THEN '��' ELSE NULL END AS "SQL����",
       CASE WHEN SUM(CASE WHEN course = 'UNIX��b' THEN 1 ELSE NULL END) = 1
            THEN '��' ELSE NULL END AS "UNIX��b",
       CASE WHEN SUM(CASE WHEN course = 'Java����' THEN 1 ELSE NULL END) = 1
            THEN '��' ELSE NULL END AS "Java����"
  FROM Courses
 GROUP BY name;



/* �O�������ōs��ϊ��@����2�i�񁨍s�j�F�J��Ԃ����ڂ�1 ��ɂ܂Ƃ߂� */
CREATE TABLE Personnel
 (employee   varchar(32), 
  child_1    varchar(32), 
  child_2    varchar(32), 
  child_3    varchar(32), 
  PRIMARY KEY(employee));

INSERT INTO Personnel VALUES('�Ԉ�', '��Y', '��Y', '�O�Y');
INSERT INTO Personnel VALUES('�H��', '�t�q', '�Ďq', NULL);
INSERT INTO Personnel VALUES('���', '�Ďq', NULL,   NULL);
INSERT INTO Personnel VALUES('�g�c', NULL,   NULL,   NULL);

-- �񂩂�s�ւ̕ϊ��FUNION ALL�̗��p
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


-- �Ј��̎q�ǂ����X�g�𓾂�SQL�i�q�ǂ��̂��Ȃ��Ј����o�͂���j
SELECT EMP.employee, Children.child
  FROM Personnel EMP
         LEFT OUTER JOIN Children
           ON Children.child IN (EMP.child_1, EMP.child_2, EMP.child_3);

/* �N���X�\�œ���q�̕\������� */
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

INSERT INTO TblSex (sex_cd, sex ) VALUES('m',	'�j');
INSERT INTO TblSex (sex_cd, sex ) VALUES('f',	'��');

INSERT INTO TblAge (age_class, age_range ) VALUES('1',	'21�`30��');
INSERT INTO TblAge (age_class, age_range ) VALUES('2',	'31�`40��');
INSERT INTO TblAge (age_class, age_range ) VALUES('3',	'41�`50��');

INSERT INTO TblPop VALUES('�H�c', '1', 'm', 400 );
INSERT INTO TblPop VALUES('�H�c', '3', 'm', 1000 );
INSERT INTO TblPop VALUES('�H�c', '1', 'f', 800 );
INSERT INTO TblPop VALUES('�H�c', '3', 'f', 1000 );
INSERT INTO TblPop VALUES('�X', '1', 'm', 700 );
INSERT INTO TblPop VALUES('�X', '1', 'f', 500 );
INSERT INTO TblPop VALUES('�X', '3', 'f', 800 );
INSERT INTO TblPop VALUES('����', '1', 'm', 900 );
INSERT INTO TblPop VALUES('����', '1', 'f', 1500 );
INSERT INTO TblPop VALUES('����', '3', 'f', 1200 );
INSERT INTO TblPop VALUES('��t', '1', 'm', 900 );
INSERT INTO TblPop VALUES('��t', '1', 'f', 1000 );
INSERT INTO TblPop VALUES('��t', '3', 'f', 900 );

-- �O�������œ���q�̕\�������F�Ԉ����SQL
SELECT MASTER1.age_class AS age_class,
       MASTER2.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd,
               SUM(CASE WHEN pref_name IN ('�X', '�H�c')
                        THEN population ELSE NULL END) AS pop_tohoku,
               SUM(CASE WHEN pref_name IN ('����', '��t')
                        THEN population ELSE NULL END) AS pop_kanto
          FROM TblPop
         GROUP BY age_class, sex_cd) DATA
           RIGHT OUTER JOIN TblAge MASTER1 --�O������1�F�N��K���}�X�^�ƌ���
              ON MASTER1.age_class = DATA.age_class
           RIGHT OUTER JOIN TblSex MASTER2 --�O������2�F���ʃ}�X�^�ƌ���
              ON MASTER2.sex_cd = DATA.sex_cd;


-- �ŏ��̊O�������Ŏ~�߂��ꍇ�F�N��K���u2�v�����ʂɌ�����
SELECT MASTER1.age_class AS age_class,
       DATA.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd,
               SUM(CASE WHEN pref_name IN ('�X', '�H�c')
                        THEN population ELSE NULL END) AS pop_tohoku,
               SUM(CASE WHEN pref_name IN ('����', '��t')
                        THEN population ELSE NULL END) AS pop_kanto
          FROM TblPop
         GROUP BY age_class, sex_cd) DATA
          RIGHT OUTER JOIN TblAge MASTER1
             ON MASTER1.age_class = DATA.age_class;


-- �O�������œ���q�̕\�������F������SQL
SELECT MASTER.age_class AS age_class,
       MASTER.sex_cd AS sex_cd,
       DATA.pop_tohoku AS pop_tohoku,
       DATA.pop_kanto AS pop_kanto
  FROM (SELECT age_class, sex_cd
          FROM TblAge CROSS JOIN TblSex ) MASTER --�N���X�����Ń}�X�^���m�̒��ς����
            LEFT OUTER JOIN
             (SELECT age_class, sex_cd,
                     SUM(CASE WHEN pref_name IN ('�X', '�H�c')
                              THEN population ELSE NULL END) AS pop_tohoku,
                     SUM(CASE WHEN pref_name IN ('����', '��t')
                              THEN population ELSE NULL END) AS pop_kanto
                FROM TblPop
               GROUP BY age_class, sex_cd) DATA
    ON MASTER.age_class = DATA.age_class
   AND MASTER.sex_cd = DATA.sex_cd;


/* �|���Z�Ƃ��Ă̌��� */
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

-- �����F����1�@�����̑O�ɏW�񂷂邱�ƂŁA1��1�̊֌W�����
SELECT I.item_no, SH.total_qty
  FROM Items I LEFT OUTER JOIN
                (SELECT item_no, SUM(quantity) AS total_qty
                   FROM SalesHistory
                  GROUP BY item_no) SH
    ON I.item_no = SH.item_no;

-- �����F����2�@�W��̑O��1�Α��̌������s�Ȃ�
SELECT I.item_no, SUM(SH.quantity) AS total_qty
  FROM Items I LEFT OUTER JOIN SalesHistory SH
    ON I.item_no = SH.item_no --1�Α��̌���
 GROUP BY I.item_no;


/* ���S�O������ */
CREATE TABLE Class_A
(id char(1), 
 name varchar(30), 
 PRIMARY KEY(id));

CREATE TABLE Class_B
(id   char(1), 
 name varchar(30), 
 PRIMARY KEY(id));

INSERT INTO Class_A (id, name) VALUES('1', '�c��');
INSERT INTO Class_A (id, name) VALUES('2', '���');
INSERT INTO Class_A (id, name) VALUES('3', '�ɏW�@');

INSERT INTO Class_B (id, name) VALUES('1', '�c��');
INSERT INTO Class_B (id, name) VALUES('2', '���');
INSERT INTO Class_B (id, name) VALUES('4', '������');


-- ���S�O�������͏����u���S�v�ɕۑ�����
SELECT COALESCE(A.id, B.id) AS id,
       A.name AS A_name,
       B.name AS B_name
  FROM Class_A A FULL OUTER JOIN Class_B B
    ON A.id = B.id;


-- ���S�O���������g���Ȃ����ł̑�֕��@
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

-- �O�������Ŋ֌W���Z�F���W���̉��p
SELECT DISTINCT shop
  FROM ShopItems SI1
 WHERE NOT EXISTS
        (SELECT I.item
           FROM Items I LEFT OUTER JOIN ShopItems SI2
             ON I.item = SI2.item
            AND SI1.shop = SI2.shop
          WHERE SI2.item IS NULL) ;


