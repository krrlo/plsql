SET SERVEROUTPUT ON 


--2 �Է��ϸ� �ش� �������� ��µǵ��� 


--�⺻�̿� 

DECLARE
    v_dan NUMBER(1,0) :=&���Է�;
    v_num NUMBER :=1;
BEGIN

    LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
        v_num := v_num+1;
   
    EXIT WHEN v_num >9 ;
    END LOOP;

END;
/


---FOR ������ �̿� 
DECLARE

v_dan NUMBER(1,0) :=&���Է�;

BEGIN

    FOR v_num IN 1..9 LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
    END LOOP;
    
END;
/


--WHILE �̿�

DECLARE
    v_dan NUMBER(1,0) :=&���Է�;
    v_num NUMBER :=1;
BEGIN

    WHILE v_num <=9  LOOP 
        DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
        v_num := v_num+1;
    END LOOP;

END;
/

----------------------------------------------------------------------------------------------------------------------

--������ 2~9�ܱ��� ��µǵ��� (���߹ݺ���)
--DECLARE

---�����̿� 
BEGIN
    FOR a IN 2..8 LOOP
        FOR b IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(a || '*' || b || '='||(a*b));
      END LOOP;
    END LOOP;
END;
/


---while�̿� ������.. 
DECLARE 
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) :=1;
BEGIN 
     WHILE v_num <10 LOOP   --�ٱ� ������  1���� ���� 
     v_dan :=2;  --�ʱⰪ �ֱ�   --���� ���ϴ� ��  2�ܺ��� �����̴ϱ�.. 
            WHILE v_dan <10 LOOP
             DBMS_OUTPUT.PUT(v_dan ||'x'|| v_num || '=' || (v_dan*v_num) || ' ');
             v_dan := v_dan+1;  --2>>3������ ���� 
            END LOOP;
     DBMS_OUTPUT.PUT_LINE('');  --�ٹٲٱ� 
     v_num := v_num +1;
     END LOOP;
 END;
 /
        

---while ������

DECLARE 
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) :=1;
    v_msg VARCHAR2(1000);
BEGIN 
     WHILE v_num <10 LOOP
     v_dan :=2;  --�ʱⰪ �ٽ� �ֱ� 
            WHILE v_dan <10 LOOP
              v_msg := v_dan ||'x'|| v_num || '=' || (v_dan*v_num) || ' ';
             DBMS_OUTPUT.PUT(RPAD(v_msg,12,' '));  --������ lpad
             v_dan := v_dan+1;
            END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    v_num := v_num +1;
    END LOOP;
 END;
 /




---������ 1~9�ܱ��� ��µǵ���. Ȧ���ܸ� ���  (���߹ݺ���)

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


---������ 1~9�ܱ��� ��µǵ���. Ȧ���ܸ� ���  ( FOR �� ���߹ݺ���)

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

---������ 1~9�ܱ��� ��µǵ���. Ȧ���ܸ� ���  ( FOR  continue)


BEGIN 
    FOR v_dan IN 1..9 LOOP
            IF MOD(v_dan,2) = 0 THEN
                    CONTINUE;    -- ¦���� �������ڴ� 
            END IF;
                    
                FOR v_num IN 1..9 LOOP
                    DBMS_OUTPUT.PUT_LINE(v_dan || '*' || v_num || '=' || (v_dan*v_num));
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
     END LOOP;
END;
/

-----------------------------���յ����� 


DECLARE
    TYPE info_rec_type IS RECORD   --�� Ÿ���� ���ڵ� ������ ������� �մϴ�...   --���� ������ �����  �ٸ� ������ �ʿ��ϸ� ����..
        ( no NUMBER NOT NULL :=1,                     --�ʵ������   (�ʵ��̸�)(������Ÿ��)(��������) (�ʿ��ϴٸ� ���ֱ�)
        name VARCHAR2(1000) :='NO name',
         birth DATE);
         
        user_info info_rec_type ;   --����Ϸ��� �������� �ؾ���  (user_info) (info_rec_type) ; 
        
