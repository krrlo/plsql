SET SERVEROUTPUT ON 


--Ŀ��+ for loop �� open fetch close ��þ��ص���  �˾Ƽ� ����..
DECLARE
        CURSOR emp_cursor IS
                SELECT employee_id , last_name , job_id
                FROM employees
                WHERE department_id =&�μ���ȣ;   --�����Ͱ� ���°� ������ FOR LOOP��ü�� �������� .. 
                               
BEGIN
         FOR emp_rec IN  emp_cursor  LOOP   
                DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT ||',');
                DBMS_OUTPUT.PUT(emp_rec.employee_id);
                DBMS_OUTPUT.PUT(emp_rec.last_name);
                DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
   
        END LOOP;  --Ŀ���� ���⼭ �� ����  
        
       -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT); ������.. 
END;

/



----���������� for loop �����... ��ȸ�� Ŀ�� �̸��� �������� ����. Ŀ���� �Ӽ��� ����Ҽ� X


BEGIN 
        FOR emp_rec IN (SELECT employee_id , last_name            ---- IN (Ŀ��) ���ϰ�.. 
                                 FROM employees
                                 WHERE department_id = &�μ���ȣ ) LOOP 
          
            DBMS_OUTPUT.PUT(emp_rec.employee_id);
            DBMS_OUTPUT.PUT_LINE(emp_rec.last_name);  
        
        END LOOP;
        
        
END;
/



--------------------------1)  �����ȣ , �̸�, �μ��̸�  FOR �̿� 


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



-------2)   �������ϱ�  for 

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



----- 2-1 �������ϱ� �⺻ 


DECLARE

    CURSOR emp_sal_cursor IS
        SELECT last_name, salary, commission_pct
        FROM employees
        WHERE department_id IN(50,80)
        ORDER BY department_id;
        
        emp_rec emp_sal_cursor%ROWTYPE;  --Ŀ�������� 
        v_annual employees.salary%TYPE;  --������� 
    
    
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



-------------------------------�Ű����� Ŀ�� ������ �Է� X     


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



-----���� �����ϴ� ��� �μ��� �� �Ҽӻ���� ����ϰ�, ���°�� ���� �Ҽӻ���� �����ϴ� ���

---�μ��� : �μ� Ǯ����
--1.�����ȣ, ����̸� , �Ի���, ����
--Ŀ�� 2�� ������ 2�� 

DECLARE

      --�Ϲ�Ŀ��  �μ��̸�, �Ű����� �ʿ��ϱ⶧���� ���� Ŀ�� 
             CURSOR dept_cursor IS
             SELECT department_name , department_id
             FROM departments;
  --��� �μ��ϱ� where�� �ʿ����    --for Ŀ�� �������� , ������ ���� ��찡 �����ϱ�.. 
  
      --�Ű��������ִ�Ŀ�� 
        CURSOR emp_cursor
             (deptid number) IS
        SELECT last_name, hire_date, job_id
        FROM employees
        WHERE department_id =deptid;                --�����Ͱ� ���� ��찡 �����ϱ� �⺻���� ������� �������� 
        
    
         emp_rec emp_cursor%ROWTYPE;  -- emp cursor �־�ߵǴϱ�..
     

BEGIN
    FOR dept_rec IN dept_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE('====�μ���' || dept_rec.department_name);
        
        OPEN emp_cursor(dept_rec.department_id);  --�Ű��� �־���� 
        
        LOOP 
                FETCH emp_cursor INTO emp_rec;
                EXIT WHEN emp_cursor%NOTFOUND;
                
                DBMS_OUTPUT.PUT(emp_rec.last_name);
                DBMS_OUTPUT.PUT(emp_rec.hire_date);
                DBMS_OUTPUT.PUT_LINE(emp_rec.job_id);
                 
         END LOOP;  --�⺻���� ��       
      
      
       IF emp_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ҽӵ� ����� �����ϴ�');
       END IF;
       
        CLOSE emp_cursor;
    END LOOP;    --for �� 
END;
/

-------------- �Ű����� �ִ� Ŀ�� for ���� 



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
                    
    END LOOP;    --for �� 
END;
/


-------------FOR UPDATE ���� ��� ���ص� �ȴ� 

-- FOR UPDATE, WHERE CURRENT OF    --PK�� ��� UPDATE������. 
DECLARE
    CURSOR sal_info_cursor IS
        SELECT salary, commission_pct
        FROM employees
        WHERE department_id = 60
        FOR UPDATE OF salary, commission_pct NOWAIT;
