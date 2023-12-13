SET SERVEROUTPUT ON 


--커서+ for loop 는 open fetch close 명시안해도됨  알아서 해줌..
DECLARE
        CURSOR emp_cursor IS
                SELECT employee_id , last_name , job_id
                FROM employees
                WHERE department_id =&부서번호;   --데이터가 없는거 넣으면 FOR LOOP자체가 돌지않음 .. 
                               
BEGIN
         FOR emp_rec IN  emp_cursor  LOOP   
                DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT ||',');
                DBMS_OUTPUT.PUT(emp_rec.employee_id);
                DBMS_OUTPUT.PUT(emp_rec.last_name);
                DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
   
        END LOOP;  --커서가 여기서 걍 끝남  
        
       -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT); 에러남.. 
END;

/



----서브쿼리를 for loop 사용한... 일회성 커서 이름이 존재하지 않음. 커서의 속성을 사용할수 X


BEGIN 
        FOR emp_rec IN (SELECT employee_id , last_name            ---- IN (커서) 안하고.. 
                                 FROM employees
                                 WHERE department_id = &부서번호 ) LOOP 
          
            DBMS_OUTPUT.PUT(emp_rec.employee_id);
            DBMS_OUTPUT.PUT_LINE(emp_rec.last_name);  
        
        END LOOP;
        
        
END;
/



--------------------------1)  사원번호 , 이름, 부서이름  FOR 이용 


DECLARE
        CURSOR emp_info_cursor IS 
                SELECT e.employee_id eid, e.last_name ename, d.department_name dname
                FROM employees e left join departments d on (e.department_id=d.department_id)       
                order by eid;
                         
BEGIN
         FOR emp_rec IN  emp_info_cursor  LOOP   
         
                DBMS_OUTPUT.PUT(emp_rec.eid);
                DBMS_OUTPUT.PUT(emp_rec.ename);
                DBMS_OUTPUT.PUT_LINE(emp_rec.dname);
   
        END LOOP; 
        
    
END;
/



-------2)   연봉구하기  for 

DECLARE
       CURSOR emp_info_cursor IS 
                SELECT last_name  , salary , (salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12)) as total
                FROM employees
                WHERE department_id IN (50,80);
             
                         
BEGIN
         FOR emp_rec IN  emp_info_cursor  LOOP   
         
                DBMS_OUTPUT.PUT(emp_rec.last_name ||',');
                DBMS_OUTPUT.PUT(emp_rec.salary ||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.total);
   
        END LOOP; 

    
END;
/



----- 2-1 연봉구하기 기본 


DECLARE

    CURSOR emp_sal_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN(50,80)
        ORDER BY department_id;
        
        emp_rec emp_sal_cursor%ROWTYPE;  --커서담을애 
        v_annual employees.salary%TYPE;  --내가계산 
    
    
BEGIN
    
    OPEN emp_sal_cursor;   
    
    LOOP 
        FETCH emp_sal_cursor INTO emp_rec ;
        EXIT WHEN emp_sal_cursor%NOTFOUND;
    
         v_annual := emp_rec.salary *12 +(NVL(emp_rec.salary,0) * NVL(emp_rec.commission_pct ,0) *12);
         
        DBMS_OUTPUT.PUT(emp_rec.last_name||',');
        DBMS_OUTPUT.PUT(emp_rec.salary||',');
        DBMS_OUTPUT.PUT_LINE(v_annual);
        
        
    END LOOP;   

   
   CLOSE emp_sal_cursor;
   
END;
/



-------------------------------매개변수 커서 사이즈 입력 X     


DECLARE
        CURSOR emp_cursor
        (p_deptno NUMBER) IS
        SELECT last_name , hire_date
        FROM employees
        WHERE department_id = p_deptno;
        

        emp_info emp_cursor%ROWTYPE;

BEGIN
    
    
        OPEN emp_cursor(60);
        
        
        
            FETCH emp_cursor INTO emp_info;
            DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
        
        
            CLOSE emp_cursor;

END;
/



-----현재 존재하는 모든 부서의 각 소속사원을 출력하고, 없는경우 현재 소속사원이 없습니다 출력

