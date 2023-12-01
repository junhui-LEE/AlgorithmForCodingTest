SELECT * FROM emp_details_view;

--CREATE OR REPLACE VIEW
--. 뷰 생성 및 변경
--CREATE OR REPLACE VIEW 뷰이름
--AS
--    SELECT 질의
CREATE OR REPLACE VIEW emp_view
AS
    SELECT employee_id, first_name, last_name, email
    FROM employees;
SELECT * FROM emp_view;
CREATE OR REPLACE VIEW new_employee_view
AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id
    FROM employees
    WHERE employee_id > 206;
SELECT * FROM new_employee_view;
--뷰(view)는 단순히 select만 가능한 것이 아니라 데이터 삽입,수정,삭제가 가능하다. 그렇게
--삽입,수정,삭제 하려면 기본키인 employee_id가 뷰에 들어가 있어야 하는데 어찌되었던 우리가
--지금 기본키를 포함하고 있기 때문에 new_employee_view에 insert를 해보겠다.
INSERT INTO new_employee_view VALUES(207, 'Suan', 'Lee', 'suan', '21/01/01', 'IT_PROG');
SELECT * FROM new_employee_view;
--. 뷰 제거
DROP VIEW emp_view;
DROP VIEW new_employee_view;

--CREATE OR REPLACE VIEW
--. 읽기 전용 뷰 생성
--사용법 : 
--CREATE OR REPLACE VIEW 뷰이름
--AS
--    SELECT 질의
--    WITH READ ONLY;
--일반적인 뷰(View) 생성 대신에, 우리가 기본적인 뷰는 INSERT,UPDATE,DELETE문이 (제약이 있겠지만) 허용이 된다.
--그런데 읽기전용 뷰(View)는 말 그대로 읽기, SELECT 문만 허용되고 읽기 전용 뷰를 만드는 법은 그냥 WITH READ ONLY만
--마지막에 써주면 된다.
CREATE OR REPLACE VIEW salary_order_view
AS
    SELECT first_name, last_name, job_id, salary
    FROM employees
    ORDER BY salary DESC
    WITH READ ONLY;
SELECT * FROM salary_order_view;
INSERT INTO salary_order_view VALUES('Suan', 'Lee', 'IT_PROG', 10000);
--=> "읽기 저뇽ㅇ 뷰에는 DML 작업을 수행할 수 없습니다."라는 오류를 확인할 수 있다.
CREATE OR REPLACE VIEW job_salary_view
AS
    SELECT job_id, SUM(salary) sum_salary, MIN(salary) min_salary, MAX(salary) max_salary
    FROM employees
    GROUP BY job_id
    ORDER BY SUM(salary)
    WITH READ ONLY;
SELECT * FROM job_salary_view;
--. 뷰 제거
DROP VIEW salary_order_view;
DROP VIEW job_salary_view;

CREATE MATERIALIZED VIEW(부를때 보통 영어로 부른다)
. 뷰는 실체가 없고 SELECT문으로만 존재하며 실체가 없다. 그런데 "구체화된 뷰"는 실제 데이터가 존재한다. 그래서 이름이 "구체화된 뷰"이다.
사용법 :
CREATE MATERIALIZED VIEW 뷰이름
[
    BUILD {IMMEDIATE | DEFERRED}
    REFRESH {ON COMMIT | ON DEMAND} {FAST | COMPLETE | FORCE | NEVER}
    ENABLE QUERY REWRITE
]
AS
    SELECT 질의
--    [각각의 옵션 설명]
--    BUILD IMMEDIATE : "구체화된 뷰" 생성과 동시에 구체화된 뷰 내부에 데이터가 채워진다.
--    BUILD DEFERRED : 뷰 내부에 데이터가 나중에 채워진다. (지금은 데이터가 없지만 나중에 명령으로 데이터가 채워진다.)
--    REFRESH ON COMMIT : 원본테이블에 커밋이 발생할 때마다 구체화 된 뷰의 내용이 변경
--    REFRESH ON DEMAND : 직접 DBMS_MVIEW패키지를 실행해서 구체화된 뷰의 내용을 변경한다.(원본테이블에 커밋이 발생할때 명령을 시켜서 변경시키는 방법이다.)
--    . REFRESH는 우리가 테이블의 어떤 내용이 바뀌었을때, 즉 갱신되었을때, 
--      이 뷰(VIEW)가 참고하고 있는 특정 테이블에 내용이 변경이 된것을 
--      어떻게 구체화된 뷰에 반영할 지를 지정해 주는 옵션이다.
--    FAST, FORCE : 원본 테이블에 변경된 데이터만 구체화된 뷰에 적용시킨다.
--    COMPLETE : 원본 테이블이 변경되면 원본테이블의 데이터 전체를 구체화된 뷰에 적용
--    NEVER : 원본테이블이 변경되어도 구체화된 뷰에는 적용 안함
CREATE MATERIALIZED VIEW country_location_view
    BUILD DEFERRED
AS
    SELECT C.country_name, L.state_province, L.street_address
    FROM HR.countries C, HR.locations L
    WHERE C.country_id = L.country_id;
