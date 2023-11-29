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

--ALTER TABLE + 테이블 이름 + ADD : 테이블(db객체)를 수정해줘!! 그런데 여기 ADD부터 할 것인데 객체를
--수정핼때, 테이블 안에 들어가 있는 것이 각각의 열들이기 때문에 테이블에 대해서 수정한다는 것은 컬럼을 
--추가도 되고 컬럼변경도 되고 컬럼 삭제도 된다는 의미이다. 그 중에서 추가하는 것 부터 해보겠다. 
--
-- .새로운 열 추가 가능
-- .ADD를 사용해서 기존 열 제거 불가능
-- .열의 위치 지정 불가능 (ADD는 기존의 테이블의 열 뒷부분에 추가하는 것이다.)
-- .새로운 열의 데이터 값은 null

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
--테이블에 있는 컬럼에 대해서 "제약조건"을 추가할 수도 있다.

--ALTER TABLE 테이블이름
--ADD CONSTRAINT 제약조건이름
--CHECK (조건지정);

ALTER TABLE customers
ADD CONSTRAINT AK_email
UNIQUE (email);

ALTER TABLE customers
ADD CONSTRAINT AK_phone
UNIQUE (phone_number);
--UNIQUE 명령어로 컬럼의 제약조건을 유일하다고 설정할 수 있다.

ALTER TABLE customers
ADD CONSTRAINT CK_age
CHECK (age >= 0);
--CHECK 명령어로 특정 컬럼의 제약조건을 설정할 수 있다.


--ALTER TABLE MODIFY : 기존에 있던 테이블의 기존에 있던 열의 데이터타입을 수정한다.
--
--사용법 : 
--ALTER TABLE 테이블이름
--MODIFY(
--    컬럼명 데이터타입,
--    컬럼명 데이터타입,
--       ...  ,
--    컬럼명 데이터타입
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
--기존의 age의 데이터타입은 NUMBER인데 데이터타입은 유지시키고 ALTER TABLE MODIFY를 통해서
--기본값(DEFAULT)을 지정할 수 있다. 지정 안하고 데이터 삽입 안 할시에는 NULL로 채워진다.
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
--기존에 있던 테이블의 기존에 있던 열이름을 변경한다.
--
--사용법 :
--ALTER TABLE 테이블이름
--RENAME COLUMN 열이름 TO 새로운 열이름
-- => 테이블의 열 이름 변경

ALTER TABLE customers
RENAME COLUMN phone_number TO phone;
ALTER TABLE customers
RENAME COLUMN gender TO sex;
ALTER TABLE customers
RENAME COLUMN dob TO date_of_birth;

SELECT * FROM customers;

--사용법 : 
--ALTER TABLE 테이블명
--DROP COLUMN 컬럼명

--ALTER TABLE 테이블명
--DROP CONSTRAINT 컬럼에 해당하는 제약조건 객체 명(제약조건도 하나의 객체이다.)
--=> 테이블의 열/제약조건 삭제

ALTER TABLE customers
DROP COLUMN date_of_birth;
ALTER TABLE customers
DROP COLUMN sex;
ALTER TABLE customers
DROP CONSTRAINT CK_age;

--TRANCATE/DROP TABLE
--사용법:
--TRANCATE TABLE 테이블이름
--지금까지는 열에 대해서만 추가하거나 삭제하거나 수정을 했는데 
--이제는 테이블 안에 있는 모든 데이터 자체를 삭제해 보겠다. 
--테이블 안에 있는 데이터는 삭제하는데 테이블 구조는 유지한다. 
TRUNCATE TABLE customers;
SELECT * FROM customers;
--사용법:
--DROP TABLE 테이블이름
--테이블 완전삭제, 테이블의 모든 데이터 뿐만 아니라 구조도 제거 
--즉 테이블 자체를 완전히 없앤다. 그래서 그 테이블 안에 있던
--모든 인덱스와 제약조건도 삭제된다.
DROP TABLE customers;
SELECT * FROM customers;

--[실습]테이블 생성
--. products 테이블 생성
CREATE TABLE products(
    product_id      NUMBER          NOT NULL     PRIMARY KEY,
    product_name    VARCHAR2(10)    NOT NULL,
    reg_date        DATE
);
--. products 테이블에 데이터 삽입
INSERT INTO products VALUES(1, 'Computer', '21/01/01');
INSERT INTO products VALUES(2, 'Smartphone', '21/02/01');
INSERT INTO products VALUES(3, 'Television', '21/03/01');
SELECT * FROM products;

--[실습] 테이블 열/제약조건 추가
--. products 테이블에 열 추가
--컬럼weight 컬럼price 추가
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

--[실습] 테이블 데이터 수정
--. products 테이블에 데이터 수정
UPDATE products SET weight=10, price=1600000 WHERE product_id=1;
UPDATE products SET weight=0.2, price=1000000 WHERE product_id=2;
UPDATE products SET weight=20, price=2000000 WHERE product_id=3;
SELECT * FROM products;

--[실습] 테이블 열 수정/테이블 삭제
--. products 테이블에 열 수정
ALTER TABLE products
RENAME COLUMN reg_date TO regist_date;
ALTER TABLE products
MODIFY(
    product_name VARCHAR2(30)
);
SELECT * FROM products;
--. products 테이블의 열 삭제
ALTER TABLE products
DROP COLUMN weight;
SELECT * FROM products;
--. products 테이블의 모든 데이터 삭제
TRUNCATE TABLE products;
SELECT * FROM products;
--. products 테이블 삭제
DROP TABLE products;
SELECT * FROM products;