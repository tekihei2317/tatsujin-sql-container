/* �e�[�u�����m�̃R���y�A�@�W���̑������`�F�b�N */
CREATE TABLE Tbl_A
 (keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER , 
  col_2   INTEGER, 
  col_3   INTEGER);

CREATE TABLE Tbl_B
 (keycol  CHAR(1) PRIMARY KEY,
  col_1   INTEGER, 
  col_2   INTEGER, 
  col_3   INTEGER);

/* �������e�[�u�����m�̃P�[�X */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', 2, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', 5, 1, 6);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', 2, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', 5, 1, 6);


/* �uB�v�̍s�����Ⴗ��P�[�X */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', 2, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', 5, 1, 6);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', 2, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 8);
INSERT INTO Tbl_B VALUES('C', 5, 1, 6);


/* NULL���܂ރP�[�X�i�������j */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', NULL, NULL, NULL);


/* NULL���܂ރP�[�X�i�uC�v�̍s���قȂ�j */
DELETE FROM Tbl_A;
INSERT INTO Tbl_A VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_A VALUES('B', 0, 7, 9);
INSERT INTO Tbl_A VALUES('C', NULL, NULL, NULL);

DELETE FROM Tbl_B;
INSERT INTO Tbl_B VALUES('A', NULL, 3, 4);
INSERT INTO Tbl_B VALUES('B', 0, 7, 9);
INSERT INTO Tbl_B VALUES('C', 0, NULL, NULL);


/* 3. ���W���Ŋ֌W���Z��\������ */
CREATE TABLE Skills 
(skill VARCHAR(32),
 PRIMARY KEY(skill));

CREATE TABLE EmpSkills 
(emp   VARCHAR(32), 
 skill VARCHAR(32),
 PRIMARY KEY(emp, skill));

INSERT INTO Skills VALUES('Oracle');
INSERT INTO Skills VALUES('UNIX');
INSERT INTO Skills VALUES('Java');

INSERT INTO EmpSkills VALUES('���c', 'Oracle');
INSERT INTO EmpSkills VALUES('���c', 'UNIX');
INSERT INTO EmpSkills VALUES('���c', 'Java');
INSERT INTO EmpSkills VALUES('���c', 'C#');
INSERT INTO EmpSkills VALUES('�_��', 'Oracle');
INSERT INTO EmpSkills VALUES('�_��', 'UNIX');
INSERT INTO EmpSkills VALUES('�_��', 'Java');
INSERT INTO EmpSkills VALUES('����', 'UNIX');
INSERT INTO EmpSkills VALUES('����', 'Oracle');
INSERT INTO EmpSkills VALUES('����', 'PHP');
INSERT INTO EmpSkills VALUES('����', 'Perl');
INSERT INTO EmpSkills VALUES('����', 'C++');
INSERT INTO EmpSkills VALUES('��c��', 'Perl');
INSERT INTO EmpSkills VALUES('�n��', 'Oracle');

/* 4. �����������W���������� */
CREATE TABLE SupParts
(sup  CHAR(32) NOT NULL,
 part CHAR(32) NOT NULL,
 PRIMARY KEY(sup, part));

INSERT INTO SupParts VALUES('A',  '�{���g');
INSERT INTO SupParts VALUES('A',  '�i�b�g');
INSERT INTO SupParts VALUES('A',  '�p�C�v');
INSERT INTO SupParts VALUES('B',  '�{���g');
INSERT INTO SupParts VALUES('B',  '�p�C�v');
INSERT INTO SupParts VALUES('C',  '�{���g');
INSERT INTO SupParts VALUES('C',  '�i�b�g');
INSERT INTO SupParts VALUES('C',  '�p�C�v');
INSERT INTO SupParts VALUES('D',  '�{���g');
INSERT INTO SupParts VALUES('D',  '�p�C�v');
INSERT INTO SupParts VALUES('E',  '�q���[�Y');
INSERT INTO SupParts VALUES('E',  '�i�b�g');
INSERT INTO SupParts VALUES('E',  '�p�C�v');
INSERT INTO SupParts VALUES('F',  '�q���[�Y');

/* 5. �d���s���폜���鍂���ȃN�G��
PostgreSQL�ł́uwith oids�v��CREATE TABLE���̍Ō�ɒǉ����邱�� */
CREATE TABLE Products
(name  CHAR(16),
 price INTEGER);

INSERT INTO Products VALUES('���',  50);
INSERT INTO Products VALUES('�݂���', 100);
INSERT INTO Products VALUES('�݂���', 100);
INSERT INTO Products VALUES('�݂���', 100);
INSERT INTO Products VALUES('�o�i�i',  80);

/* �e�[�u�����m�̃R���y�A�F��{��*/
SELECT COUNT(*) AS row_cnt
  FROM ( SELECT * 
           FROM   tbl_A 
         UNION
         SELECT * 
           FROM   tbl_B ) TMP;

/* �e�[�u�����m�̃R���y�A�F���p�ҁiOracle�ł͒ʂ�Ȃ��j */
SELECT CASE WHEN COUNT(*) = 0 
            THEN '������'
            ELSE '�قȂ�' END AS result
  FROM ((SELECT * FROM  tbl_A
         UNION
         SELECT * FROM  tbl_B) 
         EXCEPT
        (SELECT * FROM  tbl_A
         INTERSECT 
         SELECT * FROM  tbl_B)) TMP;

/* �e�[�u���ɑ΂���diff�F�r���I�a�W�������߂� */
(SELECT * FROM  tbl_A
   EXCEPT
 SELECT * FROM  tbl_B)
 UNION ALL
(SELECT * FROM  tbl_B
   EXCEPT
 SELECT * FROM  tbl_A);

/* ���W���Ŋ֌W���Z�i��]�����������Z�j */
SELECT DISTINCT emp
  FROM EmpSkills ES1
 WHERE NOT EXISTS
        (SELECT skill
           FROM Skills
         EXCEPT
         SELECT skill
           FROM EmpSkills ES2
          WHERE ES1.emp = ES2.emp);

/* �����������W����������(p.134) */
SELECT SP1.sup, SP2.sup
  FROM SupParts SP1, SupParts SP2 
 WHERE SP1.sup < SP2.sup              /* �Ǝ҂̑g�ݍ��킹����� */
   AND SP1.part = SP2.part            /* �����P�D������ނ̕��i������ */
GROUP BY SP1.sup, SP2.sup 
HAVING COUNT(*) = (SELECT COUNT(*)    /* �����Q�D�����̕��i������ */
                     FROM SupParts SP3 
                    WHERE SP3.sup = SP1.sup)
   AND COUNT(*) = (SELECT COUNT(*) 
                     FROM SupParts SP4 
                    WHERE SP4.sup = SP2.sup);

/* �d���s���폜���鍂���ȃN�G���P�F��W����EXCEPT�ŋ��߂� */
DELETE FROM Products
 WHERE rowid IN ( SELECT rowid
                    FROM Products 
                  EXCEPT
                  SELECT MAX(rowid)
                    FROM Products 
                   GROUP BY name, price);

/* �d���s���폜���鍂���ȃN�G���Q�F��W����NOT IN �ŋ��߂� */
DELETE FROM Products 
 WHERE rowid NOT IN ( SELECT MAX(rowid)
                        FROM Products 
                       GROUP BY name, price);