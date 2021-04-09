/* �f�[�^�̎�������T�� */
CREATE TABLE SeqTbl
(seq  INTEGER PRIMARY KEY,
 name VARCHAR(16) NOT NULL);

INSERT INTO SeqTbl VALUES(1,	'�f�B�b�N');
INSERT INTO SeqTbl VALUES(2,	'�A��');
INSERT INTO SeqTbl VALUES(3,	'���C��');
INSERT INTO SeqTbl VALUES(5,	'�J�[');
INSERT INTO SeqTbl VALUES(6,	'�}���[');
INSERT INTO SeqTbl VALUES(8,	'�x��');

-- ���Ԃ�T���F���W��
CREATE TABLE SeqTbl
( seq INTEGER NOT NULL PRIMARY KEY);

-- �������Ȃ��F�J�n�l��1
DELETE FROM SeqTbl;
INSERT INTO SeqTbl VALUES(1);
INSERT INTO SeqTbl VALUES(2);
INSERT INTO SeqTbl VALUES(3);
INSERT INTO SeqTbl VALUES(4);
INSERT INTO SeqTbl VALUES(5);

-- ����������F�J�n�l��1
DELETE FROM SeqTbl;
INSERT INTO SeqTbl VALUES(1);
INSERT INTO SeqTbl VALUES(2);
INSERT INTO SeqTbl VALUES(4);
INSERT INTO SeqTbl VALUES(5);
INSERT INTO SeqTbl VALUES(8);

-- �������Ȃ��F�J�n�l��1�ł͂Ȃ�
DELETE FROM SeqTbl;
INSERT INTO SeqTbl VALUES(3);
INSERT INTO SeqTbl VALUES(4);
INSERT INTO SeqTbl VALUES(5);
INSERT INTO SeqTbl VALUES(6);
INSERT INTO SeqTbl VALUES(7);

-- ����������F�J�n�l��1�ł͂Ȃ�
DELETE FROM SeqTbl;
INSERT INTO SeqTbl VALUES(3);
INSERT INTO SeqTbl VALUES(4);
INSERT INTO SeqTbl VALUES(7);
INSERT INTO SeqTbl VALUES(8);
INSERT INTO SeqTbl VALUES(10);

CREATE TABLE Graduates
(name   VARCHAR(16) PRIMARY KEY,
 income INTEGER NOT NULL);

INSERT INTO Graduates VALUES('�T���v�\��', 400000);
INSERT INTO Graduates VALUES('�}�C�N',     30000);
INSERT INTO Graduates VALUES('�z���C�g',   20000);
INSERT INTO Graduates VALUES('�A�[�m���h', 20000);
INSERT INTO Graduates VALUES('�X�~�X',     20000);
INSERT INTO Graduates VALUES('�������X',   15000);
INSERT INTO Graduates VALUES('�n�h�\��',   15000);
INSERT INTO Graduates VALUES('�P���g',     10000);
INSERT INTO Graduates VALUES('�x�b�J�[',   10000);
INSERT INTO Graduates VALUES('�X�R�b�g',   10000);

CREATE TABLE NullTbl (col_1 INTEGER);

INSERT INTO NullTbl VALUES (NULL);
INSERT INTO NullTbl VALUES (NULL);
INSERT INTO NullTbl VALUES (NULL);

/* NULL ���܂܂Ȃ��W����T�� */
CREATE TABLE Students
(student_id   INTEGER PRIMARY KEY,
 dpt          VARCHAR(16) NOT NULL,
 sbmt_date    DATE);

INSERT INTO Students VALUES(100,  '���w��',   '2018-10-10');
INSERT INTO Students VALUES(101,  '���w��',   '2018-09-22');
INSERT INTO Students VALUES(102,  '���w��',   NULL);
INSERT INTO Students VALUES(103,  '���w��',   '2018-09-10');
INSERT INTO Students VALUES(200,  '���w��',   '2018-09-22');
INSERT INTO Students VALUES(201,  '�H�w��',   NULL);
INSERT INTO Students VALUES(202,  '�o�ϊw��', '2018-09-25');

-- �W���ɂ��ߍׂ��ȏ�����ݒ肷��
CREATE TABLE TestResults
(student_id CHAR(12) NOT NULL PRIMARY KEY,
 class   CHAR(1)  NOT NULL,
 sex     CHAR(1)  NOT NULL,
 score   INTEGER  NOT NULL);

