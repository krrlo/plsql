SET SERVEROUTPUT ON 


--2 입력하면 해당 구구단이 출력되도록 


--기본이용 

DECLARE
    v_dan NUMBER(1,0) :=&단입력;
    v_num NUMBER :=1;
BEGIN

    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
        v_num := v_num+1;
   
    EXIT WHEN v_num >9 ;
    END LOOP;

END;
/


---FOR 구구단 이용 
DECLARE

v_dan NUMBER(1,0) :=&단입력;

BEGIN

    FOR v_num IN 1..9 LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
    END LOOP;
    
END;
/


--WHILE 이용

DECLARE
    v_dan NUMBER(1,0) :=&단입력;
    v_num NUMBER :=1;
BEGIN

    WHILE v_num <=9  LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
        v_num := v_num+1;
    END LOOP;

END;
/

----------------------------------------------------------------------------------------------------------------------

--구구단 2~9단까지 출력되도록 (이중반복문)
--DECLARE

---포문이용 
BEGIN
    FOR a IN 2..8 LOOP
        FOR b IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(a || '*' || b || '='||(a*b));
      END LOOP;
    END LOOP;
END;
/


---while이용 옆으로.. 
DECLARE 
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) :=1;
BEGIN 
     WHILE v_num <10 LOOP   --바깥 고정값  1부터 시작 
     v_dan :=2;  --초기값 주깅   --안쪽 변하는 값  2단부터 시작이니까.. 
            WHILE v_dan <10 LOOP
             DBMS_OUTPUT.PUT(v_dan ||'x'|| v_num || '=' || (v_dan*v_num) || ' ');
             v_dan := v_dan+1;  --2>>3단으로 변함 
            END LOOP;
     DBMS_OUTPUT.PUT_LINE('');  --줄바꾸기 
     v_num := v_num +1;
     END LOOP;
 END;
 /
        

---while 옆으로

DECLARE 
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) :=1;
    v_msg VARCHAR2(1000);
BEGIN 
     WHILE v_num <10 LOOP
     v_dan :=2;  --초기값 다시 주기 
            WHILE v_dan <10 LOOP
              v_msg := v_dan ||'x'|| v_num || '=' || (v_dan*v_num) || ' ';
             DBMS_OUTPUT.PUT(RPAD(v_msg,12,' '));  --오른쪽 lpad
             v_dan := v_dan+1;
            END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    v_num := v_num +1;
    END LOOP;
 END;
 /




---구구단 1~9단까지 출력되도록. 홀수단만 출력  (이중반복문)

DECLARE
v_dan NUMBER(3,0) :=1;
v_num NUMBER(3,0) :=1;

BEGIN
    LOOP 
    v_dan := 1;
            LOOP 
            IF MOD(v_dan , 2) =1 THEN
            DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
            END IF;
            EXIT WHEN v_num>9;
            END LOOP;
     v_dan := v_dan + 1;     
     EXIT WHEN v_dan >9;
     END LOOP;
END;
/


---구구단 1~9단까지 출력되도록. 홀수단만 출력  ( FOR 문 이중반복문)

BEGIN 
    FOR v_dan IN 1..9 LOOP
            IF MOD(v_dan,2) <>0 THEN
                FOR v_num IN 1..9 LOOP
                    DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
            END IF;
     END LOOP;
END;
/

---구구단 1~9단까지 출력되도록. 홀수단만 출력  ( FOR  continue)


BEGIN 
    FOR v_dan IN 1..9 LOOP
            IF MOD(v_dan,2) = 0 THEN
                    CONTINUE;    -- 짝수면 지나가겠당 
            END IF;
                    
                FOR v_num IN 1..9 LOOP
                    DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
     END LOOP;
END;
/

-----------------------------조합데이터 


DECLARE
    TYPE info_rec_type IS RECORD   --이 타입은 레코드 유형을 기반으로 합니다...   --블럭이 끝나면 사라짐  다른 블럭에서 필요하면 복붙..
        ( no NUMBER NOT NULL :=1,                     --필드단위로   (필드이름)(데이터타입)(제약조건) (필요하다면 값넣기)
        name VARCHAR2(1000) :='NO name',
         birth DATE);
         
        user_info info_rec_type ;   --사용하려면 변수선언 해야함  (user_info) (info_rec_type) ; 
        
