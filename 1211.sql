SET SERVEROUTPUT ON 

DECLARE 
v_eid  NUMBER;
v_ename employees.first_name%TYPE;
v_job VARCHAR2(1000);

BEGIN
    SELECT employee_id, first_name , job_id
    INTO v_eid , v_ename, v_job
    FROM   employees
    WHERE employee_id =100;   -- 0; 이라고하면  --where절을 아예 뺀다면...  exact fetch returns more than requested number of row 오류발생.  단일행이 반환되어야하므로 select 문 확인 
    --WHERE employee_id =0;   --"no data found"  라고 뜸 조건에 맞는 데이터가 없다면 실행안됨 >>SELECT의 결과가 없다는말..
    
    DBMS_OUTPUT.PUT_LINE('사원번호' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_ename);
    DBMS_OUTPUT.PUT_LINE('업무' || v_job);
END;
/

-- begin에서 필요한거 쓰고 위에서 변수정의하기 



DECLARE
v_eid employees.employee_id%TYPE := &사원번호;   --치환변수  블럭이 실행되기전에 대체되어야 한다   --치환변수는 기본적으로 숫자를 입력받도록되어있음.   문자 입력할거면 ' ' 붙히던지  '&사원번호'; 라고하던지 
                                                                        --숫자앞에 0이 살아있어야한다면 ' ' 쓸것 
v_ename employees.last_name%TYPE;

BEGIN
  SELECT first_name||','||last_name
  INTO v_ename    --select 결과를 v_ename에 넣어라 
  FROM employees
  WHERE employee_id= v_eid;   --v_eid = 치환변수 
  
    DBMS_OUTPUT.PUT_LINE('사원번호' || v_eid);    --치환변수가 출력  
    DBMS_OUTPUT.PUT_LINE('사원이름' || v_ename);
    
    
    
END;
/


--1)특정 사원의 매니저에 해당하는  사원번호를 출력 ( 특정 사원은 치환변수 사용해서 입력받)

DECLARE
v_eid employees.employee_id%TYPE := &사원번호; 
v_manager employees.manager_id%TYPE;

BEGIN
    SELECT  manager_id
    INTO v_manager
    FROM employees
    WHERE employee_id = v_eid;
    -- WHERE employee_id = &사원번호;  라고해도딤... 
    DBMS_OUTPUT.PUT_LINE('매니저번호' || v_manager);    --치환변수가 출력  
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);    --  SQL문이 적용된 행의 갯수 
       
END;
/

--pk만들때 인덱스 자동생성. index가 기준을 삼는다. 
--departments  manager_id =  부서장을 지칭
--employees  manager_id = 내 매니저 
--결과확인후 비긴에 넣기

SELECT e.employee_id, e.first_name, e.manager_id, e2.employee_id, e2.first_name
FROM employees e , employees e2
WHERE e.manager_id= e2.employee_id;



--INSERT, UPDATE

DECLARE
v_deptno departments.department_id%TYPE;  --테이블에서 가지고온 변수 
v_comm employees.COMMISSION_PCT%TYPE := 0.1;   --바깥에서 정해진 변수임 
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id =&사원번호;
    
    INSERT INTO employees(employee_id, last_name,email,hire_date,job_id,department_id)
    VALUES (1000,'Hong','hkd@naver.com',sysdate,'IT_PROG',v_deptno);      --job_id는 부모 테이블에있는 데이터만 들어가야함 
    --unique constraint violated 유니크 제약조건 위반 
    
    DBMS_OUTPUT.PUT_LINE('등록결과' || SQL%ROWCOUNT);
    UPDATE employees
    SET salary =(NVL(salary,0)+10000) *v_comm  --NULL이 허용ㅇ 되는 컬럼은 NULL인경우 어케할지 정해줘야함  *******NVL(salary,0) 이렇게..
    WHERE employee_id=1000; --  employee_id= 0 넣어도 실행음 됨  --  수정결과 0 나옴  >> UPDATE가 실행되지 않았음. 

    DBMS_OUTPUT.PUT_LINE('수정결과' || SQL%ROWCOUNT);   -- salary = 0이라도 UPDATE는 실행됨  수정결과 >> 1  값이 NULL일뿐 
END;
/

ROLLBACK;

select *from employees where employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE employee_id =&사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN  --0이나왔다는거 >> WHERE절이 만족하지 않아서 쓰는거  >>delete 가 진행되지 않았음. 
     DBMS_OUTPUT.PUT_LINE('해당사원 존재 X');
    END IF;
END;
/


