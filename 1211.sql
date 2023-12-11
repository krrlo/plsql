SET SERVEROUTPUT ON 

DECLARE 
v_eid  NUMBER;
v_ename employees.first_name%TYPE;
v_job VARCHAR2(1000);

BEGIN
    SELECT employee_id, first_name , job_id
    INTO v_eid , v_ename, v_job
    FROM   employees
    WHERE employee_id =100;   -- 0; �̶���ϸ�  --where���� �ƿ� ���ٸ�...  exact fetch returns more than requested number of row �����߻�.  �������� ��ȯ�Ǿ���ϹǷ� select �� Ȯ�� 
    --WHERE employee_id =0;   --"no data found"  ��� �� ���ǿ� �´� �����Ͱ� ���ٸ� ����ȵ� >>SELECT�� ����� ���ٴ¸�..
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_ename);
    DBMS_OUTPUT.PUT_LINE('����' || v_job);
END;
/

-- begin���� �ʿ��Ѱ� ���� ������ ���������ϱ� 



DECLARE
v_eid employees.employee_id%TYPE := &�����ȣ;   --ġȯ����  ���� ����Ǳ����� ��ü�Ǿ�� �Ѵ�   --ġȯ������ �⺻������ ���ڸ� �Է¹޵��ϵǾ�����.   ���� �Է��ҰŸ� ' ' ��������  '&�����ȣ'; ����ϴ��� 
                                                                        --���ھտ� 0�� ����־���Ѵٸ� ' ' ���� 
v_ename employees.last_name%TYPE;

BEGIN
  SELECT first_name||','||last_name
  INTO v_ename    --select ����� v_ename�� �־�� 
  FROM employees
  WHERE employee_id= v_eid;   --v_eid = ġȯ���� 
  
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || v_eid);    --ġȯ������ ���  
    DBMS_OUTPUT.PUT_LINE('����̸�' || v_ename);
    
    
    
END;
/


--1)Ư�� ����� �Ŵ����� �ش��ϴ�  �����ȣ�� ��� ( Ư�� ����� ġȯ���� ����ؼ� �Է¹�)

DECLARE
v_eid employees.employee_id%TYPE := &�����ȣ; 
v_manager employees.manager_id%TYPE;

BEGIN
    SELECT  manager_id
    INTO v_manager
    FROM employees
    WHERE employee_id = v_eid;
    -- WHERE employee_id = &�����ȣ;  ����ص���... 
    DBMS_OUTPUT.PUT_LINE('�Ŵ�����ȣ' || v_manager);    --ġȯ������ ���  
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);    --  SQL���� ����� ���� ���� 
       
END;
/

--pk���鶧 �ε��� �ڵ�����. index�� ������ ��´�. 
--departments  manager_id =  �μ����� ��Ī
--employees  manager_id = �� �Ŵ��� 
--���Ȯ���� ��信 �ֱ�

SELECT e.employee_id, e.first_name, e.manager_id, e2.employee_id, e2.first_name
FROM employees e , employees e2
WHERE e.manager_id= e2.employee_id;



--INSERT, UPDATE

DECLARE
v_deptno departments.department_id%TYPE;  --���̺��� ������� ���� 
v_comm employees.COMMISSION_PCT%TYPE := 0.1;   --�ٱ����� ������ ������ 
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    INSERT INTO employees(employee_id, last_name,email,hire_date,job_id,department_id)
    VALUES (1000,'Hong','hkd@naver.com',sysdate,'IT_PROG',v_deptno);      --job_id�� �θ� ���̺��ִ� �����͸� ������ 
    --unique constraint violated ����ũ �������� ���� 
    
    DBMS_OUTPUT.PUT_LINE('��ϰ��' || SQL%ROWCOUNT);
    UPDATE employees
    SET salary =(NVL(salary,0)+10000) *v_comm  --NULL�� ��뤷 �Ǵ� �÷��� NULL�ΰ�� �������� ���������  *******NVL(salary,0) �̷���..
    WHERE employee_id=1000; --  employee_id= 0 �־ ������ ��  --  ������� 0 ����  >> UPDATE�� ������� �ʾ���. 

    DBMS_OUTPUT.PUT_LINE('�������' || SQL%ROWCOUNT);   -- salary = 0�̶� UPDATE�� �����  ������� >> 1  ���� NULL�ϻ� 
END;
/

ROLLBACK;

select *from employees where employee_id = 1000;


