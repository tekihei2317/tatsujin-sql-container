
/* �e�[�u���ɑ��݁u���Ȃ��v�f�[�^��T�� */
CREATE TABLE Meetings
(meeting CHAR(32) NOT NULL,
 person  CHAR(32) NOT NULL,
 PRIMARY KEY (meeting, person));

INSERT INTO Meetings VALUES('��P��', '�ɓ�');
INSERT INTO Meetings VALUES('��P��', '����');
INSERT INTO Meetings VALUES('��P��', '�Ⓦ');
INSERT INTO Meetings VALUES('��Q��', '�ɓ�');
INSERT INTO Meetings VALUES('��Q��', '�{�c');
INSERT INTO Meetings VALUES('��R��', '�Ⓦ');
INSERT INTO Meetings VALUES('��R��', '����');
INSERT INTO Meetings VALUES('��R��', '�{�c');

/* �S�̗ʉ��@���̂P�F�m��̓�d�ے�̕ϊ��Ɋ���悤 */
CREATE TABLE TestScores
(student_id INTEGER,
 subject    VARCHAR(32) ,
 score      INTEGER,
  PRIMARY KEY(student_id, subject));

INSERT INTO TestScores VALUES(100, '�Z��',100);
INSERT INTO TestScores VALUES(100, '����',80);
INSERT INTO TestScores VALUES(100, '����',80);
INSERT INTO TestScores VALUES(200, '�Z��',80);
INSERT INTO TestScores VALUES(200, '����',95);
INSERT INTO TestScores VALUES(300, '�Z��',40);
INSERT INTO TestScores VALUES(300, '����',90);
INSERT INTO TestScores VALUES(300, '�Љ�',55);
INSERT INTO TestScores VALUES(400, '�Z��',80);

/* �S�̗ʉ��@���̂Q�F�W��VS �q��\�\�����̂͂ǂ������H */
CREATE TABLE Projects
(project_id VARCHAR(32),
 step_nbr   INTEGER ,
 status     VARCHAR(32),
  PRIMARY KEY(project_id, step_nbr));

INSERT INTO Projects VALUES('AA100', 0, '����');
INSERT INTO Projects VALUES('AA100', 1, '�ҋ@');
INSERT INTO Projects VALUES('AA100', 2, '�ҋ@');
INSERT INTO Projects VALUES('B200',  0, '�ҋ@');
INSERT INTO Projects VALUES('B200',  1, '�ҋ@');
INSERT INTO Projects VALUES('CS300', 0, '����');
INSERT INTO Projects VALUES('CS300', 1, '����');
INSERT INTO Projects VALUES('CS300', 2, '�ҋ@');
INSERT INTO Projects VALUES('CS300', 3, '�ҋ@');
INSERT INTO Projects VALUES('DY400', 0, '����');
INSERT INTO Projects VALUES('DY400', 1, '����');
INSERT INTO Projects VALUES('DY400', 2, '����');

/* ��ɑ΂���ʉ��F�I�[���P�̍s��T�� */
CREATE TABLE ArrayTbl
 (keycol CHAR(1) PRIMARY KEY,
  col1  INTEGER,
  col2  INTEGER,
  col3  INTEGER,
  col4  INTEGER,
  col5  INTEGER,
  col6  INTEGER,
  col7  INTEGER,
  col8  INTEGER,
  col9  INTEGER,
  col10 INTEGER);

--�I�[��NULL
INSERT INTO ArrayTbl VALUES('A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ArrayTbl VALUES('B', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
--�I�[��1
INSERT INTO ArrayTbl VALUES('C', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
--���Ȃ��Ƃ����9
INSERT INTO ArrayTbl VALUES('D', NULL, NULL, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO ArrayTbl VALUES('E', NULL, 3, NULL, 1, 9, NULL, NULL, 9, NULL, NULL);

/* 5-1�F�z��e�[�u���\�\�s�����̏ꍇ */
CREATE TABLE ArrayTbl2
 (key   CHAR(1) NOT NULL,
    i   INTEGER NOT NULL,
  val   INTEGER,
  PRIMARY KEY (key, i));

/* A�̓I�[��NULL�AB�͈������NULL�AC�̓I�[����NULL */
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