---부서명 : 부서 풀네임
--1.사원번호, 사원이름 , 입사일, 업무
--커서 2개 루프문 2개 

DECLARE

      --일반커서  부서이름, 매개값이 필요하기때문에 만든 커서 
             CURSOR dept_cursor IS
             SELECT department_name , department_id
             FROM departments;
  --모든 부서니까 where절 필요없음    --for 커서 돌릴거임 , 데이터 없는 경우가 없으니까.. 
  
      --매개변수가있는커서 
        CURSOR emp_cursor
             (deptid number) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id =deptid;                --데이터가 없는 경우가 있으니까 기본루프 기반으로 돌려야함 
        
    
         emp_rec emp_cursor%ROWTYPE;  -- emp cursor 넣어야되니까..
     

BEGIN
    FOR dept_rec IN dept_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE('====부서명' || dept_rec.department_name);
        
        OPEN emp_cursor(dept_rec.department_id);  --매개값 넣어야함 
        
        LOOP 
                FETCH emp_cursor INTO emp_rec;
                EXIT WHEN emp_cursor%NOTFOUND;
                
                DBMS_OUTPUT.PUT(emp_rec.last_name);
                DBMS_OUTPUT.PUT(emp_rec.hire_date);
                DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
                 
         END LOOP;  --기본루프 끝       
      
      
       IF emp_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('소속된 사원이 없습니다');
       END IF;
       
        CLOSE emp_cursor;
    END LOOP;    --for 끝 
END;
/

-------------- 매개변수 있는 커서 for 쓸때 



DECLARE
  
        CURSOR emp_cursor
             (deptid number) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id =deptid;             
         

BEGIN
     FOR emp_rec IN  emp_cursor(60) LOOP
     
                DBMS_OUTPUT.PUT(emp_rec.last_name);
                DBMS_OUTPUT.PUT(emp_rec.hire_date);
                DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
                    
    END LOOP;    --for 끝 
END;
/


-------------FOR UPDATE 굳이 기억 안해도 된대 

-- FOR UPDATE, WHERE CURRENT OF    --PK가 없어도 UPDATE가능함. 
DECLARE
    CURSOR sal_info_cursor IS
        SELECT salary, commission_pct
        FROM employees
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
BEGIN
    FOR sal_info IN sal_info_cursor LOOP  
        IF sal_info.commission_pct IS NULL THEN    ---NULL이면 10퍼 인상 
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
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
        
        
        
--------------------------------------------------EXCEPTION 
--1) 이미 정의되어있고 이름도 존재하는 예외상항   20개정도..
DECLARE
        v_ename employees.last_name%TYPE;
BEGIN
        SELECT last_name
        INTO v_ename
        FROM employees
        WHERE department_id =&부서번호;
        
        DBMS_OUTPUT.PUT_LINE(v_ename);
        
        --실제 수행되는 블럭 밑에 선언
EXCEPTION
        WHEN NO_DATA_FOUND THEN                                                                                             --select 절에서만 작동하는 예외  NO_DATA_FOUND,TOO_MANY_ROWS
            DBMS_OUTPUT.PUT_LINE('해당부서에 소속된 사원이 없습니다');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('해당부서에 여러명의 사원이존재');
            DBMS_OUTPUT.PUT_LINE('예외처리가 끝났습니다'); 
END;
/


--예외발생하면 바로 익셉션으로 가서  no_data_found 가서 오류메세지 출력
--예외는 한건만 작동됨.. 동시에 동작되지않음. 예외가 발생하면  하나가 수행되고 종료임 


---2) 이미 정의는 되어있지만 고유의 이름이 존재하지 않는 예외사항

DECLARE 

e_emps_remaining EXCEPTION;   --오류 이름 ; 
PRAGMA EXCEPTION_INIT(e_emps_remaining,-02292);  --실제 예외와 내가 만든 예외이름을 연결  PRAGMA명령어 입력 .  

BEGIN      
    DELETE FROM departments
    WHERE department_id =&부서번호;    -- child record found 자식레코드가 있는경우 삭제를 막음.. .. 이름이 존재하지 않지만 
    
    
