-- SELECT INDEX
-- . �ε��� ��ȸ
    SELECT * 
    FROM user_indexes;
    --*� �ε����� �ִ��� ��ȸ�Ҷ� ���δ�.*
    ---�⺻���� DBMS���� �����ϴ� ������� �ε��� ������ ������ �ִ� ���̺� => user_indexes�� ���� �ý��� ���̺��� ���� �����Ѵ�.
    SELECT *
    FROM user_indexes
    WHERE table_name='EMPLOYEES';
    -- EMPLOYEES���̺� ���� �ε����� ��ȸ�ϴ� ���̴�. (EMPLOYEES���̺��� � �÷���� �ε��� ���̺��� �����Ǿ� �ִ����� ������ �ʴ´�.)
    -- => �ε����� 6���� �����Ѵ�. �ε����� ���̺��� �÷� �Ѱ��� �ǹ��ϴ� ���� �ƴ϶� �ε��� ��ü�� �ϳ��� ���̺��� �̷�� ���̴�. 
    --    �׸��� ��� ���̺� ����Ǵ� ������ �ε��� ���̺��� ������̺� �ִ� �÷��� 1���̻� ������ �ִ�. �ε��� ���̺��� �̷��
    --    ��� ���̺��� �÷��� ���� ������ user_indexes������ �� �� ���� ��� ���̺��� �Ӽ��� Ȯ���ϸ� �ȴ�.
    --    (��� ���̺� ���� Ŭ�� �� �ε��� �� ����) 
    
    --. �ε��� �÷� ��ȸ
    SELECT * 
    FROM user_ind_columns;
    --�ε����� ����ϴ� �÷������� ��ȸ�� �� �ִ�.
    SELECT *
    FROM user_ind_columns
    WHERE table_name='EMPLOYEES';
    --EMPLOYEES���̺� ����Ǵ� ������ �ε����� ������ �ִ� EMPLOYEES���̺��� �÷�(��)�� Ȯ���� �� �ִ�. 
    --=> EMPLOYEES���̺��� �ε����� ������ �ִ� �÷��� Ȯ���Ҽ� �ִ�. 
    
    --. �ε��� ��� ����
    SELECT *
    FROM employees
    WHERE employee_id=100;
    
    SELECT *
    FROM employees
    WHERE first_name = 'Steven';
    
--SEELECT INDEX
    --�̹����� ���� �츮�� ���̺��� ����� �� ���̺��� �ε����� �����ؼ� �츮�� ���ϴ� �ε��� ���¸� ������ ���ڴ�.
    --. ���� ���̺� customers ����
    CREATE TABLE customers(
        customer_id         NUMBER          NOT NULL      PRIMARY KEY, -- PRIMAY KEY ������ �ε����� ����� �ش�.
        first_name          VARCHAR2(10)    NOT NULL,
        last_name           VARCHAR2(10)    NOT NULL,
        email               VARCHAR2(10),
        phone_number        VARCHAR2(20),
        regist_date         date
    );
    INSERT INTO customers VALUES(1, 'Suan', 'Lee', 'suan', '010-1234-1234', '21/01/01');
    INSERT INTO customers VALUES(2, 'Elon', 'Musk', 'elon', '010-1111-2222', '21/05/01');
    INSERT INTO customers VALUES(3, 'Steve', 'Jobs', 'steve', '010-3333-4444', '21/10/01');
    INSERT INTO customers VALUES(4, 'Bill', 'Gates', 'bill', '010-5555-6666', '21/11/01');
    INSERT INTO customers VALUES(5, 'Mark', 'Zuckerberg', 'mark', '010-7777-8888', '21/12/01');
    --. customers ���̺� �ε��� ��ȸ
    SELECT * FROM customers;
    SELECT * FROM user_indexes WHERE table_name='CUSTOMERS';
    --�ε����� ���� �������� �ʾҴµ� �츮�� PRIMARY KEY�� �־��� �ε����� �ڵ����� ������ ���� Ȯ���� �� �ִ�.
    --PRIMARY KEY�� �ڵ����� �ε����� �����Ǳ� ������ �ε��� �̸��� �ý��ۿ��� �ϰ������� Ư�� �̸����� �����ؼ� �����Ѵ�. 
    