--1 사원 번호를 입력 (치환변수) //사원번호, 사원이름, 부서이름 / 을 출력 

--조인으로 할꺼면 

select employee_id,last_name,department_name
into v_no, v_name , v_depname
from employees join departments
on(employees.department_id = departments.department_id)
where employee_id =&사원번호;

--select 2개 쓸꺼면

select employee_id , first_name, department_id
into v_no, v_name,v_depid
from employees
where employee_id =&사원번호;

select department_name
into v_depname
from departments
where department_id = v_depid;

-------------------------------------------------------------

DECLARE
v_no  employees.employee_id%TYPE :=&사원번호;   --emp테이블에서 
v_name employees.last_name%TYPE;   --emp테이블에서 
v_depname departments.DEPARTMENT_NAME%TYPE;   --departements테이블에서 
v_depid employees.department_id%TYPE;

BEGIN
 SELECT employee_id, last_name,(select DEPARTMENT_NAME from departments where e.DEPARTMENT_ID = DEPARTMENT_ID) as deptname   
 INTO v_no,v_name,v_depname
 FROM employees e
 WHERE employee_id = v_no;
 

DBMS_OUTPUT.PUT_LINE('사원번호' || v_no);
DBMS_OUTPUT.PUT_LINE('사원이름' || v_name);
DBMS_OUTPUT.PUT_LINE('부서이름' || v_depname);

END;
/


--2 사원번호를 입력할 경우 (치환변수) // 사원이름  급여  연봉//을 출력   
--연봉 : 급여 *12 + (NVL(급여,0) *NVL(커미션,0)*12)


DECLARE
v_name employees.last_name%TYPE; --emp 테이블에서 가져올것 
v_sal employees.salary%TYPE;   --emp테이블에서 가져올것 
v_comm employees.COMMISSION_PCT%TYPE;  --emp 테이블에서 가져올것 
v_annual NUMBER;     --새로 만들값 

BEGIN

SELECT last_name, salary, COMMISSION_PCT 
--SELECT last_name, salary, (salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))
INTO v_name, v_sal ,v_comm 
--INTO v_name, v_sal ,v_comm , v_annual
FROM employees
WHERE employee_id =&사원번호;

v_annual := v_sal *12 + (NVL(v_sal ,0) *NVL(v_comm,0)*12);


DBMS_OUTPUT.PUT_LINE('사원이름' || v_name);
DBMS_OUTPUT.PUT_LINE('급여' ||v_sal);
DBMS_OUTPUT.PUT_LINE('연봉' || v_annual);


END;
/


--기본 if문 

BEGIN

    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('정상적으로 실행되지 X');
      DBMS_OUTPUT.PUT_LINE('해당사원은 존재X');
      ELSE 
       DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다');
    END IF;

END;
/


select *from employees where employee_id = 1000;




--IF ELSE 문 
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count   --DATA가없는경우에도 체크를 해야하기 때문에  테이블의 검색결과가 아무것도 없을때..  
    FROM employees
    WHERE manager_id = &eid;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반사원');  
    ELSE   --만족하지 않으면 
         DBMS_OUTPUT.PUT_LINE('팀장입니다'); 
   END IF;
END;
/


--IF ELSEF ELSE 문 

DECLARE
v_hdate NUMBER;
BEGIN
    SELECT TRUNC (MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id =&사원번호;
    
    IF v_hdate < 5 THEN    --입사한지 5년미만 
     DBMS_OUTPUT.PUT_LINE('입사 5년 미만');  
    ELSIF v_hdate < 10 THEN  --입사한지 5년 이상~ 10년미만       ELSIF v_hdate <= 10 THEN 붙고 안붙고 차이. 값이 누락되지 않도록   
      DBMS_OUTPUT.PUT_LINE('입사 10년 미만');  
    ELSIF v_hdate <15 THEN --입사한지 10년 이상~ 15년미만 
     DBMS_OUTPUT.PUT_LINE('입사 15년 미만');  
    ELSIF v_hdate <20 THEN --입사한지 15년 이상~ 20년미만 
      DBMS_OUTPUT.PUT_LINE('입사 20년 미만');  
    ELSE     
     DBMS_OUTPUT.PUT_LINE('입사 20년 이상입니다 ');   --20년이상 ....
    END IF;
    --순서 뒤바뀌면 안됨 
END;
/



SELECT employee_id,
            TRUNC (MONTHS_BETWEEN(sysdate, hire_date)/12),
            TRUNC((sysdate-hire_date)/365)
FROM employees
ORDER BY 2 DESC;


--사원번호입력 (치환변수로 입력) D
--입사일이 2005년 포함 이후 이면  -- NEW EMPLOYEE
-- 2005년 이전이면 career employee

--1)날짜 그대로 비교 
DECLARE
v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate 
    FROM employees
    WHERE  employee_id=&사원번호;
    
    IF v_hdate >= TO_DATE('2005-01-01', 'YYYY-MM-dd') THEN   --hire_date는  날짜니까 
    DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
    ELSE 
    DBMS_OUTPUT.PUT_LINE('career employee');
    END IF;