EXCEPTION
        WHEN e_emps_remaining  THEN
            DBMS_OUTPUT.PUT_LINE('자식이존재');
       
END;
/


------------3) 사용자 정의 사항... 오라클에 이미 정의된 예외가 아니여야함.   예금잔액이 -가 아닌 경우만 ..  if문으로 처리하면  그 뒤에 코드가 실행이 되니까 .. ㅇㅖ외 처리하면 뒤에 코드 진행을 막기때문에..

DECLARE
        e_no_deptno EXCEPTION;   --예오ㅣ이름 정의 
        v_ex_code NUMBER;
        v_ex_msg VARCHAR2(1000);
BEGIN
          DELETE FROM departments
          WHERE department_id =&부서번호;    --없는 부서 넣어도  실행은 되지만 값이 안나오니까..혼동 
  
        IF SQL%ROWCOUNT =0 THEN
                RAISE e_no_deptno;    --IF문뒤에 있는   DBMS_OUTPUT.PUT_LINE('해당부서 번호가 삭제되었습니다.'); 이 코드가 실행 안됨  바로 예외 절로 감 
                -- DBMS_OUTPUT.PUT_LINE('해당부서 번호 존재 X');  -- 얘 하면 DBMS_OUTPUT.PUT_LINE('해당부서 번호가 삭제되었습니다.'); 이 코드까지 실행이 됨 
        END IF;        
    
        DBMS_OUTPUT.PUT_LINE('해당부서 번호가 삭제되었습니다.');

EXCEPTION
        WHEN  e_no_deptno THEN
                DBMS_OUTPUT.PUT_LINE('해당부서 번호 존재 X');   --없는 번호 집어 넣으면 
        WHEN OTHERS THEN        --있는 부서 집어넣으면 
        v_ex_code:= SQLCODE;
        v_ex_msg := SQLERRM;
             DBMS_OUTPUT.PUT_LINE(v_ex_code);  ---2292
             DBMS_OUTPUT.PUT_LINE(v_ex_msg);   --ORA-02292: integrity constraint (HR.JHIST_DEPT_FK) violated - child record found
END;
/


----------


CREATE TABLE test_employee

as 

        select *
        from employees;


select *from test_employee;



--test_employee 테이블을 사용하여 특정 사원을 삭제 하는 .. 
--삭제할 사원은 >> 치환변수 
--해당사원이 없는 경우를 확인해서 '해당 사원이 존재하지 않습니다 ' 를 출력 


DECLARE
        v_eid employees.employee_id%type :=&사원번호;
        e_no_empid EXCEPTION;   --예오ㅣ이름 정의 
        
BEGIN
          DELETE FROM test_employee
          WHERE employee_id =v_eid;    
  
        IF SQL%ROWCOUNT =0 THEN
                RAISE  e_no_empid;    
        END IF;        
    
        DBMS_OUTPUT.PUT_LINE(v_eid||'해당사원이 삭제되었습니다.');

EXCEPTION
        WHEN e_no_empid THEN
                DBMS_OUTPUT.PUT_LINE(v_eid||'해당사원이 존재 하지않습니다.....');   
END;
/

select * from test_employee;




-------------------------------------------procedure 생성하기!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE PROCEDURE test_pro   --2. 수정후 or replace 추가 ..  프로시져가 존재하는 경우 대체하겠다..  
--()
IS
--DECLARE :선언부 위치  구문만 빠진것.  IS와 BEGIN사이 
--지역변수, 레코드 , 커서, EXCEPTION  선언가능  

BEGIN
        DBMS_OUTPUT.PUT_LINE('first ');  ---동작안함 .. 

EXCEPTION 
        WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('예외처리');
END;    --만들어지기는 함  예외처리 안적어줘도  .. 수정하려면 1. 수정하고 
/

--procedure 수정법: CREATE OR REPLACE 하던가  2.TEST_PRO에서 고치던가..

--------------------------PROCEDURE실행시키기   1) 블럭안에서 실행시켜야함 ..
BEGIN
    test_pro;
END;
/