BEGIN
    DELETE FROM employees
    WHERE employee_id =&�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN  --0�̳��Դٴ°� >> WHERE���� �������� �ʾƼ� ���°�  >>delete �� ������� �ʾ���. 
     DBMS_OUTPUT.PUT_LINE('�ش��� ���� X');
    END IF;
END;
/


--1 ��� ��ȣ�� �Է� (ġȯ����) //�����ȣ, ����̸�, �μ��̸� / �� ��� 

--�������� �Ҳ��� 

select employee_id,last_name,department_name
into v_no, v_name , v_depname
from employees join departments
on(employees.department_id = departments.department_id)
where employee_id =&�����ȣ;

--select 2�� ������

select employee_id , first_name, department_id
into v_no, v_name,v_depid
from employees
where employee_id =&�����ȣ;

select department_name
into v_depname
from departments
where department_id = v_depid;

-------------------------------------------------------------

DECLARE
v_no  employees.employee_id%TYPE :=&�����ȣ;   --emp���̺��� 
v_name employees.last_name%TYPE;   --emp���̺��� 
v_depname departments.DEPARTMENT_NAME%TYPE;   --departements���̺��� 
v_depid employees.department_id%TYPE;

BEGIN
 SELECT employee_id, last_name,(select DEPARTMENT_NAME from departments where e.DEPARTMENT_ID = DEPARTMENT_ID) as deptname   
 INTO v_no,v_name,v_depname
 FROM employees e
 WHERE employee_id = v_no;
 

DBMS_OUTPUT.PUT_LINE('�����ȣ' || v_no);
DBMS_OUTPUT.PUT_LINE('����̸�' || v_name);
DBMS_OUTPUT.PUT_LINE('�μ��̸�' || v_depname);

END;
/


--2 �����ȣ�� �Է��� ��� (ġȯ����) // ����̸�  �޿�  ����//�� ���   
--���� : �޿� *12 + (NVL(�޿�,0) *NVL(Ŀ�̼�,0)*12)


DECLARE
v_name employees.last_name%TYPE; --emp ���̺��� �����ð� 
v_sal employees.salary%TYPE;   --emp���̺��� �����ð� 
v_comm employees.COMMISSION_PCT%TYPE;  --emp ���̺��� �����ð� 
v_annual NUMBER;     --���� ���鰪 

BEGIN

SELECT last_name, salary, COMMISSION_PCT 
--SELECT last_name, salary, (salary *12 +(NVL(salary,0) * NVL(commission_pct ,0) *12))
INTO v_name, v_sal ,v_comm 
--INTO v_name, v_sal ,v_comm , v_annual
FROM employees
WHERE employee_id =&�����ȣ;

v_annual := v_sal *12 + (NVL(v_sal ,0) *NVL(v_comm,0)*12);


DBMS_OUTPUT.PUT_LINE('����̸�' || v_name);
DBMS_OUTPUT.PUT_LINE('�޿�' ||v_sal);
DBMS_OUTPUT.PUT_LINE('����' || v_annual);


END;
/


--�⺻ if�� 

BEGIN

    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('���������� ������� X');
      DBMS_OUTPUT.PUT_LINE('�ش����� ����X');
      ELSE 
       DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�');
    END IF;

END;
/


select *from employees where employee_id = 1000;




--IF ELSE �� 
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count   --DATA�����°�쿡�� üũ�� �ؾ��ϱ� ������  ���̺��� �˻������ �ƹ��͵� ������..  
    FROM employees
    WHERE manager_id = &eid;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ϲݻ��');  
    ELSE   --�������� ������ 
         DBMS_OUTPUT.PUT_LINE('�����Դϴ�'); 
   END IF;
END;
/


--IF ELSEF ELSE �� 