BEGIN
    user_info.birth := sysdate;
    DBMS_OUTPUT.PUT_LINE(user_info.birth);  -- 그냥 user_info 하면 사용불가
  
END;
/




DECLARE
    emp_info_rec employees%ROWTYPE;   --이미존재하고있는 *****한테이블의 정보를 받아올때 rec 타입씀 , 다른테이블 가져올때는 한계가있음..
BEGIN
    SELECT *
    INTO emp_info_rec        --레코드에 한행 넣기 
    FROM employees
    WHERE employee_id =&사원번호;
    
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.first_name);
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.last_name);
END;
/


--사원번호 이름 부서이름 

DECLARE

    TYPE emp_rec_type IS RECORD                                                                         ---다른테이블 가져올때 
        (eid employees.employee_id%type,   --number
         ename employees.last_name%type,       --varchar2
         deptname departments.department_name%type);  --varchar2
         
       emp_rec emp_rec_type;
       
       
BEGIN
    SELECT employee_id, job_id, first_name     --정상작동됨  필드명과 관계없이.  number , var, var
    INTO   emp_rec
    FROM  employees  join departments 
                            using(department_id)    
    where employee_id = &사원번호;
    
     DBMS_OUTPUT.PUT_LINE(emp_rec.ename);
    
END;
/



--위에꺼랑 같음 

DECLARE

    TYPE emp_rec_type IS RECORD                                                                        
        (eid employees.employee_id%type,   --number
         ename employees.last_name%type,       --varchar2
         deptname departments.department_name%type);  --varchar2
         
       emp_rec emp_rec_type;
       
       
BEGIN
    SELECT employee_id, last_name, department_name       --* 쓰려면 레코드 내부 필드에 전체 필드가 다 있어야함  레코드필드 수만큼 셀렉트절에 나열 
    INTO   emp_rec
    FROM  employees  join departments 
                            using(department_id)    
    where employee_id = &사원번호;
    
     DBMS_OUTPUT.PUT_LINE(emp_rec.ename);
    
END;
/


--------------------------------------테이블 배열과 유사함 
---테이블에 단일 값넣기 

DECLARE
        --정의
        TYPE  num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        --선언
        num_list num_table_type;    --(num_list)  (num_table_type);  
BEGIN

--arrar[0] =>table(0)
    num_list(-1000) := 1;
    num_list(1234) := 2;
    num_list(11111) := 3;


    DBMS_OUTPUT.PUT_LINE(num_list.count);  -->count 메소드 사용 
    DBMS_OUTPUT.PUT_LINE(num_list(1234));  
    

END;
/





--위 동일 
---테이블에 단일 값

DECLARE
        --정의
        TYPE  num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        --선언
        num_list num_table_type;    --(num_list)  (num_table_type);  
BEGIN
    FOR i IN 1..9 LOOP
        num_list(i) := 2*1;
    END LOOP;
    
    --배열 값 끄집어내기..
    FOR idx IN num_list.FIRST .. num_list.LAST LOOP   
        IF num_list.EXISTS(idx) THEN    --num_list.EXISTS(idx) 값이있으면 true
            DBMS_OUTPUT.PUT_LINE(num_list(idx));
        END IF;
    END LOOP;

END;
/



----테이블
--단일값이 아닌 레코드가 들어간다면

DECLARE
        TYPE emp_table_type IS TABLE OF employees%ROWTYPE    --데이터 타입이 레코드타입이 됨      emp_rec employees%ROWTYPE;  --한행에 대한 정보를 가져옴  가 여기에 담길수있대 같은 데이터 타입이라 
             INDEX BY BINARY_INTEGER;
             
        emp_table emp_table_type;  --테이블
        emp_rec employees%ROWTYPE;  --한행에 대한 정보를 가져옴 
        
BEGIN
        FOR eid IN 100..110 LOOP
            SELECT *
            INTO emp_rec
            FROM employees
            WHERE employee_id =eid;
            
            emp_table(eid) := emp_rec;      -- emp_table(100) := 한행정보 
            
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(emp_table(100).employee_id);
END;
/