--------------------------PROCEDURE실행시키기   2) execute 명령어사용

EXECUTE test_pro;   --특정 procedure을.. 실행 execute가 내부적으로 블록 생성해서 집어넣어줌   --in모드만 가능


-----------------------------------------------procedure 삭제하기!!!!!!!!!!!!!!!!!!
DROP PROCEDURE test_pro;



-------------------------------------------------------------In 

CREATE or replace PROCEDURE raise_salary 
(p_eid IN NUMBER)
IS 

BEGIN
        --p_eid :=100;
        
        DBMS_OUTPUT.PUT_LINE(p_eid);
        
        UPDATE employees
        SET  salary =salary *1.1
        WHERE employee_id = p_eid;
END;
/


---------------------------------- in 실행시키기-----------------------
EXECUTE raise_salary (100);


--------------------------in 실행시키기


DECLARE
    
    v_id employees.employee_id%type :=&사원번호;
    v_num CONSTANT NUMBER := v_id;   --상수

BEGIN

    raise_salary(v_id);   --매개 변수의 형태는  변수도 가능 
    raise_salary(v_num);   --상수도 가능하고 
    raise_salary(v_num +100);  --연산결과도 가능 
    raise_salary(200);
     
END;
/


------------------------------------out  

CREATE or replace PROCEDURE pro_plus 
(p_x IN NUMBER,  --값 읽어 10
p_y IN NUMBER,  --읽 12
p_result OUT NUMBER)   --내보냄  .. 아무값도 할당 안해주면 null부터 시작함..

IS 
         v_sum NUMBER;
         
BEGIN
        DBMS_OUTPUT.PUT(p_x);
        DBMS_OUTPUT.PUT('+'||p_y);
        DBMS_OUTPUT.PUT_LINE('=' || p_result);
     
        v_sum :=p_x+p_y;
           --v_sum :=p_x+p_y+p_result == null임 p_result얘가 널ㅇㅣ니까 
           
         p_result :=p_x+p_y;   --아웃모드가 값을 ㄱㅏㅈㅣ게 하는 부분 ,,,,,,
         
END;
/


-------------------------------out 실행시키기 
DECLARE
    
     v_first NUMBER :=10;
     v_second NUMBER :=12;
     v_result NUMBER :=100;  --널인애가 나와서 result 값을 덮어쓴대..?
 
BEGIN
        DBMS_OUTPUT.PUT_LINE('전'||v_result);
        pro_plus(v_first , v_second, v_result);    --프로시저가 실행 10+12=  변수가 넘어가야함 
        DBMS_OUTPUT.PUT_LINE('후'||v_result);  --p_result :=p_x+p_y; 이거안해주면 널 나옴 
END;
/


-----------------------------------------in out  
----------포맷변경할때 사용 010-4131-4226으로,


CREATE  PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2) --들어온애  나갈애  같은 변수 사용 

IS 
         
         
BEGIN
        --포맷 변경 후 다시 내보내기 
        p_phone_no := SUBSTR( p_phone_no,1,3)
                             ||'-'|| SUBSTR( p_phone_no,4,4)
                             ||'-'|| SUBSTR( p_phone_no,8);
END;
/


-------------------------------INOUT 실행시키기 
DECLARE
    
   v_no VARCHAR2(50) := '01041314226';   
 
BEGIN
       DBMS_OUTPUT.PUT_LINE('전'||v_no);
       format_phone(v_no);
       DBMS_OUTPUT.PUT_LINE('후'||v_no);
       
END;
/

------------------------------------------------내가푼거 -----


---1) 주민번호 입력하면 940907-2******출력되게


CREATE  OR REPLACE PROCEDURE yedam_ju
(num_no IN OUT VARCHAR2) --들어온애  나갈애  같은 변수 사용 

IS          
         
BEGIN
        --포맷 변경 후 다시 내보내기 
       num_no := SUBSTR(num_no,1,6)
                             ||'-'|| SUBSTR(num_no,8,1)
                             ||'******';
                             
       
END;
/


-------------------------------INOUT 실행시키기 
DECLARE
    
   v_no VARCHAR2(50) := '9409072454545';   
 
