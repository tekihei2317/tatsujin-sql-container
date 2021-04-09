-- �����E��ށE����ێ�
CREATE TABLE Sales
(year INTEGER NOT NULL , 
 sale INTEGER NOT NULL ,
 PRIMARY KEY (year));

INSERT INTO Sales VALUES (1990, 50);
INSERT INTO Sales VALUES (1991, 51);
INSERT INTO Sales VALUES (1992, 52);
INSERT INTO Sales VALUES (1993, 52);
INSERT INTO Sales VALUES (1994, 50);
INSERT INTO Sales VALUES (1995, 50);
INSERT INTO Sales VALUES (1996, 49);
INSERT INTO Sales VALUES (1997, 55);

-- ���n��Ɏ�����������ꍇ�F���߂Ɣ�r
CREATE TABLE Sales2
(year INTEGER NOT NULL , 
 sale INTEGER NOT NULL , 
 PRIMARY KEY (year));

INSERT INTO Sales2 VALUES (1990, 50);
INSERT INTO Sales2 VALUES (1992, 50);
INSERT INTO Sales2 VALUES (1993, 52);
INSERT INTO Sales2 VALUES (1994, 55);
INSERT INTO Sales2 VALUES (1997, 55);


-- �O�N�ƔN���������N�x�����߂�F����1�@���փT�u�N�G���̗��p
SELECT year,sale
  FROM Sales S1
 WHERE sale = (SELECT sale
                 FROM Sales S2
                WHERE S2.year = S1.year - 1)
 ORDER BY year;


-- �O�N�ƔN���������N�x�����߂�F����2�@�E�B���h�E�֐��̗��p
SELECT year, current_sale
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                               RANGE BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales) TMP
 WHERE current_sale = pre_sale
 ORDER BY year;

SELECT year,
       sale AS current_sale,
       SUM(sale) OVER (ORDER BY year
                       RANGE BETWEEN 1 PRECEDING
                                 AND 1 PRECEDING) AS pre_sale
  FROM Sales;


-- �����A��ށA����ێ�����x�ɋ��߂�F����1�@���փT�u�N�G���̗��p
SELECT year, current_sale AS sale,
       CASE WHEN current_sale = pre_sale
              THEN '��'
            WHEN current_sale > pre_sale
              THEN '��'
            WHEN current_sale < pre_sale
              THEN '��'
            ELSE '-' END AS var
  FROM (SELECT year,
               sale AS current_sale,
               (SELECT sale
                  FROM Sales S2
                 WHERE S2.year = S1.year - 1) AS pre_sale
          FROM Sales S1) TMP
 ORDER BY year;


-- �����A��ށA����ێ�����x�ɋ��߂�F����2�@�E�B���h�E�֐��̗��p
SELECT year, current_sale AS sale,
       CASE WHEN current_sale = pre_sale
             THEN '��'
            WHEN current_sale > pre_sale
             THEN '��'
            WHEN current_sale < pre_sale
             THEN '��'
            ELSE '-' END AS var
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                               RANGE BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales) TMP
 ORDER BY year;




-- ���߂̔N�Ɠ����N���̔N��I������F����1�@���փT�u�N�G��
SELECT year, sale
  FROM Sales2 S1
 WHERE sale =
         (SELECT sale
            FROM Sales2 S2
           WHERE S2.year =
                  (SELECT MAX(year) -- ����2�F����1�𖞂����N�x�̒��ōő�
                     FROM Sales2 S3
                    WHERE S1.year > S3.year)) -- ����1�F�������ߋ��ł���
 ORDER BY year;


-- ���߂̔N�Ɠ����N���̔N��I������F����2�@�E�B���h�E�֐�
SELECT year, current_sale
  FROM (SELECT year,
               sale AS current_sale,
               SUM(sale) OVER (ORDER BY year
                                ROWS BETWEEN 1 PRECEDING
                                         AND 1 PRECEDING) AS pre_sale
          FROM Sales2) TMP
         WHERE current_sale = pre_sale
 ORDER BY year;