--CREATE INDEX
    --�̹����� �츮�� �ʿ��� �ε����� ����� ����! ������ customer�� ���� ����� �ߴ����� ���� 
    --�˻��ϴ� ��찡 ���ٰ� ���� ������, ��, regist_date�÷��� ����(SELECT * FROM customers WHERE regist_date='21/01/01';)����
    --���� �˻��ϴ� ���� ���ٸ� �ε����� ���� ���ɻ��� ������ ���� �� �ִ�.
    --. �ε��� ����
    CREATE INDEX regist_date_idx
    ON customers(regist_date);
    --=> �ε��� ������ �������̴�.
    SELECT * FROM user_indexes WHERE table_name = 'CUSTOMERS';
    --��ȸ�� ������ REGIST_DATE_IDX��� �ε����� �߰��� ���� �� �� �ִ�. �̰��� NONUNIQUE�̴�. 
    --�翬�ϰԵ� ���� ��¥�� �������� ���� ��� �����ϱ� �����̴�. 
    SELECT * FROM customers WHERE regist_date = '21/01/01';
    --�����ȹ�� ���� ��¥�̱� ������ REGIST_DATE_IDX�� RANGE SCAN�� �Ѵ�. 
    
--CREATE UNIQUE INDEX
--. ���� �ε��� ����
CREATE UNIQUE INDEX email_idx
ON customers (email);

SELECT * 
FROM user_indexes
WHERE table_name = 'CUSTOMERS';

SELECT *
FROM customers
WHERE email = 'suan';

CREATE UNIQUE INDEX phone_idx
ON customers(phone_number);

SELECT * 
FROM user_indexes
WHERE table_name = 'CUSTOMERS';

SELECT *
FROM customers
WHERE phone_number = '010-1234-1234';

--DROP INDEX / TABLE
    --�ε����� ������ ������ �ٸ����̺� ������ �ְ� ���� �ʴ�. �׷��� ���� �����ϰų� �ٽ� �����ϰų� �ϴ� ���� �����ϴ�.
    --���� �ε����� ������ ���� 
    --. �ε��� ����
    SELECT * 
    FROM user_indexes
    WHERE table_name = 'CUSTOMERS';
    --
    --DROP INDEX regist_date_idx;
    --DROP INDEX email_idx;
    --unique �ϴٰ� �ؼ� DROP UNIQUE INDEX �̷��� �� �ʿ� ����. 
    --DROP INDEX phone_idx;
    --
    --. ���̺� ����
    --DROP TABLE customers;
    --���̺��� �����ϸ� ���̺� ���ԵǾ� �ִ� �ε���(��)�� ����� ���� ���޾Ƽ� ������ �ȴ�. 
    --�ε����� ���̺��� �÷��� ������� ����� ���� ������ TABLE��ü �ȿ� INDEX��ü�� ���ԵǾ� �ִٰ� ���� �Ѵ�.

--[�ǽ�] ���̺� ���� �� ������ ����
--. products ���̺� ���� 
CREATE TABLE products(
    product_id          NUMBER          NOT NULL         PRIMARY KEY,
    product_name        VARCHAR2(10)    NOT NULL,
    reg_date            DATE,
    weight              NUMBER,
    price               NUMBER
);
--. products ������ ����
INSERT INTO products VALUES(1, 'Computer', '21/01/01', 10, 1600000);
INSERT INTO products VALUES(2, 'Smartphone', '21/02/02', 0.2, 1000000);
INSERT INTO products VALUES(3, 'Television', '21/03/01', 20, 2000000);
--[�ǽ�] �ε��� ����
--. products ���̺��� reg_date �÷��� ���� �ε��� reg_date_idx ����
CREATE INDEX reg_date_idx
ON products(reg_date);
--. products ���̺��� weight �÷��� ���� �ε��� weight_idx ���� 
CREATE INDEX weight_idx
ON products(weight);
--. products ���̺��� price �÷��� ���� �ε��� price_idx ����
CREATE INDEX price_idx
ON products(price);
--. products ���̺��� product_name �÷��� ���� ���� �ε��� product_name_idx ���� 
CREATE UNIQUE INDEX product_name_idx
ON products(product_name);
--. products ���̺� ���� ����� �ε��� ��ȸ
SELECT * FROM user_indexes WHERE table_name = 'PRODUCTS';
--. products ���̺� ���� ����� �ε��� �÷� ��ȸ
SELECT * FROM user_ind_columns WHERE table_name = 'PRODUCTS';

--[�ǽ�] �ε���/���̺� ����
--. products ���̺��� reg_date_idx �ε��� ����
DROP INDEX reg_date_idx;
--. products ���̺��� weight_idx �ε��� ����
DROP INDEX weight_idx;
--. products ���̺��� price_idx �ε��� ����
DROP INDEX price_idx;
--. products ���̺��� product_name_idx �ε��� ����
DROP INDEX product_name_idx;
SELECT * FROM user_ind_columns WHERE table_name = 'PRODUCTS';
--. products ���̺� ����
DROP TABLE products;



