DECLARE
v_hdate NUMBER;
BEGIN
    SELECT TRUNC (MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id =&�����ȣ;
    
    IF v_hdate < 5 THEN    --�Ի����� 5��̸� 
     DBMS_OUTPUT.PUT_LINE('�Ի� 5�� �̸�');  
    ELSIF v_hdate < 10 THEN  --�Ի����� 5�� �̻�~ 10��̸�       ELSIF v_hdate <= 10 THEN �ٰ� �Ⱥٰ� ����. ���� �������� �ʵ���   
      DBMS_OUTPUT.PUT_LINE('�Ի� 10�� �̸�');  
    ELSIF v_hdate <15 THEN --�Ի����� 10�� �̻�~ 15��̸� 
     DBMS_OUTPUT.PUT_LINE('�Ի� 15�� �̸�');  
    ELSIF v_hdate <20 THEN --�Ի����� 15�� �̻�~ 20��̸� 
      DBMS_OUTPUT.PUT_LINE('�Ի� 20�� �̸�');  
    ELSE     
     DBMS_OUTPUT.PUT_LINE('�Ի� 20�� �̻��Դϴ� ');   --20���̻� ....
    END IF;
    --���� �ڹٲ�� �ȵ� 
END;
/



SELECT employee_id,
            TRUNC (MONTHS_BETWEEN(sysdate, hire_date)/12),
            TRUNC((sysdate-hire_date)/365)
FROM employees
ORDER BY 2 DESC;


--�����ȣ�Է� (ġȯ������ �Է�) D
--�Ի����� 2005�� ���� ���� �̸�  -- NEW EMPLOYEE
-- 2005�� �����̸� career employee

--1)��¥ �״�� �� 
DECLARE
v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT hire_date
    INTO v_hdate 
    FROM employees
    WHERE  employee_id=&�����ȣ;
    
    IF v_hdate >= TO_DATE('2005-01-01', 'YYYY-MM-dd') THEN   --hire_date��  ��¥�ϱ� 
    DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
    ELSE 
    DBMS_OUTPUT.PUT_LINE('career employee');
    END IF;
END;
/


--2) �⵵�� �� 

--SELECT TO_CHAR(hire_date,'yyyy')   --��¥�߿��� Ư���� ���� ���������Ϸ��� 
--FROM employees;

DECLARE
v_year CHAR(4char);
BEGIN
    SELECT TO_CHAR(hire_date,'yyyy')   --
    INTO v_year
    FROM employees
    WHERE employee_id =&�����ȣ;

IF v_year >= '2005' THEN
 DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
ELSE
  DBMS_OUTPUT.PUT_LINE('career employee');
END IF ;
END;
/



--������ 4�ڸ��� yy 
--���ڸ��� rr
--0-49   >> ��� ���ڸ��� 20~~
--50-99 >>19~~
--rr�� 00~49 ġ�� 1900~1949 / 50~99ġ�� 2050~2099
--�ֳĸ� ������ 2023�̶� 00~49���̶�



DECLARE
v_year CHAR(4char);
v_print VARCHAR2(1000) := 'career employee';  --�ʱⰪ���� �ָ�� 
BEGIN
    SELECT TO_CHAR(hire_date,'yyyy')   
    INTO v_year
    FROM employees
    WHERE employee_id =&�����ȣ;

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
 WHERE employee_id =&�����ȣ;

IF v_year >='05' THEN
 DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE');
ELSE
  DBMS_OUTPUT.PUT_LINE('career employee');
END IF ;

END;
/



--�����ȣ�� �Է�( ġȯ����) �ϸ�       ����̸�, �޿�, �λ�� �޿��� ��� 
--����ڰ� 20�� �Է��ϸ� �ȿ��� ��ȯ�Ҽ��ְԲ� 

DECLARE
v_name VARCHAR2(1000);
v_salary employees.salary%TYPE;
v_new employees.salary%TYPE := 0;

BEGIN
SELECT last_name , salary 
INTO v_name, v_salary
FROM employees
WHERE employee_id = &�����ȣ;

IF v_salary <= 5000 then
v_new := v_salary + (v_salary*0.2);
ELSIF  v_salary <= 10000 then
v_new := v_salary + (v_salary*0.15);
ELSIF  v_salary <= 15000 then
v_new := v_salary + (v_salary*0.1);
ELSE 
v_new := v_salary;

END IF;

DBMS_OUTPUT.PUT_LINE('�̸�:' || v_name);
DBMS_OUTPUT.PUT_LINE('����޿�' ||v_salary);
DBMS_OUTPUT.PUT_LINE('�λ�ȱ޿�' || v_new);


END;
/




--����


DECLARE
v_name VARCHAR2(1000);
v_salary employees.salary%TYPE;
v_new employees.salary%TYPE := 0;  --�ʱⰪ�� 

BEGIN
SELECT last_name , salary 
INTO v_name, v_salary
FROM employees
WHERE employee_id = &�����ȣ;

IF v_salary <= 5000 then
 v_new :=20;
ELSIF  v_salary <= 10000 then
  v_new :=15;
ELSIF  v_salary <= 15000 then
 v_new :=10;