BEGIN
    FOR sal_info IN sal_info_cursor LOOP  
        IF sal_info.commission_pct IS NULL THEN    ---NULL�̸� 10�� �λ� 
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
--1) �̹� ���ǵǾ��ְ� �̸��� �����ϴ� ���ܻ���   20������..
DECLARE
        v_ename employees.last_name%TYPE;
BEGIN
        SELECT last_name
        INTO v_ename
        FROM employees
        WHERE department_id =&�μ���ȣ;
        
        DBMS_OUTPUT.PUT_LINE(v_ename);
        
        --���� ����Ǵ� �� �ؿ� ����
EXCEPTION
        WHEN NO_DATA_FOUND THEN                                                                                             --select �������� �۵��ϴ� ����  NO_DATA_FOUND,TOO_MANY_ROWS
            DBMS_OUTPUT.PUT_LINE('�ش�μ��� �Ҽӵ� ����� �����ϴ�');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('�ش�μ��� �������� ���������');
            DBMS_OUTPUT.PUT_LINE('����ó���� �������ϴ�'); 
END;
/


--���ܹ߻��ϸ� �ٷ� �ͼ������� ����  no_data_found ���� �����޼��� ���
--���ܴ� �ѰǸ� �۵���.. ���ÿ� ���۵�������. ���ܰ� �߻��ϸ�  �ϳ��� ����ǰ� ������ 


---2) �̹� ���Ǵ� �Ǿ������� ������ �̸��� �������� �ʴ� ���ܻ���

DECLARE 

e_emps_remaining EXCEPTION;   --���� �̸� ; 
PRAGMA EXCEPTION_INIT(e_emps_remaining,-02292);  --���� ���ܿ� ���� ���� �����̸��� ����  PRAGMA��ɾ� �Է� .  

BEGIN      
    DELETE FROM departments
    WHERE department_id =&�μ���ȣ;    -- child record found �ڽķ��ڵ尡 �ִ°�� ������ ����.. .. �̸��� �������� ������ 
    
    
EXCEPTION
        WHEN e_emps_remaining  THEN
            DBMS_OUTPUT.PUT_LINE('�ڽ�������');
       
END;
/


------------3) ����� ���� ����... ����Ŭ�� �̹� ���ǵ� ���ܰ� �ƴϿ�����.   �����ܾ��� -�� �ƴ� ��츸 ..  if������ ó���ϸ�  �� �ڿ� �ڵ尡 ������ �Ǵϱ� .. ���ƿ� ó���ϸ� �ڿ� �ڵ� ������ ���⶧����..

DECLARE
        e_no_deptno EXCEPTION;   --�������̸� ���� 
        v_ex_code NUMBER;
        v_ex_msg VARCHAR2(1000);
BEGIN
          DELETE FROM departments
          WHERE department_id =&�μ���ȣ;    --���� �μ� �־  ������ ������ ���� �ȳ����ϱ�..ȥ�� 
  
        IF SQL%ROWCOUNT =0 THEN
                RAISE e_no_deptno;    --IF���ڿ� �ִ�   DBMS_OUTPUT.PUT_LINE('�ش�μ� ��ȣ�� �����Ǿ����ϴ�.'); �� �ڵ尡 ���� �ȵ�  �ٷ� ���� ���� �� 
                -- DBMS_OUTPUT.PUT_LINE('�ش�μ� ��ȣ ���� X');  -- �� �ϸ� DBMS_OUTPUT.PUT_LINE('�ش�μ� ��ȣ�� �����Ǿ����ϴ�.'); �� �ڵ���� ������ �� 
        END IF;        
    
        DBMS_OUTPUT.PUT_LINE('�ش�μ� ��ȣ�� �����Ǿ����ϴ�.');

EXCEPTION
        WHEN  e_no_deptno THEN
                DBMS_OUTPUT.PUT_LINE('�ش�μ� ��ȣ ���� X');   --���� ��ȣ ���� ������ 
        WHEN OTHERS THEN        --�ִ� �μ� ��������� 
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



--test_employee ���̺��� ����Ͽ� Ư�� ����� ���� �ϴ� .. 
--������ ����� >> ġȯ���� 
--�ش����� ���� ��츦 Ȯ���ؼ� '�ش� ����� �������� �ʽ��ϴ� ' �� ��� 


DECLARE
        v_eid employees.employee_id%type :=&�����ȣ;
        e_no_empid EXCEPTION;   --�������̸� ���� 
        