BEGIN
    user_info.birth := sysdate;
    DBMS_OUTPUT.PUT_LINE(user_info.birth);  -- �׳� user_info �ϸ� ���Ұ�
  
END;
/




DECLARE
    emp_info_rec employees%ROWTYPE;   --�̹������ϰ��ִ� *****�����̺��� ������ �޾ƿö� rec Ÿ�Ծ� , �ٸ����̺� �����ö��� �Ѱ谡����..
BEGIN
    SELECT *
    INTO emp_info_rec        --���ڵ忡 ���� �ֱ� 
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.first_name);
    DBMS_OUTPUT.PUT_LINE(emp_info_rec.last_name);
END;
/


--�����ȣ �̸� �μ��̸� 

DECLARE

    TYPE emp_rec_type IS RECORD                                                                         ---�ٸ����̺� �����ö� 
        (eid employees.employee_id%type,   --number
         ename employees.last_name%type,       --varchar2
         deptname departments.department_name%type);  --varchar2
         
       emp_rec emp_rec_type;
       
       
BEGIN
    SELECT employee_id, job_id, first_name     --�����۵���  �ʵ��� �������.  number , var, var
    INTO   emp_rec
    FROM  employees  join departments 
                            using(department_id)    
    where employee_id = &�����ȣ;
    
     DBMS_OUTPUT.PUT_LINE(emp_rec.ename);
    
END;
/



--�������� ���� 

DECLARE

    TYPE emp_rec_type IS RECORD                                                                        
        (eid employees.employee_id%type,   --number
         ename employees.last_name%type,       --varchar2
         deptname departments.department_name%type);  --varchar2
         
       emp_rec emp_rec_type;
       
       
BEGIN
    SELECT employee_id, last_name, department_name       --* ������ ���ڵ� ���� �ʵ忡 ��ü �ʵ尡 �� �־����  ���ڵ��ʵ� ����ŭ ����Ʈ���� ���� 
    INTO   emp_rec
    FROM  employees  join departments 
                            using(department_id)    
    where employee_id = &�����ȣ;
    
     DBMS_OUTPUT.PUT_LINE(emp_rec.ename);
    
END;
/


--------------------------------------���̺� �迭�� ������ 
---���̺� ���� ���ֱ� 

DECLARE
        --����
        TYPE  num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        --����
        num_list num_table_type;    --(num_list)  (num_table_type);  
BEGIN

--arrar[0] =>table(0)
    num_list(-1000) := 1;
    num_list(1234) := 2;
    num_list(11111) := 3;


    DBMS_OUTPUT.PUT_LINE(num_list.count);  -->count �޼ҵ� ��� 
    DBMS_OUTPUT.PUT_LINE(num_list(1234));  
    

END;
/





--�� ���� 
---���̺� ���� ��

DECLARE
        --����
        TYPE  num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        --����
        num_list num_table_type;    --(num_list)  (num_table_type);  
BEGIN
    FOR i IN 1..9 LOOP
        num_list(i) := 2*1;
    END LOOP;
    
    --�迭 �� �������..
    FOR idx IN num_list.FIRST .. num_list.LAST LOOP   
        IF num_list.EXISTS(idx) THEN    --num_list.EXISTS(idx) ���������� true
            DBMS_OUTPUT.PUT_LINE(num_list(idx));
        END IF;
    END LOOP;

END;
/



----���̺�
--���ϰ��� �ƴ� ���ڵ尡 ���ٸ�

DECLARE
        TYPE emp_table_type IS TABLE OF employees%ROWTYPE    --������ Ÿ���� ���ڵ�Ÿ���� ��      emp_rec employees%ROWTYPE;  --���࿡ ���� ������ ������  �� ���⿡ �����ִ� ���� ������ Ÿ���̶� 
             INDEX BY BINARY_INTEGER;
             
        emp_table emp_table_type;  --���̺�
        emp_rec employees%ROWTYPE;  --���࿡ ���� ������ ������ 
        
BEGIN
        FOR eid IN 100..110 LOOP
            SELECT *
            INTO emp_rec
            FROM employees
            WHERE employee_id =eid;
            
            emp_table(eid) := emp_rec;      -- emp_table(100) := �������� 
            
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(emp_table(100).employee_id);
END;
/