--권한이 불출하다는 오류메시지를 확인할 수 있다. HR스키마의 계정(세션)에는 MATERIALIZED VIEW를 
--생성하는 권한이 없기 때문에 sysdba권한을 가지고 있는 oracle스키마의 계정으로 들어가서 실행시켰다.
--=> 처음에 우리가 sysdba계정을 통해서 hr계정과 oracle계정을 활성화 시켰고, oracle계정에는
--sysdba권한도 부여했다. => oracle스키마의 구체화된 뷰 폴더를 보면 country_location_view;가 
--생성된 것을 확인할 수 있다.
--EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');
SELECT * FROM country_location_view;
--BUILD DEFERRED 옵션이 있기 때문에 데이터가 지금 없다. 이때 데이터를 채워 넣기 위해서 DBMS_MVIEW 패키지 안에 있는 REFRESH(프로시저 명)라는 명령어(기능)을 사용해야 한다.
EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');
SELECT * FROM country_location_view;
DROP MATERIALIZED VIEW country_location_view;

--CREATE MATERIALIZED VIEW
--구체화된 뷰 생성
CREATE MATERIALIZED VIEW country_location_view
    BUILD IMMEDIATE -- 구체화된 뷰 생성 후, 동시에 구체화된 내부에 데이터가 채워짐
    REFRESH ON DEMAND COMPLETE -- 직접 DBMS_MVIEW패키지를 실행해서 구체화된 뷰의 내용을 변경, 원본 테이블이 변경되면 원본테이블의 데이터 전체를 구체화된 뷰에 적용
AS 
    SELECT C.country_name, L.state_province, L.street_address
    FROM HR.countries C, HR.locations L
    WHERE C.country_id=L.country_id;
    
SELECT * FROM country_location_view; -- BUILD IMMEDIATE니까 바로 생성과 동시에 채워져 있는 것을 확인할 수 있다.
INSERT INTO HR.countries VALUES('KR', 'Republic of Korea', 3);
INSERT INTO HR.locations VALUES(3300, '1 Cheongwadae-ro', 03048, 'Seoul', 'Jongno-gu', 'KR');
-- BUILD IMMEDIATE를 했지만 REFRESH ON에는 DEMAND로 되어 있기 때문에 변경된 내용을 MATERIALIZED VIEW에 반영을 하려면 DBMS_MVIEW패키지를 수행시켜 줘야 한다.
EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');

SELECT * FROM country_location_view;
DELETE FROM HR.locations WHERE location_id = 3300;
DELETE HR.countries WHERE country_id = 'KR';
DROP MATERIALIZED VIEW country_location_view;

--[실습] 뷰 생성
--. employees테이블에서 07년도에 고용된 직원의 
--  employee_id, first_name, last_name, email, hire_date, job_id 
--  컬럼 값을 가지는 employee_07_view 이름의 뷰 생성
CREATE OR REPLACE VIEW employee_07_view
AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id
    FROM HR.employees
    WHERE hire_date BETWEEN '07/01/01' AND '07/12/31';
SELECT * FROM employee_07_view;  
--. employees 테이블에서 department_id와 job_id로 그룹화하고, 평균 salary가 
--  9000 초과인 직원의 department_id, job_id, salary의 평균값인 salary_avg컬럼 값을 
--  가지며 평균 salary값이 높은순으로 정렬한 high_salary_view 이름의 읽기 전용 뷰 생성
CREATE OR REPLACE VIEW high_salary_view
AS
    SELECT department_id, job_id, AVG(salary) AS salary_avg
    FROM HR.employees
    GROUP BY department_id, job_id
    HAVING AVG(salary) > 9000
    ORDER BY salary_avg DESC
    WITH READ ONLY;
SELECT * FROM high_salary_view;
--[실습] 뷰 생성 
--. employees 테이블을 manager_id와 employee_id를 기준으로 자체
--  조인한 뒤에 department_id와 직원의 first_name과 last_name을 
--  결합하고 관리자의 first_name과 last_name을 결합한 뒤에 
--  department_id를 기준으로 정렬하여 employee_manager_view
--  이름의 읽기 전용 뷰 생성
CREATE OR REPLACE VIEW employee_manager_view
AS
    SELECT E.department_id,
    --       concat(M.first_name, concat(' ', M.last_name)) manager, 
    --       concat(E.first_name, concat(' ', E.last_name)) employee
           M.first_name || ' ' || M.last_name manager,
           E.first_name || ' ' || E.last_name employee
    FROM HR.employees E, HR.employees M
    WHERE E.manager_id = M.employee_id
    ORDER BY E.department_id;
    WITH READ ONLY;
SELECT * FROM employee_manager_view;
--. employees, departments, jobs, locations 테이블을 조인하여
--  first_name, last_name, department_name, job_title, city를
--  보여주는 구체화 뷰를 내부의 데이터를 채우고 요청시 변경된 내용을
--  뷰에 반영하도록 생성
CREATE MATERIALIZED VIEW company_view
    BUILD IMMEDIATE
    REFRESH ON DEMAND COMPLETE
AS
    SELECT E.first_name, E.last_name, D.department_name, J.job_title, L.city
    FROM HR.employees E,
         HR.departments D,
         HR.jobs J,
         HR.locations L
    WHERE E.department_id = D.department_id
      AND E.job_id = J.job_id
      AND D.location_id = L.location_id;
SELECT * FROM company_view;

DROP VIEW employee_07_view;
DROP VIEW high_salary_view;
DROP VIEW employee_manager_view;
DROP MATERIALIZED VIEW company_view;






