BEGIN
          DELETE FROM test_employee
          WHERE employee_id =v_eid;    
  
        IF SQL%ROWCOUNT =0 THEN
                RAISE  e_no_empid;    
        END IF;        
    
        DBMS_OUTPUT.PUT_LINE(v_eid||'�ش����� �����Ǿ����ϴ�.');

EXCEPTION
        WHEN e_no_empid THEN
                DBMS_OUTPUT.PUT_LINE(v_eid||'�ش����� ���� �����ʽ��ϴ�.....');   
END;
/

select * from test_employee;




-------------------------------------------procedure �����ϱ�!!!!!!!!!!!!!!!!!!

CREATE OR REPLACE PROCEDURE test_pro   --2. ������ or replace �߰� ..  ���ν����� �����ϴ� ��� ��ü�ϰڴ�..  
--()
IS
--DECLARE :����� ��ġ  ������ ������.  IS�� BEGIN���� 
--��������, ���ڵ� , Ŀ��, EXCEPTION  ���𰡴�  

BEGIN
        DBMS_OUTPUT.PUT_LINE('first ');  ---���۾��� .. 

EXCEPTION 
        WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('����ó��');
END;    --���������� ��  ����ó�� �������൵  .. �����Ϸ��� 1. �����ϰ� 
/

--procedure ������: CREATE OR REPLACE �ϴ���  2.TEST_PRO���� ��ġ����..

--------------------------PROCEDURE�����Ű��   1) ���ȿ��� ������Ѿ��� ..
BEGIN
    test_pro;
END;
/

--------------------------PROCEDURE�����Ű��   2) execute ��ɾ���

EXECUTE test_pro;   --Ư�� procedure��.. ���� execute�� ���������� ��� �����ؼ� ����־���   --in��常 ����


-----------------------------------------------procedure �����ϱ�!!!!!!!!!!!!!!!!!!
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


---------------------------------- in �����Ű��-----------------------
EXECUTE raise_salary (100);


--------------------------in �����Ű��


DECLARE
    
    v_id employees.employee_id%type :=&�����ȣ;
    v_num CONSTANT NUMBER := v_id;   --���

BEGIN

    raise_salary(v_id);   --�Ű� ������ ���´�  ������ ���� 
    raise_salary(v_num);   --����� �����ϰ� 
    raise_salary(v_num +100);  --�������� ���� 
    raise_salary(200);
     
END;
/


------------------------------------out  

CREATE or replace PROCEDURE pro_plus 
(p_x IN NUMBER,  --�� �о� 10
p_y IN NUMBER,  --�� 12
p_result OUT NUMBER)   --������  .. �ƹ����� �Ҵ� �����ָ� null���� ������..

IS 
         v_sum NUMBER;
         
BEGIN
        DBMS_OUTPUT.PUT(p_x);
        DBMS_OUTPUT.PUT('+'||p_y);
        DBMS_OUTPUT.PUT_LINE('=' || p_result);
     
        v_sum :=p_x+p_y;
           --v_sum :=p_x+p_y+p_result == null�� p_result�갡 �Τ��Ӵϱ� 
           
         p_result :=p_x+p_y;   --�ƿ���尡 ���� �������Ӱ� �ϴ� �κ� ,,,,,,
         
END;
/


-------------------------------out �����Ű�� 
DECLARE
    
     v_first NUMBER :=10;
     v_second NUMBER :=12;
     v_result NUMBER :=100;  --���ξְ� ���ͼ� result ���� �����..?
 
BEGIN
        DBMS_OUTPUT.PUT_LINE('��'||v_result);
        pro_plus(v_first , v_second, v_result);    --���ν����� ���� 10+12=  ������ �Ѿ���� 
        DBMS_OUTPUT.PUT_LINE('��'||v_result);  --p_result :=p_x+p_y; �̰ž����ָ� �� ���� 
END;
/


-----------------------------------------in out  
----------���˺����Ҷ� ��� 010-4131-4226����,


CREATE  PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2) --���¾�  ������  ���� ���� ��� 

IS 
         
         
BEGIN
        --���� ���� �� �ٽ� �������� 
        p_phone_no := SUBSTR( p_phone_no,1,3)
                             ||'-'|| SUBSTR( p_phone_no,4,4)
                             ||'-'|| SUBSTR( p_phone_no,8);
END;
/


-------------------------------INOUT �����Ű�� 
DECLARE
    
   v_no VARCHAR2(50) := '01041314226';   
 
BEGIN
       DBMS_OUTPUT.PUT_LINE('��'||v_no);
       format_phone(v_no);
       DBMS_OUTPUT.PUT_LINE('��'||v_no);
       