--------------EMP���̺� ��� Į�� �ٳֱ� 

DECLARE

        TYPE emp_table_type IS TABLE OF employees%ROWTYPE       --���̺� ���� 
             INDEX BY BINARY_INTEGER;
             
        emp_table emp_table_type;     --���̺� 
        emp_rec employees%ROWTYPE;    --���ڵ� 
        
        firstid employees.employee_id%type;   --ù��° ID
        lastid employees.employee_id%type;    --������ ID 
        
        
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
            
            emp_table(eid) := emp_rec;     --�迭�� ���ֱ�  
            
            END LOOP;
        
             FOR idx IN emp_table.FIRST..emp_table.LAST LOOP
            DBMS_OUTPUT.PUT(emp_table(idx).employee_id || ' ,');
            DBMS_OUTPUT.PUT_LINE(emp_table(idx).last_name);
            END LOOP;
END;
/
        
        
    
--------------------emp���̺� ��ü��������  �����Բ� 

DECLARE
    v_min employees.employee_id%TYPE; -- �ּ� �����ȣ
    v_MAX employees.employee_id%TYPE; -- �ִ� �����ȣ
    v_result NUMBER(1,0);             -- ����� ���������� Ȯ��
    emp_record employees%ROWTYPE;     -- Employees ���̺��� �� �࿡ �����ϴ� ���ڵ�. ��ü 
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;  --���̺� ���� 
    
BEGIN
    -- �ּ� �����ȣ, �ִ� �����ȣ
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)             ---������ ���翩�� Ȯ�� 
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN   -- �����Ͱ� ���ٸ� 0�� ��ȯ��  >>����̾��ٸ� continue; 
            CONTINUE;
        END IF;
        
        SELECT *                        --�����Ͱ��ִٸ� ������ emp_record�� �־�� 
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     --�迭�� ���ֱ� 
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/



---------------------------Ŀ�� 

--�����Ŀ�� --select ���� ��������ؼ� �������  //���̻� ���� ��ȯ�Ҷ� // into�� �ʿ����..

--�Ͻ��� Ŀ���� dml����ؼ�1�� ��ȯ..üũ������// select into 

DECLARE 
        CURSOR emp_dept_cursor  IS     --�׳� ���� �Ѱ��� 
                SELECT employee_id , last_name    --   = INTO v_eid, v_ename;   ���ƾ��� 
                FROM  employees
                where department_id =&�μ���ȣ;  --���°� ġ�� open �õ��� �ϴµ�  select ����� ���  ****������ �ȳ�. 
                
            v_eid employees.employee_id%type;
            v_ename employees.last_name%type;

BEGIN
        OPEN emp_dept_cursor ; --���� SELECT�� ����Ǵ� ����   !!  �μ���ȣ�� '50�� �ֵ��� �׿�����..  >> �޸𸮿� �ö� ���� 
        
        FETCH emp_dept_cursor INTO v_eid, v_ename;      --  FETCH �����͸� �̿��ؼ� ������ ��� !!!!!  ( �� �� ��ü�� ������ ���°Ÿ� ����. ) 
        DBMS_OUTPUT.PUT_LINE(v_eid);
        DBMS_OUTPUT.PUT_LINE(v_ename);
        CLOSE  emp_dept_cursor;  -- Ŀ�� ���ֱ�.. ���ָ� �ϰ͵� ���� ������ Ŀ������ ������ ��� INVALID CURSO R
        
END;
/



---------------------------------------------------------------------------------------

DECLARE
        CURSOR emp_info_cursor IS 
                SELECT employee_id eid, last_name ename, hire_date hdate
                FROM employees
                where department_id =&�μ���ȣ
                ORDER BY hire_date DESC;
                
         emp_rec emp_info_cursor%ROWTYPE;      --select �� ����� �������     --���� 
         
         
