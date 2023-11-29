CREATE TABLE customer(
    customer_id     NUMBER          NOT NULL     PRIMARY KEY,
    first_name      VARCHAR2(10)    NOT NULL,
    last_name       VARCHAR2(10)    NOT NULL,
    email           VARCHAR2(10),
    phone_number    VARCHAR2(20),
    reg_date        DATE
);

SELECT * FROM customer;

INSERT INTO customer VALUES(1, 'Suan', 'Lee', 'suan', '010-1234-1234', '21/01/01');
INSERT INTO customer VALUES(2, 'Elon', 'Musk', 'elon', '010-1111-2222', '21/05/01');
INSERT INTO customer VALUES(3, 'Steve', 'Jobs', 'steve', '010-3333-4444', '21/10/01');
INSERT INTO customer VALUES(4, 'Bill', 'Gates', 'bill', '010-5555-6666', '21/11/01');
INSERT INTO customer VALUES(5, 'Mark', 'Zuckerberg', 'mark', '010-7777-8888', '21/12/01');

--ALTER TABLE + ���̺� �̸� + ADD : ���̺�(db��ü)�� ��������!! �׷��� ���� ADD���� �� ���ε� ��ü��
--�����۶�, ���̺� �ȿ� �� �ִ� ���� ������ �����̱� ������ ���̺� ���ؼ� �����Ѵٴ� ���� �÷��� 
--�߰��� �ǰ� �÷����浵 �ǰ� �÷� ������ �ȴٴ� �ǹ��̴�. �� �߿��� �߰��ϴ� �� ���� �غ��ڴ�. 
--
-- .���ο� �� �߰� ����
-- .ADD�� ����ؼ� ���� �� ���� �Ұ���
-- .���� ��ġ ���� �Ұ��� (ADD�� ������ ���̺��� �� �޺κп� �߰��ϴ� ���̴�.)
-- .���ο� ���� ������ ���� null

ALTER TABLE customer
ADD(
    gender VARCHAR(10)
);

ALTER TABLE customer
ADD(
    age NUMBER,
    dob DATE
);

SELECT * FROM customer;
ALTER TABLE customer RENAME TO customers;
SELECT * FROM customer;
SELECT * FROM customers;

UPDATE customers
SET 
    gender = 'male',
    age = 20,
    dob = '09/01/01'

WHERE customer_id = 1;
UPDATE customers
SET
    gender = 'male',
    age = 40, 
    dob = '89/01/01'

WHERE customer_id = 2;
UPDATE customers
SET
    gender = 'male',
    age = 30,
    dob = '99/01/01'

WHERE customer_id = 5;

SELECT * FROM customers;


--ALTER TABLE ADD CONSTRAINT
--���̺� �ִ� �÷��� ���ؼ� "��������"�� �߰��� ���� �ִ�.

--ALTER TABLE ���̺��̸�
--ADD CONSTRAINT ���������̸�
--CHECK (��������);

ALTER TABLE customers
ADD CONSTRAINT AK_email
UNIQUE (email);

ALTER TABLE customers
ADD CONSTRAINT AK_phone
UNIQUE (phone_number);
--UNIQUE ��ɾ�� �÷��� ���������� �����ϴٰ� ������ �� �ִ�.

ALTER TABLE customers
ADD CONSTRAINT CK_age
CHECK (age >= 0);
--CHECK ��ɾ�� Ư�� �÷��� ���������� ������ �� �ִ�.


--ALTER TABLE MODIFY : ������ �ִ� ���̺��� ������ �ִ� ���� ������Ÿ���� �����Ѵ�.
--
--���� : 
--ALTER TABLE ���̺��̸�
--MODIFY(
--    �÷��� ������Ÿ��,
--    �÷��� ������Ÿ��,
--       ...  ,
--    �÷��� ������Ÿ��
--);

ALTER TABLE customers
MODIFY (
    first_name VARCHAR2(30)
);
ALTER TABLE customers
MODIFY (
    last_name VARCHAR2(30)
);
ALTER TABLE customers
MODIFY (
    age DEFAULT(0)
);
--������ age�� ������Ÿ���� NUMBER�ε� ������Ÿ���� ������Ű�� ALTER TABLE MODIFY�� ���ؼ�
--�⺻��(DEFAULT)�� ������ �� �ִ�. ���� ���ϰ� ������ ���� �� �ҽÿ��� NULL�� ä������.
SELECT * FROM customers;