END IF;

DBMS_OUTPUT.PUT_LINE('�̸�:' || v_name);
DBMS_OUTPUT.PUT_LINE('����޿�' || v_salary);
DBMS_OUTPUT.PUT_LINE('�λ�ȱ޿�' || v_salary * (1+v_new/100)); 
END;
/



---�ݺ��� 
--�⺻ Ư���� ���Ǿ���  // ���ѷ��� 
--for �ݺ�Ƚ������
--while ���Ǹ����ϸ� ���



--���ѷ��� ���� ���� 
DECLARE

BEGIN
    LOOP    
    DBMS_OUTPUT.PUT_LINE('==');   --buffer overflow, limit of 1000000 bytes  ���ѷ���.. 
    
    END LOOP;
END;
/



---1���� 10���� ���ϱ�.. �⺻������ �̿��ؼ�.. 
DECLARE
v_num NUMBER(2,0) :=1;
v_sum NUMBER(2,0) :=0;   ---���� ��� 

BEGIN
    LOOP    
  -- v_num := v_num +1;  --�����־ �Ǵµ� �׷� �ؿ� >9���ؾ���.. 
     v_sum := v_sum + v_num;  --sum�� ���� 
    v_num := v_num +1;  --num�� 1�� ����  i ++ �� ����..
    EXIT WHEN v_num > 10 ;   --EXIT�� ���� Ư���� ���Ǿ��� �ٷ� ��   v_num�� 11�̵Ǵ¼��� �׸� 
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/


---while  1-10 ���� ���ϱ� 
DECLARE
v_num NUMBER(2,0) :=1;
v_sum NUMBER(2,0) :=0;   ---���� ��� 

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
v_sum NUMBER(2,0) :=0;  --������ ���� ���� �� 
--v_n NUMBER(2,0) :=99;

BEGIN 
FOR num IN REVERSE 1..10 LOOP    --n �ӽú����� �켱������ �� ����.   , DECLARE �� �ӽú����� �̸� ����X  = num�� ���� ������ ���� �� ..  REVERSE >>�������� ����ϰ�ʹٸ� >> �⺻ �������� ���� 
--DBMS_OUTPUT.PUT_LINE(v_n);        --lower upper ������ ������ ����.. 
v_sum := v_sum + num;
END LOOP;
--DBMS_OUTPUT.PUT_LINE(v_n);  -->>99�� ��� 
DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/



--�����
--1) FOR �̿� 
DECLARE
    v_star VARCHAR2(100) :='';

BEGIN 
     FOR num IN 1..5 LOOP      -- num������ �ϵ� ���������δ� ��� X  num�� readonly�� �� ���� �Ұ� 
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);  -->>99�� ��� 
    END LOOP;
END;
/


--2) �⺻���� �̿� 
DECLARE
    v_cnt NUMBER(1,0) :=1;
    v_star VARCHAR2(100) :='';
    --v_star VARCHAR2(6 char) : = '';
BEGIN 
    LOOP 
    v_cnt := v_cnt+1;
    v_star := v_star || '*';

    EXIT WHEN v_cnt >6;

    DBMS_OUTPUT.PUT_LINE(v_star);  --���� ��ġ 

    END LOOP;
END;
/


--2) �⺻���� �����ڵ�
DECLARE
    v_cnt NUMBER(1,0) :=1;
    v_star VARCHAR2(6 char) := '';
BEGIN 
    LOOP 
    v_star := v_star || '*';
     DBMS_OUTPUT.PUT_LINE(v_star);  --���� ��ġ 

    v_cnt := v_cnt+1;
    EXIT WHEN v_cnt >5;
  
    END LOOP;
END;
/




--3) while �̿� 

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



--3) while �����ڵ� 

DECLARE
--length�����ϱ� cnt ���ص���   
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


--���߷�����  for����� 

BEGIN
    FOR line IN 1..5 LOOP   --line�� ���� 
        FOR star IN 1..line LOOP  --1��° ���̸� �� 1��    1~ line (=1) 
            DBMS_OUTPUT.PUT('*');
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('');  --�ٹٲٱ� 
    END LOOP;     
END;
/


--���߷����� 


DECLARE
    v_star NUMBER(1,0) :=1;
    v_line NUMBER(1,0) :=1;

BEGIN
    LOOP 
        v_star := 1;  --�ݵ�� �ʱ�ȭ�� �Ǿ����   for�� �ڵ� ����  
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