BEGIN
        OPEN emp_info_cursor;
        
        LOOP 
                FETCH emp_info_cursor INTO emp_rec;   --����� ���ڵ忡 �־��.. 
                --EXIT WHEN emp_info_cursor%NOTFOUND;  --������������ NOTFOUND ���  ������ �翡���� ����������... 
                --EXIT WHEN emp_info_cursor%ROWCOUNT >10;  --emp_info_cursor%ROWCOUNT ��ȯ�� ���� 10�� �Ѿ�� ��ž   //  NOTFOUND �� ROWCOUNT ���ÿ� ����Ұ� 
                
                
                EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT >10;
                
                DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT ||',');
                DBMS_OUTPUT.PUT(emp_rec.eid ||',');
                DBMS_OUTPUT.PUT(emp_rec.ename||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
        END LOOP;
        
             IF emp_info_cursor%ROWCOUNT = 0 THEN  --���� ������  Ŀ����  �� ������ ���ڸ� ���� �������� �������� ROWCOUNT�� 0�̶�� ��  >> ���ѹ��� FETCH�� ����ȵǾ��ٴ¸�  >>�����ȿ����� �����Ҽ�����..
            DBMS_OUTPUT.PUT_LINE('������������X');   --Ŭ���� ���� �����.. 
            END IF;
        
        
        CLOSE emp_info_cursor;
        
END;
/

--EXIT WHEN emp_info_cursor%ROWCOUNT >10;  --emp_info_cursor%ROWCOUNT ��ȯ�� ���� 10�� �Ѿ�� ��ž  �ִ� ũ�Ⱑ 10�� �ƴѾֵ��� �ɷ����� ���� 
---------------------------------------------------------------------------
 SELECT employee_id eid, last_name ename, hire_date hdate
                FROM employees
                ORDER BY hire_date DESC;
                
                --��Ī��..
---------------------------------------------------------------------------------


-- ��� ����� �����ȣ, �̸� �μ��̸� ���

DECLARE
        CURSOR emp_info_cursor IS 
                SELECT e.employee_id eid, e.last_name ename, d.department_name dname
                FROM employees e left join departments d on (e.department_id=d.department_id)       
                order by eid;
                         
         emp_rec emp_info_cursor%ROWTYPE;      --select �� ����� �������     --���� 
         
BEGIN

         OPEN emp_info_cursor;
         
         LOOP 
                FETCH emp_info_cursor INTO emp_rec;  
                 
               EXIT WHEN emp_info_cursor%NOTFOUND;  --���� üũ�ϰ�  �� �ڵ� ���� 
                 
                DBMS_OUTPUT.PUT(emp_rec.eid ||',');
                DBMS_OUTPUT.PUT(emp_rec.ename||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.dname);
                      
         END LOOP;
         
         
        CLOSE emp_info_cursor;

END;
/



--�μ���ȣ�� 50�̰ų� 80�� �������  ///  ����̸�, �޿�, ���� ���
--(salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))

--------------------1��°��� 
DECLARE
       CURSOR emp_info_cursor IS 
                SELECT last_name  , salary , (salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))as total
                FROM employees
                WHERE department_id IN (50,80);
             
                       
         emp_rec emp_info_cursor%ROWTYPE;       --���� 

BEGIN
         IF NOT emp_info_cursor%ISOPEN THEN  --���ü��� �������� �ʴٸ� �����..
         OPEN emp_info_cursor;
         END IF;      
   
         LOOP 
                FETCH emp_info_cursor INTO emp_rec;  
                 
               EXIT WHEN emp_info_cursor%NOTFOUND;  --���� üũ�ϰ�  �� �ڵ� ���� 
                 
                DBMS_OUTPUT.PUT(emp_rec.last_name ||',');
                DBMS_OUTPUT.PUT(emp_rec.salary||',');
                DBMS_OUTPUT.PUT_LINE(emp_rec.total);
                      
         END LOOP;
         
         
        CLOSE emp_info_cursor;

END;
/
--------------------2��°���.. �ٽ������!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

--������ Ÿ���� �����ϰ�ʹٸ� Ÿ��

--emp_rec  employess%ROWTYPE  ���̺�,��,Ŀ�� �� rowtype
--emp-info  emp_rec%type
 