END;
/


--2) 년도만 비교 

--SELECT TO_CHAR(hire_date,'yyyy')   --날짜중에서 특정한 값만 가져오게하려면 
--FROM employees;

DECLARE
v_year CHAR(4char);
BEGIN
    SELECT TO_CHAR(hire_date,'yyyy')   --
    INTO v_year
    FROM employees
    WHERE employee_id =&사원번호;

IF v_year >= '2005' THEN
 DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
ELSE
  DBMS_OUTPUT.PUT_LINE('career employee');
END IF ;
END;
/



--연도수 4자리면 yy 
--두자리면 rr
--0-49   >> 모든 두자리는 20~~
--50-99 >>19~~
--rr은 00~49 치면 1900~1949 / 50~99치면 2050~2099
--왜냐면 지금은 2023이라 00~49사이라서



DECLARE
v_year CHAR(4char);
v_print VARCHAR2(1000) := 'career employee';  --초기값으로 주면됨 
BEGIN
    SELECT TO_CHAR(hire_date,'yyyy')   
    INTO v_year
    FROM employees
    WHERE employee_id =&사원번호;

--IF v_year >= '2005' THEN
--v_print := 'NEW EMPLOYEE';
--ELSE
--v_print := 'career employee';
--
--END IF ;
--DBMS_OUTPUT.PUT_LINE(v_print);


IF v_year >= '2005' THEN
v_print := 'NEW EMPLOYEE';
END IF;

DBMS_OUTPUT.PUT_LINE(v_print);


END;

/

DECLARE 
v_year CHAR(2 char);

BEGIN
SELECT SUBSTR(TO_CHAR(hire_date),0,2)
INTO v_year
FROM employees
 WHERE employee_id =&사원번호;

IF v_year >='05' THEN
 DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
ELSE
  DBMS_OUTPUT.PUT_LINE('career employee');
END IF ;

END;
/



--사원번호를 입력( 치환변수) 하면       사원이름, 급여, 인상된 급여가 출력 
--사용자가 20퍼 입력하면 안에서 변환할수있게끔 

DECLARE
v_name VARCHAR2(1000);
v_salary employees.salary%TYPE;
v_new employees.salary%TYPE := 0;

BEGIN
SELECT last_name , salary 
INTO v_name, v_salary
FROM employees
WHERE employee_id = &사원번호;

IF v_salary <= 5000 then
v_new := v_salary + (v_salary*0.2);
ELSIF  v_salary <= 10000 then
v_new := v_salary + (v_salary*0.15);
ELSIF  v_salary <= 15000 then
v_new := v_salary + (v_salary*0.1);
ELSE 
v_new := v_salary;

END IF;

DBMS_OUTPUT.PUT_LINE('이름:' || v_name);
DBMS_OUTPUT.PUT_LINE('현재급여' ||v_salary);
DBMS_OUTPUT.PUT_LINE('인상된급여' || v_new);


END;
/




--수업


DECLARE
v_name VARCHAR2(1000);
v_salary employees.salary%TYPE;
v_new employees.salary%TYPE := 0;  --초기값줌 

BEGIN
SELECT last_name , salary 
INTO v_name, v_salary
FROM employees
WHERE employee_id = &사원번호;

IF v_salary <= 5000 then
 v_new :=20;
ELSIF  v_salary <= 10000 then
  v_new :=15;
ELSIF  v_salary <= 15000 then
 v_new :=10;

END IF;

DBMS_OUTPUT.PUT_LINE('이름:' || v_name);
DBMS_OUTPUT.PUT_LINE('현재급여' || v_salary);
DBMS_OUTPUT.PUT_LINE('인상된급여' || v_salary * (1+v_new/100)); 
END;
/



---반복문 
--기본 특정한 조건없이  // 무한루프 
--for 반복횟수기준
--while 조건만족하면 계속



--무한루프 도는 구문 
DECLARE

BEGIN
    LOOP    
    DBMS_OUTPUT.PUT_LINE('==');   --buffer overflow, limit of 1000000 bytes  무한루프.. 
    
    END LOOP;
END;
/