INSERT INTO TestResults VALUES('001', 'A', '�j', 100);
INSERT INTO TestResults VALUES('002', 'A', '��', 100);
INSERT INTO TestResults VALUES('003', 'A', '��',  49);
INSERT INTO TestResults VALUES('004', 'A', '�j',  30);
INSERT INTO TestResults VALUES('005', 'B', '��', 100);
INSERT INTO TestResults VALUES('006', 'B', '�j',  92);
INSERT INTO TestResults VALUES('007', 'B', '�j',  80);
INSERT INTO TestResults VALUES('008', 'B', '�j',  80);
INSERT INTO TestResults VALUES('009', 'B', '��',  10);
INSERT INTO TestResults VALUES('010', 'C', '�j',  92);
INSERT INTO TestResults VALUES('011', 'C', '�j',  80);
INSERT INTO TestResults VALUES('012', 'C', '��',  21);
INSERT INTO TestResults VALUES('013', 'D', '��', 100);
INSERT INTO TestResults VALUES('014', 'D', '��',   0);
INSERT INTO TestResults VALUES('015', 'D', '��',   0);

CREATE TABLE Teams
(member  CHAR(12) NOT NULL PRIMARY KEY,
 team_id INTEGER  NOT NULL,
 status  CHAR(8)  NOT NULL);

INSERT INTO Teams VALUES('�W���[',   1, '�ҋ@');
INSERT INTO Teams VALUES('�P��',     1, '�o����');
INSERT INTO Teams VALUES('�~�b�N',   1, '�ҋ@');
INSERT INTO Teams VALUES('�J����',   2, '�o����');
INSERT INTO Teams VALUES('�L�[�X',   2, '�x��');
INSERT INTO Teams VALUES('�W����',   3, '�ҋ@');
INSERT INTO Teams VALUES('�n�[�g',   3, '�ҋ@');
INSERT INTO Teams VALUES('�f�B�b�N', 3, '�ҋ@');
INSERT INTO Teams VALUES('�x�X',     4, '�ҋ@');
INSERT INTO Teams VALUES('�A����',   5, '�o����');
INSERT INTO Teams VALUES('���o�[�g', 5, '�x��');
INSERT INTO Teams VALUES('�P�[�K��', 5, '�ҋ@');

-- ��ӏW���Ƒ��d�W��
CREATE TABLE Materials
(center         CHAR(12) NOT NULL,
 receive_date   DATE     NOT NULL,
 material       CHAR(12) NOT NULL,
 PRIMARY KEY(center, receive_date));

INSERT INTO Materials VALUES('����'	,'2018-4-01',	'��');
INSERT INTO Materials VALUES('����'	,'2018-4-12',	'����');
INSERT INTO Materials VALUES('����'	,'2018-5-17',	'�A���~�j�E��');
INSERT INTO Materials VALUES('����'	,'2018-5-20',	'����');
INSERT INTO Materials VALUES('���'	,'2018-4-20',	'��');
INSERT INTO Materials VALUES('���'	,'2018-4-22',	'�j�b�P��');
INSERT INTO Materials VALUES('���'	,'2018-4-29',	'��');
INSERT INTO Materials VALUES('���É�',	'2018-3-15',	'�`�^��');
INSERT INTO Materials VALUES('���É�',	'2018-4-01',	'�Y�f�|');
INSERT INTO Materials VALUES('���É�',	'2018-4-24',	'�Y�f�|');
INSERT INTO Materials VALUES('���É�',	'2018-5-02',	'�}�O�l�V�E��');
INSERT INTO Materials VALUES('���É�',	'2018-5-10',	'�`�^��');
INSERT INTO Materials VALUES('����'	,'2018-5-10',	'����');
INSERT INTO Materials VALUES('����'	,'2018-5-28',	'��');

/* �֌W���Z�Ńo�X�P�b�g��� */
CREATE TABLE Items
(item VARCHAR(16) PRIMARY KEY);
 
CREATE TABLE ShopItems
(shop VARCHAR(16),
 item VARCHAR(16),
    PRIMARY KEY(shop, item));

INSERT INTO Items VALUES('�r�[��');
INSERT INTO Items VALUES('���I���c');
INSERT INTO Items VALUES('���]��');

INSERT INTO ShopItems VALUES('���',  '�r�[��');
INSERT INTO ShopItems VALUES('���',  '���I���c');
INSERT INTO ShopItems VALUES('���',  '���]��');
INSERT INTO ShopItems VALUES('���',  '�J�[�e��');
INSERT INTO ShopItems VALUES('����',  '�r�[��');
INSERT INTO ShopItems VALUES('����',  '���I���c');
INSERT INTO ShopItems VALUES('����',  '���]��');
INSERT INTO ShopItems VALUES('���',  '�e���r');
INSERT INTO ShopItems VALUES('���',  '���I���c');
INSERT INTO ShopItems VALUES('���',  '���]��');
