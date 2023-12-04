-- SELECT INDEX
-- . 인덱스 조회
    SELECT * 
    FROM user_indexes;
    --*어떤 인덱스가 있는지 조회할때 쓰인다.*
    ---기본으로 DBMS에서 제공하는 사용자의 인덱스 정보만 가지고 있는 테이블 => user_indexes와 같은 시스템 테이블이 여럿 존재한다.
    SELECT *
    FROM user_indexes
    WHERE table_name='EMPLOYEES';
    -- EMPLOYEES테이블에 대한 인덱스만 조회하는 것이다. (EMPLOYEES테이블의 어떤 컬럼들로 인덱스 테이블이 구성되어 있는지는 나오지 않는다.)
    -- => 인덱스가 6개나 존재한다. 인덱스는 테이블의 컬럼 한개를 의미하는 것이 아니라 인덱스 자체로 하나의 테이블을 이루는 것이다. 
    --    그리고 대상 테이블에 적용되는 각각의 인덱스 테이블은 대상테이블에 있는 컬럼을 1개이상 가지고 있다. 인덱스 테이블을 이루는
    --    대상 테이블의 컬럼을 보고 싶으면 user_indexes에서는 볼 수 없고 대상 테이블의 속성을 확인하면 된다.
    --    (대상 테이블 더블 클릭 후 인덱스 탭 보기) 
    
    --. 인덱스 컬럼 조회
    SELECT * 
    FROM user_ind_columns;
    --인덱스가 사용하는 컬럼정보를 조회할 수 있다.
    SELECT *
    FROM user_ind_columns
    WHERE table_name='EMPLOYEES';
    --EMPLOYEES테이블에 적용되는 각각의 인덱스가 가지고 있는 EMPLOYEES테이블의 컬럼(들)을 확인할 수 있다. 
    --=> EMPLOYEES테이블의 인덱스가 가지고 있는 컬럼을 확인할수 있다. 
    
    --. 인덱스 사용 여부
    SELECT *
    FROM employees
    WHERE employee_id=100;
    
    SELECT *
    FROM employees
    WHERE first_name = 'Steven';
    
--SEELECT INDEX
    --이번에는 실제 우리도 테이블을 만들고 그 테이블에서 인덱스를 구축해서 우리가 원하는 인덱스 형태를 생성해 보겠다.
    --. 예제 테이블 customers 생성
    CREATE TABLE customers(
        customer_id         NUMBER          NOT NULL      PRIMARY KEY, -- PRIMAY KEY 선언은 인덱스를 만들어 준다.
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
    --. customers 테이블 인덱스 조회
    SELECT * FROM customers;
    SELECT * FROM user_indexes WHERE table_name='CUSTOMERS';
    --인덱스를 따로 생성하지 않았는데 우리가 PRIMARY KEY로 넣었던 인덱스가 자동으로 생성된 것을 확인할 수 있다.
    --PRIMARY KEY는 자동으로 인덱스로 생성되기 때문에 인덱스 이름을 시스템에서 일괄적으로 특정 이름으로 설정해서 생성한다. 
    
--CREATE INDEX
    --이번에는 우리가 필요한 인덱스를 만들어 보자! 예를들어서 customer가 언제 등록을 했는지에 따라서 
    --검색하는 경우가 많다고 가정 했을때, 즉, regist_date컬럼을 기준(SELECT * FROM customers WHERE regist_date='21/01/01';)으로
    --뭔가 검색하는 것이 많다면 인덱스를 만들어서 성능상의 이점을 갖을 수 있다.
    --. 인덱스 생성
    CREATE INDEX regist_date_idx
    ON customers(regist_date);
    --=> 인덱스 생성이 끝난것이다.
    SELECT * FROM user_indexes WHERE table_name = 'CUSTOMERS';
    --조회시 없었던 REGIST_DATE_IDX라는 인덱스가 추가된 것을 알 수 있다. 이것은 NONUNIQUE이다. 
    --당연하게도 동일 날짜에 여러명의 고객이 등록 가능하기 떄문이다. 
    SELECT * FROM customers WHERE regist_date = '21/01/01';
    --실행계획을 보면 날짜이기 때문에 REGIST_DATE_IDX는 RANGE SCAN을 한다. 
    
--CREATE UNIQUE INDEX
--. 고유 인덱스 생성
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
    --인덱스는 생성과 삭제에 다른테이블에 영향을 주고 있지 않다. 그래서 쉽게 삭제하거나 다시 생성하거나 하는 것이 가능하다.
    --이제 인덱스를 삭제해 보자 
    --. 인덱스 삭제
    SELECT * 
    FROM user_indexes
    WHERE table_name = 'CUSTOMERS';
    --
    --DROP INDEX regist_date_idx;
    --DROP INDEX email_idx;
    --unique 하다고 해서 DROP UNIQUE INDEX 이렇게 할 필요 없다. 
    --DROP INDEX phone_idx;
    --
    --. 테이블 삭제
    --DROP TABLE customers;
    --테이블을 삭제하면 테이블에 포함되어 있던 인덱스(들)도 사실은 전부 연달아서 삭제가 된다. 
    --인덱스는 테이블의 컬럼을 대상으로 만들어 지기 때문에 TABLE객체 안에 INDEX객체가 포함되어 있다고 봐야 한다.

--[실습] 테이블 생성 및 데이터 삽입
--. products 테이블 생성 
CREATE TABLE products(
    product_id          NUMBER          NOT NULL         PRIMARY KEY,
    product_name        VARCHAR2(10)    NOT NULL,
    reg_date            DATE,
    weight              NUMBER,
    price               NUMBER
);
--. products 데이터 삽입
INSERT INTO products VALUES(1, 'Computer', '21/01/01', 10, 1600000);
INSERT INTO products VALUES(2, 'Smartphone', '21/02/02', 0.2, 1000000);
INSERT INTO products VALUES(3, 'Television', '21/03/01', 20, 2000000);
--[실습] 인덱스 생성
--. products 테이블의 reg_date 컬럼에 대한 인덱스 reg_date_idx 생성
CREATE INDEX reg_date_idx
ON products(reg_date);
--. products 테이블의 weight 컬럼에 대한 인덱스 weight_idx 생성 
CREATE INDEX weight_idx
ON products(weight);
--. products 테이블의 price 컬럼에 대한 인덱스 price_idx 생성
CREATE INDEX price_idx
ON products(price);
--. products 테이블의 product_name 컬럼에 대한 고유 인덱스 product_name_idx 생성 
CREATE UNIQUE INDEX product_name_idx
ON products(product_name);
--. products 테이블에 대한 사용자 인덱스 조회
SELECT * FROM user_indexes WHERE table_name = 'PRODUCTS';
--. products 테이블에 대한 사용자 인덱스 컬럼 조회
SELECT * FROM user_ind_columns WHERE table_name = 'PRODUCTS';

--[실습] 인덱스/테이블 삭제
--. products 테이블의 reg_date_idx 인덱스 삭제
DROP INDEX reg_date_idx;
--. products 테이블의 weight_idx 인덱스 삭제
DROP INDEX weight_idx;
--. products 테이블의 price_idx 인덱스 삭제
DROP INDEX price_idx;
--. products 테이블의 product_name_idx 인덱스 삭제
DROP INDEX product_name_idx;
SELECT * FROM user_ind_columns WHERE table_name = 'PRODUCTS';
--. products 테이블 삭제
DROP TABLE products;



























