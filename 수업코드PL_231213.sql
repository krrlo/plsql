SET SERVEROUTPUT ON
-- Ŀ�� FOR ����
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &�μ���ȣ;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT(', ' || emp_rec.employee_id);
        DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
    END LOOP;
     --DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
END;
/


BEGIN
    FOR emp_rec IN (SELECT employee_id, last_name
                    FROM employees
                    WHERE department_id = &�μ���ȣ) LOOP
        DBMS_OUTPUT.PUT(', ' || emp_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.last_name);    
    END LOOP;
END;
/

-- 1) ��� ����� �����ȣ, �̸�, �μ��̸� ���
DECLARE
    CURSOR emp_cursor IS
        SELECT e.employee_id, e.last_name, d.department_name
        FROM employees e LEFT JOIN departments d
                         ON ( e.department_id = d.department_id);
BEGIN
    FOR emp_Rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_rec.employee_id || ', ');
        DBMS_OUTPUT.PUT(emp_rec.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.department_name);  
    END LOOP;
END;
/

-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�, ���� ���
-- ���� : (�޿� * 12 + (NVL(�޿�, 0) * NVL(Ŀ�̼�, 0) * 12) )
DECLARE
    CURSOR emp_cursor IS
        SELECT first_name, 
               salary, 
               NVL(salary, 0) * 12 + NVL(salary, 0) * NVL(commission_pct, 0) * 12 as annual
        FROM employees
        WHERE department_id IN ( 50, 80 );   
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_info.first_name || ', ' || emp_info.salary || ', ' || emp_info.annual);    
    END LOOP;
END;
/

DECLARE
    CURSOR emp_cursor
        (p_deptno NUMBER) IS
        SELECT last_name, hire_date
        FROM employees
        WHERE department_id = p_deptno;
    
    emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor(60);
    
    FETCH emp_cursor INTO emp_info;
    DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
    
    -- OPEN emp_cursor(80);
    
    CLOSE emp_cursor;
END;
/
 SELECT last_name, hire_date
 FROM employees
 WHERE department_id = 60;

-- ���� �����ϴ� ��� �μ��� �� �Ҽӻ���� ����ϰ� ���� ��� '���� �Ҽӻ���� �����ϴ�.'
SELECT department_id, department_name
FROM departments;

SELECT last_name, hire_date, job_id
FROM employees
WHERE department_id = &department_id;
-- format
/*
=== �μ��� : �μ� Ǯ����
1. �����ȣ, ����̸�, �Ի���, ����
2. �����ȣ, ����̸�, �Ի���, ����
.
.
.
*/
DECLARE
    CURSOR dept_cursor IS
        SELECT department_id, department_name
        FROM departments;

    CURSOR emp_cursor
        (p_deptno NUMBER) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    FOR dept_rec IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('====== �μ��� ' || dept_rec.department_name);
        OPEN emp_cursor(dept_rec.department_id);
        
        LOOP
            FETCH emp_cursor INTO emp_rec;
            EXIT WHEN emp_cursor%NOTFOUND ;
            
            DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
            DBMS_OUTPUT.PUT('. ' || emp_rec.last_name);
            DBMS_OUTPUT.PUT(', ' || emp_rec.hire_date);
            DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
        END LOOP;
        
        IF emp_cursor%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('���� �Ҽӻ���� �����ϴ�.');
        END IF;
        
        CLOSE emp_cursor;
    END LOOP;
END;
/

DECLARE
    CURSOR emp_cursor
        (p_deptno NUMBER) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id = p_deptno;
BEGIN
    FOR emp_rec IN emp_cursor(60) LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
        DBMS_OUTPUT.PUT('. ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT(', ' || emp_rec.hire_date);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.job_id);
    END LOOP;
END;
/

-- FOR UPDATE, WHERE CURRENT OF
DECLARE
    CURSOR sal_info_cursor IS
        SELECT salary, commission_pct
        FROM employees
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
BEGIN
    FOR sal_info IN sal_info_cursor LOOP
        IF sal_info.commission_pct IS NULL THEN
            UPDATE employees
            SET salary = sal_info.salary * 1.1
            WHERE CURRENT OF sal_info_cursor;
        ELSE
            UPDATE employees
            SET salary = sal_info.salary + sal_info.salary * sal_info.commission_pct
            WHERE CURRENT OF sal_info_cursor;
        END IF;
    END LOOP;
END;
/
SELECT salary, commission_pct
FROM employees
WHERE department_id = 60;


-- 1) �̹� ���ǵǾ��ְ� �̸��� �����ϴ� ���ܻ���
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &�μ���ȣ;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����ϴ�');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� �������� ����� �����մϴ�');
        DBMS_OUTPUT.PUT_LINE('����ó���� �������ϴ�');
END;
/

-- 2) �̹� ���Ǵ� �Ǿ������� ������ �̸��� �����ϴ� �ʴ� ���ܻ���
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);

BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� ���� ����� �����մϴ�.');
END;
/

-- 3) ����� ���� ����
DECLARE
    e_no_deptno EXCEPTION;
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
BEGIN
    DELETE FROM departments
    WHERE department_id = &�μ���ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
        -- DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �������� �ʽ��ϴ�.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����Ǿ����ϴ�.');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �������� �ʽ��ϴ�.');
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(v_ex_code);
        DBMS_OUTPUT.PUT_LINE(v_ex_msg);
END;
/

CREATE TABLE test_employee
AS
    SELECT * 
    FROM employees;

-- test_employee ���̺��� ����Ͽ� Ư�� ����� �����ϴ� PL/SQL �ۼ�
-- �Է�ó���� ġȯ������ ���
-- �ش� ����� ���� ��츦 Ȯ���ؼ� '�ش� ����� �������� �ʽ��ϴ�.'�� ��� 

DECLARE
    v_eid employees.employee_id%TYPE := &�����ȣ;
    
    e_no_emp EXCEPTION;
BEGIN
    DELETE test_employee
    WHERE employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    DBMS_OUTPUT.PUT(v_eid || ', ');
    DBMS_OUTPUT.PUT_LINE('�����Ǿ����ϴ�.;');
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT('�Է��� : ' || v_eid || ', ');
        DBMS_OUTPUT.PUT_LINE('���� ���̺� �������� �ʽ��ϴ�;');
END;
/

-- PROCEDURE
CREATE OR REPLACE PROCEDURE test_pro
-- ()
IS
-- DECLARE : �����
-- ��������, ���ڵ�, Ŀ��, EXCEPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('����ó��');
END;
/
-- 1) ��� ���ο��� ȣ��
BEGIN 
    test_pro;
END;
/

-- 2) EXECUTE ��ɾ� ���
EXECUTE test_pro;

DROP PROCEDURE test_pro;


-- IN
CREATE PROCEDURE raise_salary
(p_eid IN NUMBER)
IS

BEGIN
    -- p_eid := 100;
    
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

DECLARE
    v_id employees.employee_id%TYPE := &�����ȣ;
    v_num CONSTANT NUMBER := v_id;
BEGIN
    RAISE_SALARY(v_id);
    RAISE_SALARY(v_num);
    RAISE_SALARY(v_num + 100);    
    RAISE_SALARY(200);
END;
/

EXECUTE RAISE_SALARY(100);

-- OUT
CREATE OR REPLACE PROCEDURE pro_plus
(p_x IN NUMBER,
 p_y IN NUMBER,
 p_result OUT NUMBER)
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT(p_x);
    DBMS_OUTPUT.PUT(' + ' || p_y);
    DBMS_OUTPUT.PUT_LINE(' = ' ||p_result);
    
    v_sum := p_x + p_y;
END;
/

DECLARE
    v_first NUMBER := 10;
    v_second NUMBER := 12;
    v_result NUMBER := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINe('before ' || v_result);
    pro_plus(v_first, v_second, v_result);
    DBMS_OUTPUT.PUT_LINe('after ' || v_result);
END;
/

-- IN OUT
-- 01012341234  => 010-1234-1234
CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2)
IS
    
BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1,3)
                  || '-' || SUBSTR(p_phone_no, 4,4)
                  || '-' || SUBSTR(p_phone_no, 8);
END;
/

DECLARE
    v_no VARCHAR2(50) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('before ' || v_no);
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after ' || v_no);
END;
/

/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

  -> 950101-1******
�߰�)
 �ش� �ֹε�Ϲ�ȣ�� �������� ���� ��������� ����ϴ� �κе� �߰�
 9501011667777 => 1995��01��01��
 1511013689977 => 2015��11��01�� 
*/

-- ���ν���, IN �Ű����� �ϳ�
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS
    v_result VARCHAR2(100);
    v_gender CHAR(1);
    v_birth VARCHAR2(11 char);
BEGIN
    -- v_result := SUBSTR(p_ssn, 1, 6) || '-' || SUBSTR(p_ssn, 7, 1) || '******';
    v_result := SUBSTR(p_ssn, 1, 6) || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*');
    DBMS_OUTPUT.PUT_LINE(v_result);
    
    -- �߰�
    v_gender := SUBSTR(p_ssn, 7, 1);
    
    IF v_gender IN ('1', '2','5','6') THEN
        v_birth := '19'||SUBSTR(p_ssn, 1,2)||'��'
                       ||SUBSTR(p_ssn, 3,2)||'��'
                       ||SUBSTR(p_ssn, 5,2)||'��';
    ELSIF v_gender IN ('3','4','7','8') THEN
        v_birth := '20'||SUBSTR(p_ssn, 1,2)||'��'
                       ||SUBSTR(p_ssn, 3,2)||'��'
                       ||SUBSTR(p_ssn, 5,2)||'��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/
EXECUTE yedam_ju('0511013689977');