---1에서 10까지 더하깅.. 기본루프를 이용해서.. 
DECLARE
v_num NUMBER(2,0) :=1;
v_sum NUMBER(2,0) :=0;   ---최종 결과 

BEGIN
    LOOP    
  -- v_num := v_num +1;  --위에있어도 되는데 그럼 밑에 >9로해야함.. 
     v_sum := v_sum + v_num;  --sum에 누적 
    v_num := v_num +1;  --num이 1씩 증가  i ++ 와 같은..
    EXIT WHEN v_num > 10 ;   --EXIT만 쓰면 특정한 조건없이 바로 끝   v_num이 11이되는순간 그만 
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/


---while  1-10 까지 더하기 
DECLARE
v_num NUMBER(2,0) :=1;
v_sum NUMBER(2,0) :=0;   ---최종 결과 

BEGIN
    WHILE v_num <= 10  LOOP    

    v_sum := v_sum + v_num;    
    v_num := v_num +1;  
    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/



--FOR LOOP

DECLARE
v_sum NUMBER(2,0) :=0;  --누적된 변수 넣을 곳 
--v_n NUMBER(2,0) :=99;

BEGIN 
FOR num IN REVERSE 1..10 LOOP    --n 임시변수가 우선순위가 더 높음.   , DECLARE 절 임시변수랑 이름 같게X  = num과 같은 역할을 해줄 애 ..  REVERSE >>역순으로 출력하고싶다면 >> 기본 오름차순 정렬 
--DBMS_OUTPUT.PUT_LINE(v_n);        --lower upper 순으로 무조건 쓸것.. 
v_sum := v_sum + num;
END LOOP;
--DBMS_OUTPUT.PUT_LINE(v_n);  -->>99가 출력 
DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/



--별찍기
--1) FOR 이용 
DECLARE
    v_star VARCHAR2(100) :='';

BEGIN 
     FOR num IN 1..5 LOOP      -- num선언은 하되 내부적으로는 사용 X  num은 readonly임 값 변경 불가 
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);  -->>99가 출력 
    END LOOP;
END;
/


--2) 기본루프 이용 
DECLARE
    v_cnt NUMBER(1,0) :=1;
    v_star VARCHAR2(100) :='';
    --v_star VARCHAR2(6 char) : = '';
BEGIN 
    LOOP 
    v_cnt := v_cnt+1;
    v_star := v_star || '*';

    EXIT WHEN v_cnt >6;

    DBMS_OUTPUT.PUT_LINE(v_star);  --얘의 위치 

    END LOOP;
END;
/


--2) 기본루프 수업코드
DECLARE
    v_cnt NUMBER(1,0) :=1;
    v_star VARCHAR2(6 char) := '';
BEGIN 
    LOOP 
    v_star := v_star || '*';
     DBMS_OUTPUT.PUT_LINE(v_star);  --얘의 위치 

    v_cnt := v_cnt+1;
    EXIT WHEN v_cnt >5;
  
    END LOOP;
END;
/




--3) while 이용 

DECLARE
    v_cnt NUMBER(2,0) :=1;
    v_star VARCHAR2(100) :='';

BEGIN

    WHILE v_cnt <6 LOOP
    v_cnt := v_cnt+1;
    v_star := v_star || '*';
    DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;

END;
/



--3) while 수업코드 

DECLARE
--length했으니까 cnt 안해도됨   
v_star VARCHAR2(6 char) := '*';

BEGIN 
   WHILE  LENGTH(v_star) <=5 LOOP 

  DBMS_OUTPUT.PUT_LINE(v_star);  
    v_star := v_star || '*';
  
    END LOOP;

END;
/



--DBMS_OUTPUT.PUT(); 
--DBMS_OUTPUT.PUT_LINE();


--이중루프문  for문사용 

BEGIN
    FOR line IN 1..5 LOOP   --line을 제어 
        FOR star IN 1..line LOOP  --1번째 줄이면 별 1개    1~ line (=1) 
            DBMS_OUTPUT.PUT('*');
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('');  --줄바꾸기 
    END LOOP;     
END;
/


--이중루프문 


DECLARE
    v_star NUMBER(1,0) :=1;
    v_line NUMBER(1,0) :=1;

BEGIN
    LOOP 
        v_star := 1;  --반드시 초기화가 되어야함   for은 자동 동작  
        LOOP
            DBMS_OUTPUT.PUT('*');
            v_star := v_star +1;
            EXIT WHEN v_star > v_line;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_line := v_line +1;
        EXIT WHEN v_line > 5;
    END LOOP;     
END;
/



