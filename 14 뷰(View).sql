SELECT * FROM emp_details_view;

--CREATE OR REPLACE VIEW
--. �� ���� �� ����
--CREATE OR REPLACE VIEW ���̸�
--AS
--    SELECT ����
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
--��(view)�� �ܼ��� select�� ������ ���� �ƴ϶� ������ ����,����,������ �����ϴ�. �׷���
--����,����,���� �Ϸ��� �⺻Ű�� employee_id�� �信 �� �־�� �ϴµ� ����Ǿ��� �츮��
--���� �⺻Ű�� �����ϰ� �ֱ� ������ new_employee_view�� insert�� �غ��ڴ�.
INSERT INTO new_employee_view VALUES(207, 'Suan', 'Lee', 'suan', '21/01/01', 'IT_PROG');
SELECT * FROM new_employee_view;
--. �� ����
DROP VIEW emp_view;
DROP VIEW new_employee_view;

--CREATE OR REPLACE VIEW
--. �б� ���� �� ����
--���� : 
--CREATE OR REPLACE VIEW ���̸�
--AS
--    SELECT ����
--    WITH READ ONLY;
--�Ϲ����� ��(View) ���� ��ſ�, �츮�� �⺻���� ��� INSERT,UPDATE,DELETE���� (������ �ְ�����) ����� �ȴ�.
--�׷��� �б����� ��(View)�� �� �״�� �б�, SELECT ���� ���ǰ� �б� ���� �並 ����� ���� �׳� WITH READ ONLY��
--�������� ���ָ� �ȴ�.
CREATE OR REPLACE VIEW salary_order_view
AS
    SELECT first_name, last_name, job_id, salary
    FROM employees
    ORDER BY salary DESC
    WITH READ ONLY;
SELECT * FROM salary_order_view;
INSERT INTO salary_order_view VALUES('Suan', 'Lee', 'IT_PROG', 10000);
--=> "�б� ������ �信�� DML �۾��� ������ �� �����ϴ�."��� ������ Ȯ���� �� �ִ�.
CREATE OR REPLACE VIEW job_salary_view
AS
    SELECT job_id, SUM(salary) sum_salary, MIN(salary) min_salary, MAX(salary) max_salary
    FROM employees
    GROUP BY job_id
    ORDER BY SUM(salary)
    WITH READ ONLY;
SELECT * FROM job_salary_view;
--. �� ����
DROP VIEW salary_order_view;
DROP VIEW job_salary_view;

CREATE MATERIALIZED VIEW(�θ��� ���� ����� �θ���)
. ��� ��ü�� ���� SELECT�����θ� �����ϸ� ��ü�� ����. �׷��� "��üȭ�� ��"�� ���� �����Ͱ� �����Ѵ�. �׷��� �̸��� "��üȭ�� ��"�̴�.
���� :
CREATE MATERIALIZED VIEW ���̸�
[
    BUILD {IMMEDIATE | DEFERRED}
    REFRESH {ON COMMIT | ON DEMAND} {FAST | COMPLETE | FORCE | NEVER}
    ENABLE QUERY REWRITE
]
AS
    SELECT ����
--    [������ �ɼ� ����]
--    BUILD IMMEDIATE : "��üȭ�� ��" ������ ���ÿ� ��üȭ�� �� ���ο� �����Ͱ� ä������.
--    BUILD DEFERRED : �� ���ο� �����Ͱ� ���߿� ä������. (������ �����Ͱ� ������ ���߿� ������� �����Ͱ� ä������.)
--    REFRESH ON COMMIT : �������̺� Ŀ���� �߻��� ������ ��üȭ �� ���� ������ ����
--    REFRESH ON DEMAND : ���� DBMS_MVIEW��Ű���� �����ؼ� ��üȭ�� ���� ������ �����Ѵ�.(�������̺� Ŀ���� �߻��Ҷ� ����� ���Ѽ� �����Ű�� ����̴�.)
--    . REFRESH�� �츮�� ���̺��� � ������ �ٲ������, �� ���ŵǾ�����, 
--      �� ��(VIEW)�� �����ϰ� �ִ� Ư�� ���̺� ������ ������ �Ȱ��� 
--      ��� ��üȭ�� �信 �ݿ��� ���� ������ �ִ� �ɼ��̴�.
--    FAST, FORCE : ���� ���̺� ����� �����͸� ��üȭ�� �信 �����Ų��.
--    COMPLETE : ���� ���̺��� ����Ǹ� �������̺��� ������ ��ü�� ��üȭ�� �信 ����
--    NEVER : �������̺��� ����Ǿ ��üȭ�� �信�� ���� ����
CREATE MATERIALIZED VIEW country_location_view
    BUILD DEFERRED
AS
    SELECT C.country_name, L.state_province, L.street_address
    FROM HR.countries C, HR.locations L
    WHERE C.country_id = L.country_id;