END;
/

------------------------------------------------����Ǭ�� -----


---1) �ֹι�ȣ �Է��ϸ� 940907-2******��µǰ�


CREATE  OR REPLACE PROCEDURE yedam_ju
(num_no IN OUT VARCHAR2) --���¾�  ������  ���� ���� ��� 

IS          
         
BEGIN
        --���� ���� �� �ٽ� �������� 
       num_no := SUBSTR(num_no,1,6)
                             ||'-'|| SUBSTR(num_no,8,1)
                             ||'******';
                             
       
END;
/


-------------------------------INOUT �����Ű�� 
DECLARE
    
   v_no VARCHAR2(50) := '9409072454545';   
 
BEGIN
      
    yedam_ju(v_no);
     DBMS_OUTPUT.PUT_LINE(v_no);
       
END;
/

---------2) �ش� �ֹε�Ϲ�ȣ�� �������� ���� ��������� ����ϴ� �κе� �߰� ----940907>> 1994�� 09�� 07�� 



CREATE  OR REPLACE PROCEDURE yedam_juu
(num_no IN VARCHAR2,
 new_no OUT DATE
) 


IS          
         
BEGIN
      
      new_no := TO_DATE(SUBSTR(num_no,6), 'YYYY��MM��dd��');
                                                                      

END;
/


-------------------------------INOUT �����Ű�� 
DECLARE
    
  
   v_no VARCHAR2(50) := '9409072454545';   
    
BEGIN
      
    yedam_juu(v_no);
     DBMS_OUTPUT.PUT_LINE(v_no);
       
END;
/



----------------------------------------------




-------------���� Ǯ�� ����

/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******

--rr�� 00~49 ġ�� 1900~1949 / 50~99ġ�� 2050~2099
--�ֳĸ� ������ 2023�̶� 00~49���̶�
  
�߰�)
 �ش� �ֹε�Ϲ�ȣ�� �������� ���� ��������� ����ϴ� �κе� �߰�
 9501011667777 => 1995��01��01��
 1511013689977 => 2015��11��01��
*/

-----------------------------1)

CREATE  OR REPLACE PROCEDURE yedam_ju
(num_no IN VARCHAR2) 

IS       

    v_result VARCHAR2(100);
    
BEGIN 
       -- v_result := SUBSTR(num_no,1,6) || '-' || (SUBSTR(num_no,7,1),7, '*');  --���� 
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
        v_birth :='19' ||SUBSTR(num_no,1,2) ||'��'
                          ||SUBSTR(num_no,3,2) ||'��'
                        ||SUBSTR(num_no,5,2) ||'��';
                        
    ELSIF  v_gender IN ('3', '4') THEN
        v_birth :='20' ||SUBSTR(num_no,1,2) ||'��'
                          ||SUBSTR(num_no,3,2) ||'��'
                        ||SUBSTR(num_no,5,2) ||'��';
                                           
   END IF;
   
   DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/

EXECUTE yedam_ju('0509073675718');



--------------------------------------------------------------

/*
2.
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/



CREATE  OR REPLACE PROCEDURE TEST_PRO 
(emp_id IN NUMBER) 

IS       

    
BEGIN 
     
     DELETE FROM test_employee
     WHERE employee_id = emp_id;
     
     IF SQL%ROWCOUNT =0 THEN        
        DBMS_OUTPUT.PUT_LINE('�ش����� ���� X'); 
    END IF;        
    
END;
/

EXECUTE TEST_PRO(175);

SELECT  * FROM test_employee;


/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
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


      v_name := SUBSTR(v_name,1,1) ||  RPAD(SUBSTR(num_no,7,1),7, '*');   --�̸� ������ -1��ŭ ��ǥ 
        
     DBMS_OUTPUT.PUT_LINE(v_name);
    
END;
/


EXECUTE yedam_emp(176)







/*
4.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
*/
/*
5.
������ ���� ���̺��� �����Ͻÿ�.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
5-1.
�μ���ȣ�� �Է��ϸ� ����� �߿��� �Ի�⵵�� 2005�� ���� �Ի��� ����� yedam01 ���̺� �Է��ϰ�,
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� yedam02 ���̺� �Է��ϴ� y_proc ���ν����� �����Ͻÿ�.
 
5-2.
1. ��, �μ���ȣ�� ���� ��� "�ش�μ��� �����ϴ�" ����ó��
2. ��, �ش��ϴ� �μ��� ����� ���� ��� "�ش�μ��� ����� �����ϴ�" ����ó��
*/





