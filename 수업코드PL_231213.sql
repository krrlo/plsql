SET SERVEROUTPUT ON
-- 커서 FOR 루프
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
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
                    WHERE department_id = &부서번호) LOOP
        DBMS_OUTPUT.PUT(', ' || emp_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.last_name);    
    END LOOP;
END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
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

-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12 + (NVL(급여, 0) * NVL(커미션, 0) * 12) )
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

-- 현재 존재하는 모든 부서의 각 소속사원을 출력하고 없는 경우 '현재 소속사원이 없습니다.'
SELECT department_id, department_name
FROM departments;

SELECT last_name, hire_date, job_id
FROM employees
WHERE department_id = &department_id;
-- format
/*
=== 부서명 : 부서 풀네임
1. 사원번호, 사원이름, 입사일, 업무
2. 사원번호, 사원이름, 입사일, 업무
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
        DBMS_OUTPUT.PUT_LINE('====== 부서명 ' || dept_rec.department_name);
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
            DBMS_OUTPUT.PUT_LINE('현재 소속사원이 없습니다.');
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


-- 1) 이미 정의되어있고 이름도 존재하는 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다');
        DBMS_OUTPUT.PUT_LINE('예외처리가 끝났습니다');
END;
/

-- 2) 이미 정의는 되어있지만 고유의 이름이 존재하는 않는 예외사항
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);

BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재합니다.');
END;
/

-- 3) 사용자 정의 사항
DECLARE
    e_no_deptno EXCEPTION;
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
        -- DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 부서번호가 삭제되었습니다.');
EXCEPTION
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
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

-- test_employee 테이블을 사용하여 특정 사원을 삭제하는 PL/SQL 작성
-- 입력처리는 치환변수를 사용
-- 해당 사원이 없는 경우를 확인해서 '해당 사원이 존재하지 않습니다.'를 출력 

DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    
    e_no_emp EXCEPTION;
BEGIN
    DELETE test_employee
    WHERE employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    DBMS_OUTPUT.PUT(v_eid || ', ');
    DBMS_OUTPUT.PUT_LINE('삭제되었습니다.;');
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT('입력한 : ' || v_eid || ', ');
        DBMS_OUTPUT.PUT_LINE('현재 테이블에 존재하지 않습니다;');
END;
/

-- PROCEDURE
CREATE OR REPLACE PROCEDURE test_pro
-- ()
IS
-- DECLARE : 선언부
-- 지역변수, 레코드, 커서, EXCEPTION
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END;
/
-- 1) 블록 내부에서 호출
BEGIN 
    test_pro;
END;
/

-- 2) EXECUTE 명령어 사용
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
    v_id employees.employee_id%TYPE := &사원번호;
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
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');

  -> 950101-1******
추가)
 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가
 9501011667777 => 1995년01월01일
 1511013689977 => 2015년11월01일 
*/

-- 프로시저, IN 매개변수 하나
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
    
    -- 추가
    v_gender := SUBSTR(p_ssn, 7, 1);
    
    IF v_gender IN ('1', '2','5','6') THEN
        v_birth := '19'||SUBSTR(p_ssn, 1,2)||'년'
                       ||SUBSTR(p_ssn, 3,2)||'월'
                       ||SUBSTR(p_ssn, 5,2)||'일';
    ELSIF v_gender IN ('3','4','7','8') THEN
        v_birth := '20'||SUBSTR(p_ssn, 1,2)||'년'
                       ||SUBSTR(p_ssn, 3,2)||'월'
                       ||SUBSTR(p_ssn, 5,2)||'일';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/
EXECUTE yedam_ju('0511013689977');