--������ �����ϴٴ� �����޽����� Ȯ���� �� �ִ�. HR��Ű���� ����(����)���� MATERIALIZED VIEW�� 
--�����ϴ� ������ ���� ������ sysdba������ ������ �ִ� oracle��Ű���� �������� ���� ������״�.
--=> ó���� �츮�� sysdba������ ���ؼ� hr������ oracle������ Ȱ��ȭ ���װ�, oracle��������
--sysdba���ѵ� �ο��ߴ�. => oracle��Ű���� ��üȭ�� �� ������ ���� country_location_view;�� 
--������ ���� Ȯ���� �� �ִ�.
--EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');
SELECT * FROM country_location_view;
--BUILD DEFERRED �ɼ��� �ֱ� ������ �����Ͱ� ���� ����. �̶� �����͸� ä�� �ֱ� ���ؼ� DBMS_MVIEW ��Ű�� �ȿ� �ִ� REFRESH(���ν��� ��)��� ��ɾ�(���)�� ����ؾ� �Ѵ�.
EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');
SELECT * FROM country_location_view;
DROP MATERIALIZED VIEW country_location_view;

--CREATE MATERIALIZED VIEW
--��üȭ�� �� ����
CREATE MATERIALIZED VIEW country_location_view
    BUILD IMMEDIATE -- ��üȭ�� �� ���� ��, ���ÿ� ��üȭ�� ���ο� �����Ͱ� ä����
    REFRESH ON DEMAND COMPLETE -- ���� DBMS_MVIEW��Ű���� �����ؼ� ��üȭ�� ���� ������ ����, ���� ���̺��� ����Ǹ� �������̺��� ������ ��ü�� ��üȭ�� �信 ����
AS 
    SELECT C.country_name, L.state_province, L.street_address
    FROM HR.countries C, HR.locations L
    WHERE C.country_id=L.country_id;
    
SELECT * FROM country_location_view; -- BUILD IMMEDIATE�ϱ� �ٷ� ������ ���ÿ� ä���� �ִ� ���� Ȯ���� �� �ִ�.
INSERT INTO HR.countries VALUES('KR', 'Republic of Korea', 3);
INSERT INTO HR.locations VALUES(3300, '1 Cheongwadae-ro', 03048, 'Seoul', 'Jongno-gu', 'KR');
-- BUILD IMMEDIATE�� ������ REFRESH ON���� DEMAND�� �Ǿ� �ֱ� ������ ����� ������ MATERIALIZED VIEW�� �ݿ��� �Ϸ��� DBMS_MVIEW��Ű���� ������� ��� �Ѵ�.
EXECUTE DBMS_MVIEW.REFRESH(LIST => 'country_location_view');

SELECT * FROM country_location_view;
DELETE FROM HR.locations WHERE location_id = 3300;
DELETE HR.countries WHERE country_id = 'KR';
DROP MATERIALIZED VIEW country_location_view;

--[�ǽ�] �� ����
--. employees���̺��� 07�⵵�� ���� ������ 
--  employee_id, first_name, last_name, email, hire_date, job_id 
--  �÷� ���� ������ employee_07_view �̸��� �� ����
CREATE OR REPLACE VIEW employee_07_view
AS
    SELECT employee_id, first_name, last_name, email, hire_date, job_id
    FROM HR.employees
    WHERE hire_date BETWEEN '07/01/01' AND '07/12/31';
SELECT * FROM employee_07_view;  
--. employees ���̺��� department_id�� job_id�� �׷�ȭ�ϰ�, ��� salary�� 
--  9000 �ʰ��� ������ department_id, job_id, salary�� ��հ��� salary_avg�÷� ���� 
--  ������ ��� salary���� ���������� ������ high_salary_view �̸��� �б� ���� �� ����
CREATE OR REPLACE VIEW high_salary_view
AS
    SELECT department_id, job_id, AVG(salary) AS salary_avg
    FROM HR.employees
    GROUP BY department_id, job_id
    HAVING AVG(salary) > 9000
    ORDER BY salary_avg DESC
    WITH READ ONLY;
SELECT * FROM high_salary_view;
--[�ǽ�] �� ���� 
--. employees ���̺��� manager_id�� employee_id�� �������� ��ü
--  ������ �ڿ� department_id�� ������ first_name�� last_name�� 
--  �����ϰ� �������� first_name�� last_name�� ������ �ڿ� 
--  department_id�� �������� �����Ͽ� employee_manager_view
--  �̸��� �б� ���� �� ����
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
--. employees, departments, jobs, locations ���̺��� �����Ͽ�
--  first_name, last_name, department_name, job_title, city��
--  �����ִ� ��üȭ �並 ������ �����͸� ä��� ��û�� ����� ������
--  �信 �ݿ��ϵ��� ����
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






