-- �I�[�o�[���b�v������Ԃ𒲂ׂ�
CREATE TABLE Reservations
(reserver    VARCHAR(30) PRIMARY KEY,
 start_date  DATE  NOT NULL,
 end_date    DATE  NOT NULL);

INSERT INTO Reservations VALUES('�ؑ�', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('�r��', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('�x',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('�R�{', '2018-11-03', '2018-11-04');
INSERT INTO Reservations VALUES('���c', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('���J', '2018-11-06', '2018-11-06');

--�R�{���̓��h����4���̏ꍇ
DELETE FROM Reservations WHERE reserver = '�R�{';
INSERT INTO Reservations VALUES('�R�{', '2018-11-04', '2018-11-04');


-- �I�[�o�[���b�v������Ԃ����߂�  ����1�F���փT�u�N�G���̗��p
SELECT reserver, start_date, end_date
  FROM Reservations R1
 WHERE EXISTS
        (SELECT *
           FROM Reservations R2
          WHERE R1.reserver <> R2.reserver -- �����ȊO�̋q�Ɣ�r����
            AND ( R1.start_date BETWEEN R2.start_date AND R2.end_date
                   -- ����(1)�F�J�n�������̊��ԓ��ɂ���
               OR R1.end_date BETWEEN R2.start_date AND R2.end_date));
                   -- ����(2)�F�I���������̊��ԓ��ɂ���


-- �I�[�o�[���b�v������Ԃ����߂�  ����2�F�E�B���h�E�֐��̗��p
SELECT reserver, next_reserver
  FROM (SELECT reserver,
               start_date,
               end_date,
               MAX(start_date) OVER (ORDER BY start_date
                                      ROWS BETWEEN 1 FOLLOWING 
                                               AND 1 FOLLOWING) AS next_start_date,
               MAX(reserver)   OVER (ORDER BY start_date
                                      ROWS BETWEEN 1 FOLLOWING 
                                               AND 1 FOLLOWING) AS next_reserver
          FROM Reservations) TMP
 WHERE next_start_date BETWEEN start_date AND end_date;



--�R�{�E���c�E���J��3�l���d��
DELETE FROM Reservations;
INSERT INTO Reservations VALUES('�ؑ�', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('�r��', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('�x',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('�R�{', '2018-11-03', '2018-11-04');
INSERT INTO Reservations VALUES('���c', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('���J', '2018-11-04', '2018-11-06');


--�R�{�����u���A��v�œo�^(���փT�u�N�G���̌��ʂ�����c����������)
DELETE FROM Reservations;
INSERT INTO Reservations VALUES('�ؑ�', '2018-10-26', '2018-10-27');
INSERT INTO Reservations VALUES('�r��', '2018-10-28', '2018-10-31');
INSERT INTO Reservations VALUES('�x',   '2018-10-31', '2018-11-01');
INSERT INTO Reservations VALUES('�R�{', '2018-11-04', '2018-11-04');
INSERT INTO Reservations VALUES('���c', '2018-11-03', '2018-11-05');
INSERT INTO Reservations VALUES('���J', '2018-11-06', '2018-11-06');


--���K���F1-6
CREATE TABLE Accounts
(prc_date DATE NOT NULL , 
 prc_amt  INTEGER NOT NULL , 
 PRIMARY KEY (prc_date)) ;

DELETE FROM Accounts;
INSERT INTO Accounts VALUES ('2018-10-26',  12000 );
INSERT INTO Accounts VALUES ('2018-10-28',   2500 );
INSERT INTO Accounts VALUES ('2018-10-31', -15000 );
INSERT INTO Accounts VALUES ('2018-11-03',  34000 );
INSERT INTO Accounts VALUES ('2018-11-04',  -5000 );
INSERT INTO Accounts VALUES ('2018-11-06',   7200 );
INSERT INTO Accounts VALUES ('2018-11-11',  11000 );