UPDATE customers
SET first_name = 'Steven Paul', gender = 'male', age = 50, dob = '50/01/01'
WHERE customer_id = 3;
UPDATE customers
SET first_name = 'William Henry', gender = 'male', age = 40, dob = '89/01/01'
WHERE customer_id = 4;

INSERT INTO customers(customer_id, first_name, last_name, email) VALUES(6, 'Lawrence Edward', 'Page', 'larry');

SELECT * FROM customers;


--ALTER TABLE RENAME/DROP COLUMN
--������ �ִ� ���̺��� ������ �ִ� ���̸��� �����Ѵ�.
--
--���� :
--ALTER TABLE ���̺��̸�
--RENAME COLUMN ���̸� TO ���ο� ���̸�
-- => ���̺��� �� �̸� ����

ALTER TABLE customers
RENAME COLUMN phone_number TO phone;
ALTER TABLE customers
RENAME COLUMN gender TO sex;
ALTER TABLE customers
RENAME COLUMN dob TO date_of_birth;

SELECT * FROM customers;

--���� : 
--ALTER TABLE ���̺��
--DROP COLUMN �÷���

--ALTER TABLE ���̺��
--DROP CONSTRAINT �÷��� �ش��ϴ� �������� ��ü ��(�������ǵ� �ϳ��� ��ü�̴�.)
--=> ���̺��� ��/�������� ����

ALTER TABLE customers
DROP COLUMN date_of_birth;
ALTER TABLE customers
DROP COLUMN sex;
ALTER TABLE customers
DROP CONSTRAINT CK_age;

--TRANCATE/DROP TABLE
--����:
--TRANCATE TABLE ���̺��̸�
--���ݱ����� ���� ���ؼ��� �߰��ϰų� �����ϰų� ������ �ߴµ� 
--������ ���̺� �ȿ� �ִ� ��� ������ ��ü�� ������ ���ڴ�. 
--���̺� �ȿ� �ִ� �����ʹ� �����ϴµ� ���̺� ������ �����Ѵ�. 
TRUNCATE TABLE customers;
SELECT * FROM customers;
--����:
--DROP TABLE ���̺��̸�
--���̺� ��������, ���̺��� ��� ������ �Ӹ� �ƴ϶� ������ ���� 
--�� ���̺� ��ü�� ������ ���ش�. �׷��� �� ���̺� �ȿ� �ִ�
--��� �ε����� �������ǵ� �����ȴ�.
DROP TABLE customers;
SELECT * FROM customers;

--[�ǽ�]���̺� ����
--. products ���̺� ����
CREATE TABLE products(
    product_id      NUMBER          NOT NULL     PRIMARY KEY,
    product_name    VARCHAR2(10)    NOT NULL,
    reg_date        DATE
);
--. products ���̺� ������ ����
INSERT INTO products VALUES(1, 'Computer', '21/01/01');
INSERT INTO products VALUES(2, 'Smartphone', '21/02/01');
INSERT INTO products VALUES(3, 'Television', '21/03/01');
SELECT * FROM products;

--[�ǽ�] ���̺� ��/�������� �߰�
--. products ���̺� �� �߰�
--�÷�weight �÷�price �߰�
ALTER TABLE products
ADD ( 
    weight NUMBER,
--    price NUMBER  price >= 0
    price NUMBER
);
ALTER TABLE products
ADD CONSTRAINT AK_weight
CHECK(
    weight >= 0
);
ALTER TABLE products
ADD CONSTRAINT AK_price
CHECK(
    price >= 0
);
SELECT * FROM products;

--[�ǽ�] ���̺� ������ ����
--. products ���̺� ������ ����
UPDATE products SET weight=10, price=1600000 WHERE product_id=1;
UPDATE products SET weight=0.2, price=1000000 WHERE product_id=2;
UPDATE products SET weight=20, price=2000000 WHERE product_id=3;
SELECT * FROM products;

--[�ǽ�] ���̺� �� ����/���̺� ����
--. products ���̺� �� ����
ALTER TABLE products
RENAME COLUMN reg_date TO regist_date;
ALTER TABLE products
MODIFY(
    product_name VARCHAR2(30)
);
SELECT * FROM products;
--. products ���̺��� �� ����
ALTER TABLE products
DROP COLUMN weight;
SELECT * FROM products;
--. products ���̺��� ��� ������ ����
TRUNCATE TABLE products;
SELECT * FROM products;
--. products ���̺� ����
DROP TABLE products;
SELECT * FROM products;