BEGIN
      
    yedam_ju(v_no);
     DBMS_OUTPUT.PUT_LINE(v_no);
       
END;
/

---------2) 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가 ----940907>> 1994년 09월 07일 



CREATE  OR REPLACE PROCEDURE yedam_juu
(num_no IN VARCHAR2,
 new_no OUT DATE
) 


IS          
         
BEGIN
      
      new_no := TO_DATE(SUBSTR(num_no,6), 'YYYY년MM월dd일');
                                                                      

END;
/


-------------------------------INOUT 실행시키기 
DECLARE
    
  
   v_no VARCHAR2(50) := '9409072454545';   
    
BEGIN
      
    yedam_juu(v_no);
     DBMS_OUTPUT.PUT_LINE(v_no);
       
END;
/



----------------------------------------------




-------------문제 풀이 시작

/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******

--rr은 00~49 치면 1900~1949 / 50~99치면 2050~2099
--왜냐면 지금은 2023이라 00~49사이라서
  
추가)
 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가
 9501011667777 => 1995년01월01일
 1511013689977 => 2015년11월01일
*/

-----------------------------1)

CREATE  OR REPLACE PROCEDURE yedam_ju
(num_no IN VARCHAR2) 

IS       

    v_result VARCHAR2(100);
    
BEGIN 
       -- v_result := SUBSTR(num_no,1,6) || '-' || (SUBSTR(num_no,7,1),7, '*');  --ㄷ시 
         v_result := SUBSTR(num_no,1,6) || '-' || RPAD(SUBSTR(num_no,7,1),7, '*');
         DBMS_OUTPUT.PUT_LINE(v_result);

END;
/

EXECUTE yedam_ju('9409072675718');

--------------------------2)

CREATE  OR REPLACE PROCEDURE yedam_ju
(num_no IN VARCHAR2) 

IS       

    v_result VARCHAR2(100);
    v_gender CHAR(1);
    v_birth VARCHAR2(11 char);
    
BEGIN 
        

    v_gender := SUBSTR(num_no,7,1);
    
    IF v_gender IN ('1', '2') THEN
        v_birth :='19' ||SUBSTR(num_no,1,2) ||'년'
                          ||SUBSTR(num_no,3,2) ||'월'
                        ||SUBSTR(num_no,5,2) ||'일';
                        
    ELSIF  v_gender IN ('3', '4') THEN
        v_birth :='20' ||SUBSTR(num_no,1,2) ||'년'
                          ||SUBSTR(num_no,3,2) ||'월'
                        ||SUBSTR(num_no,5,2) ||'일';
                                           
   END IF;
   
   DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/

EXECUTE yedam_ju('0509073675718');



--------------------------------------------------------------

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/



CREATE  OR REPLACE PROCEDURE TEST_PRO 
(emp_id IN NUMBER) 

IS       

    
BEGIN 
     
     DELETE FROM test_employee
     WHERE employee_id = emp_id;
     
     IF SQL%ROWCOUNT =0 THEN        
        DBMS_OUTPUT.PUT_LINE('해당사원이 존재 X'); 
    END IF;        
    
END;
/

EXECUTE TEST_PRO(175);

SELECT  * FROM test_employee;


/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/


CREATE  OR REPLACE PROCEDURE yedam_emp
(emp_id IN NUMBER) 

IS       

 v_name VARCHAR2(100);
    
BEGIN 

    SELECT last_name
    INTO  v_name
    FROM test_employee
    WHERE employee_id =emp_id;


      v_name := SUBSTR(v_name,1,1) ||  RPAD(SUBSTR(num_no,7,1),7, '*');   --이름 길이의 -1만큼 별표 
        
     DBMS_OUTPUT.PUT_LINE(v_name);
    
END;
/


EXECUTE yedam_emp(176)







/*
4.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/
/*
5.
다음과 같이 테이블을 생성하시오.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
5-1.
부서번호를 입력하면 사원들 중에서 입사년도가 2005년 이전 입사한 사원은 yedam01 테이블에 입력하고,
입사년도가 2005년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.
 
5-2.
1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리
2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
*/