--------------EMP테이블 모든 칼럼 다넣기 

DECLARE

        TYPE emp_table_type IS TABLE OF employees%ROWTYPE       --테이블 생성 
             INDEX BY BINARY_INTEGER;
             
        emp_table emp_table_type;     --테이블 
        emp_rec employees%ROWTYPE;    --레코드 
        
        firstid employees.employee_id%type;   --첫번째 ID
        lastid employees.employee_id%type;    --마지막 ID 
        
        
BEGIN

            SELECT  MIN(employee_id) , MAX(employee_id)
            INTO  firstid, lastid 
            FROM employees;
            
            
            DBMS_OUTPUT.PUT_LINE(firstid);
            
            FOR eid IN firstid ..lastid  LOOP
            SELECT *
            INTO emp_rec
            FROM employees
            WHERE employee_id =eid;
            
            emp_table(eid) := emp_rec;     --배열에 값넣기  
            
            END LOOP;
        
             FOR idx IN emp_table.FIRST..emp_table.LAST LOOP
            DBMS_OUTPUT.PUT(emp_table(idx).employee_id || ' ,');
            DBMS_OUTPUT.PUT_LINE(emp_table(idx).last_name);
            END LOOP;
END;
/
        
        
    
--------------------emp테이블 전체가져오기  교수님꺼 

DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응하는 레코드. 객체 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;  --테이블 선언 
    
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)             ---데이터 존재여부 확인 
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN   -- 데이터가 없다면 0이 반환됨  >>사원이없다면 continue; 
            CONTINUE;
        END IF;
        
        SELECT *                        --데이터가있다면 한행을 emp_record에 넣어라 
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     --배열에 값넣기 
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/



---------------------------커서 

--명시적커서 --select 절을 기반으로해서 만들어짐  //둘이상 행을 반환할때 // into절 필요없음..

--암시적 커서는 dml사용해서1행 반환..체크가능함// select into 

DECLARE 
        CURSOR emp_dept_cursor  IS     --그냥 선언만 한거임 
                SELECT employee_id , last_name    --   = INTO v_eid, v_ename;   같아야함 
                FROM  employees
                where department_id =&부서번호;  --없는거 치면 open 시도는 하는데  select 결과가 없어도  ****오류는 안남. 
                
            v_eid employees.employee_id%type;
            v_ename employees.last_name%type;

BEGIN
        OPEN emp_dept_cursor ; --실제 SELECT가 실행되는 순간   !!  부서번호가 '50인 애들이 쌓여있음..  >> 메모리에 올라간 상태 
        
        FETCH emp_dept_cursor INTO v_eid, v_ename;      --  FETCH 포인터를 이용해서 데이터 출력 !!!!!  ( 한 행 전체를 가지고 오는거만 가능. ) 
        DBMS_OUTPUT.PUT_LINE(v_eid);
        DBMS_OUTPUT.PUT_LINE(v_ename);
        CLOSE  emp_dept_cursor;  -- 커서 없애기.. 없애면 암것도 못함 닫혀진 커서에서 실행할 경우 INVALID CURSO R
        
END;
/



---------------------------------------------------------------------------------------

DECLARE
        CURSOR emp_info_cursor IS 
                SELECT employee_id eid, last_name ename, hire_date hdate
                FROM employees
                where department_id =&부서번호
                ORDER BY hire_date DESC;
                
         emp_rec emp_info_cursor%ROWTYPE;      --select 한 결과를 기반으로     --한행 
         
         
