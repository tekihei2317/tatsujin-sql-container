CREATE TABLE Products (
  name VARCHAR(16) PRIMARY KEY,
  price INTEGER NOT NULL
);

--�d������E����E�g�ݍ��킹
DELETE FROM
  Products;

INSERT INTO
  Products
VALUES
  ('���', 100);

INSERT INTO
  Products
VALUES
  ('�݂���', 50);

INSERT INTO
  Products
VALUES
  ('�o�i�i', 80);

CREATE TABLE Products (
  name VARCHAR(16) NOT NULL,
  price INTEGER NOT NULL
);

--�d�����郌�R�[�h
INSERT INTO
  Products
VALUES
  ('���', 50);

INSERT INTO
  Products
VALUES
  ('�݂���', 100);

INSERT INTO
  Products
VALUES
  ('�݂���', 100);

INSERT INTO
  Products
VALUES
  ('�݂���', 100);

INSERT INTO
  Products
VALUES
  ('�o�i�i', 80);

--�����I�ɕs��v�ȃL�[�̌���
CREATE TABLE Addresses (
  name VARCHAR(32),
  family_id INTEGER,
  address VARCHAR(32),
  PRIMARY KEY(name, family_id)
);

INSERT INTO
  Addresses
VALUES
  ('�O�c �`��', '100', '�����s�`��Ճm��3-2-29');

INSERT INTO
  Addresses
VALUES
  ('�O�c �R��', '100', '�����s�`��Ճm��3-2-92');

INSERT INTO
  Addresses
VALUES
  ('���� ��', '200', '�����s�V�h�搼�V�h2-8-1');

INSERT INTO
  Addresses
VALUES
  ('���� ��', '200', '�����s�V�h�搼�V�h2-8-1');

INSERT INTO
  Addresses
VALUES
  ('�z�[���Y', '300', '�x�[�J�[�X221B');

INSERT INTO
  Addresses
VALUES
  ('���g�\��', '400', '�x�[�J�[�X221B');

DELETE FROM
  Products;

INSERT INTO
  Products
VALUES
  ('���', 50);

INSERT INTO
  Products
VALUES
  ('�݂���', 100);

INSERT INTO
  Products
VALUES
  ('�Ԃǂ�', 50);

INSERT INTO
  Products
VALUES
  ('�X�C�J', 80);

INSERT INTO
  Products
VALUES
  ('������', 30);

INSERT INTO
  Products
VALUES
  ('������', 100);

INSERT INTO
  Products
VALUES
  ('�o�i�i', 100);