BEGIN
        OPEN emp_info_cursor;
        
        LOOP 
                FETCH emp_info_cursor INTO emp_rec;   --결과를 레코드에 넣어라.. 
                --EXIT WHEN emp_info_cursor%NOTFOUND;  --종료조건으로 NOTFOUND 써야  데이터 양에따라 유동적으로... 
                --EXIT WHEN emp_info_cursor%ROWCOUNT >10;  --emp_info_cursor%ROWCOUNT 반환된 행이 10건 넘어가면 스탑   //  NOTFOUND 와 ROWCOUNT 동시에 사용할것 
                
                
                EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT >10;
                
                DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT ||',');
                DBMS_OUTPUT.PUT(emp_rec.eid ||',');
                DBMS_OUTPUT.PUT(emp_rec.ename||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
        END LOOP;
        
             IF emp_info_cursor%ROWCOUNT = 0 THEN  --끝난 시점에  커서의  총 데이터 숫자를 뜻함 루프문을 돌고나서도 ROWCOUNT가 0이라는 말  >> 단한번도 FETCH가 실행안되었다는말  >>루프안에서는 존재할수없음..
            DBMS_OUTPUT.PUT_LINE('ㄷㅔ이터존재X');   --클로즈 전에 써야함.. 
            END IF;
        
        
        CLOSE emp_info_cursor;
        
END;
/

--EXIT WHEN emp_info_cursor%ROWCOUNT >10;  --emp_info_cursor%ROWCOUNT 반환된 행이 10건 넘어가면 스탑  최대 크기가 10이 아닌애들은 걸러내지 못함 
---------------------------------------------------------------------------
 SELECT employee_id eid, last_name ename, hire_date hdate
                FROM employees
                ORDER BY hire_date DESC;
                
                --별칭을..
---------------------------------------------------------------------------------


-- 모든 사원의 사원번호, 이름 부서이름 출력

DECLARE
        CURSOR emp_info_cursor IS 
                SELECT e.employee_id eid, e.last_name ename, d.department_name dname
                FROM employees e left join departments d on (e.department_id=d.department_id)       
                order by eid;
                         
         emp_rec emp_info_cursor%ROWTYPE;      --select 한 결과를 기반으로     --한행 
         
BEGIN

         OPEN emp_info_cursor;
         
         LOOP 
                FETCH emp_info_cursor INTO emp_rec;  
                 
               EXIT WHEN emp_info_cursor%NOTFOUND;  --먼저 체크하고  밑 코드 수행 
                 
                DBMS_OUTPUT.PUT(emp_rec.eid ||',');
                DBMS_OUTPUT.PUT(emp_rec.ename||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.dname);
                      
         END LOOP;
         
         
        CLOSE emp_info_cursor;

END;
/



--부서번호가 50이거나 80인 사원들의  ///  사원이름, 급여, 연봉 출력
--(salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))

--------------------1번째방식 
DECLARE
       CURSOR emp_info_cursor IS 
                SELECT last_name  , salary , (salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))as total
                FROM employees
                WHERE department_id IN (50,80);
             
                       
         emp_rec emp_info_cursor%ROWTYPE;       --한행 

BEGIN
         IF NOT emp_info_cursor%ISOPEN THEN  --ㅋㅓ서가 열려있지 않다면 열어라..
         OPEN emp_info_cursor;
         END IF;      
   
         LOOP 
                FETCH emp_info_cursor INTO emp_rec;  
                 
               EXIT WHEN emp_info_cursor%NOTFOUND;  --먼저 체크하고  밑 코드 수행 
                 
                DBMS_OUTPUT.PUT(emp_rec.last_name ||',');
                DBMS_OUTPUT.PUT(emp_rec.salary||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.total);
                      
         END LOOP;
         
         
        CLOSE emp_info_cursor;

END;
/
--------------------2번째방식.. 다시적어라!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

DECLARE
    CURSOR emp_sal_cursor IS
        SELECT employee_id, salary, commission_pct
        FROM employees
        WHERE department_id IN(50,80)
        ORDER BY department_id;
        
    v_eid employees.employee_id%TYPE;
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    OPEN emp_sal_cursor;
    
    LOOP
        FETCH emp_sal_cursor INTO v_eid, v_sal, v_comm;
        EXIT WHEN emp_sal_cursor%NOTFOUND;
        
        v_annual := NVL(v_sal, 0) * 12 + NVL(v_sal, 0) * NVL(v_comm, 0) * 12;
        DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_sal || ', ' || v_annual);        
    END LOOP;
    CLOSE emp_sal_cursor;
END;
/

--변수의 타입을 복사하고싶다면 타입

--emp_rec  employess%ROWTYPE  테이블,뷰,커서 만 rowtype
--emp-info  emp_rec%type
 