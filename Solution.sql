/*
    @author kenneth.cruz@unah.hn
    @version 0.1.0
    @date 15/10/2021
*/


/*
    Anotaciones 
    TG_insertaDepto_2011000111
    SQ_tblDepto_2011000111
    TBL_Depto_2011000111

*/


-- Creación de Usuario para la base de datos 
CREATE USER BD_EXAMEN_I IDENTIFIED BY 123
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;


-- Cración de Rol 
GRANT 
    CREATE SESSION, 
    CREATE ANY TABLE,
    CREATE ANY PROCEDURE,
    CREATE ANY TRIGGER, 
    ALTER ANY TABLE, 
    ALTER ANY PROCEDURE,
    ALTER ANY TRIGGER,  
    DROP ANY TABLE, 
    DROP ANY PROCEDURE, 
    DROP ANY TRIGGER
TO ADMINISTRADORES
    ;


-- Asignar Rol a usuario
GRANT ADMINISTRADORES TO BD_EXAMEN_I;


/*
    EJERCICIO 1
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE

    TYPE FILA IS RECORD(
       ID DEPARTMENTS.DEPARTMENT_ID%TYPE,
       NOMBRE DEPARTMENTS.DEPARTMENT_NAME%TYPE,
       CALLE LOCATIONS.STREET_ADDRESS%TYPE,
       POSTAL LOCATIONS.POSTAL_CODE%TYPE
    );

    TYPE TABLA_CATEGORIAS IS TABLE OF FILA INDEX BY PLS_INTEGER;
    DATOS_UBICACION_DEPARTAMENTO TABLA_CATEGORIAS;
    ITERACION NUMBER(10):=0;
    

BEGIN
    SELECT 
        DEPARTMENTS.DEPARTMENT_ID,
        DEPARTMENTS.DEPARTMENT_NAME,
        LOCATIONS.STREET_ADDRESS,
        LOCATIONS.POSTAL_CODE
    BULK COLLECT 
    INTO 
        DATOS_UBICACION_DEPARTAMENTO
    FROM 
        DEPARTMENTS
    INNER JOIN 
        LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID
    WHERE 
        DEPARTMENTS.MANAGER_ID IS NOT NULL
    ;

    DBMS_OUTPUT.PUT_LINE('La cantidad de registros es: ' || SQL%ROWCOUNT);

     WHILE (ITERACION < SQL%ROWCOUNT) LOOP
        
        DBMS_OUTPUT.PUT_LINE('El código es: ' || DATOS_UBICACION_DEPARTAMENTO(ITERACION + 1).ID);
        DBMS_OUTPUT.PUT_LINE('El nombre del departamento es: ' || DATOS_UBICACION_DEPARTAMENTO(ITERACION + 1).NOMBRE);
        DBMS_OUTPUT.PUT_LINE('La dirección de la calle del departamento es: ' || DATOS_UBICACION_DEPARTAMENTO(ITERACION + 1).CALLE);
        DBMS_OUTPUT.PUT_LINE('La postal deL departamento es: ' || DATOS_UBICACION_DEPARTAMENTO(ITERACION + 1).POSTAL);

        ITERACION := ITERACION + 1;
    END LOOP;

END; 


/*
    EJERCICIO 2
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE SEQUENCE SQ_COUNTRIES_20141010391
START WITH 20
INCREMENT BY 2;

CREATE SEQUENCE SQ_DEPARTMENTS_20141010391
START WITH 20
INCREMENT BY 2;

CREATE SEQUENCE SQ_EMPLOYEES_20141010391
START WITH 20
INCREMENT BY 2;

CREATE SEQUENCE SQ_JOBS_20141010391
START WITH 20
INCREMENT BY 2;

CREATE SEQUENCE SQ_LOCATIONS_20141010391
START WITH 20
INCREMENT BY 2;

CREATE SEQUENCE SQ_REGIONS_20141010391
START WITH 20
INCREMENT BY 2;


-- Datos a insertar
INSERT INTO REGIONS VALUES (SQ_REGIONS_20141010391.NEXTVAL, 'Middle East.');
INSERT INTO REGIONS VALUES (SQ_REGIONS_20141010391.NEXTVAL, 'Eastern Europe.');

INSERT INTO COUNTRIES VALUES (SQ_COUNTRIES_20141010391.NEXTVAL, 'Israel', 22);
INSERT INTO COUNTRIES VALUES (SQ_COUNTRIES_20141010391.NEXTVAL, 'Palestine', 22);

INSERT INTO DEPARTMENTS VALUES (SQ_DEPARTMENTS_20141010391.NEXTVAL, 'RRHH', 124, 1500);
INSERT INTO DEPARTMENTS VALUES (SQ_DEPARTMENTS_20141010391.NEXTVAL, 'Logística y operaciones', 124, 1500);

INSERT INTO EMPLOYEES VALUES (SQ_EMPLOYEES_20141010391.NEXTVAL,'Garwood', 'Greger', 'ggreger0@multiply.com', '409-694-0127' , SYSDATE, 'SA_REP', 25000, 0.1, 100, 60);
INSERT INTO EMPLOYEES VALUES (SQ_EMPLOYEES_20141010391.NEXTVAL,'Beverley', 'Furzey', 'bfurzey1@cloudflare.com', '203-256-5513' , SYSDATE, 'ST_CLERK', 5500, 0.2, 101, 80);

INSERT INTO JOBS VALUES (SQ_JOBS_20141010391.NEXTVAL, 'operativos y de apoyo', 10000, 25000);
INSERT INTO JOBS VALUES (SQ_JOBS_20141010391.NEXTVAL, 'mando medio', 5500, 19000);

INSERT INTO LOCATIONS VALUES (SQ_LOCATIONS_20141010391.NEXTVAL, 'High Crossing', '4775-446', 'Nine', 'Braga', 'US');
INSERT INTO LOCATIONS VALUES (SQ_LOCATIONS_20141010391.NEXTVAL, 'Nancy', '4045', 'Debrecen', 'Hajdú-Bihar', 'US');


SELECT * FROM REGIONS;
SELECT * FROM COUNTRIES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEES;
SELECT * FROM JOBS;
SELECT * FROM LOCATIONS;


/*
desc COUNTRIES;
desc DEPARTMENTS;
desc EMPLOYEES;
desc JOBS;
desc LOCATIONS;
desc REGIONS;
*/


/*
    EJERCICIO 3
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DECLARE

    TYPE FILA IS RECORD(
       
       JOB_ID JOBS.JOB_ID%TYPE,
       JOB_TITLE JOBS.JOB_TITLE%TYPE, 
       MIN_SALARY JOBS.MIN_SALARY%TYPE, 
       MAX_SALARY JOBS.MAX_SALARY%TYPE, 
       DEPARTMENT_ID DEPARTMENTS.DEPARTMENT_ID%TYPE, 
       DEPARTMENT_NAME DEPARTMENTS.DEPARTMENT_NAME%TYPE,
       FULL_NAME_EMPLOYEE VARCHAR2(60)
    );

    TYPE TABLA_INFORMACION_EMPLEADO IS TABLE OF FILA INDEX BY PLS_INTEGER;
    DATOS_INFORMACION_EMPLEADO TABLA_INFORMACION_EMPLEADO;
    ITERACION NUMBER(10):=0;
    

BEGIN
    SELECT 
        JOBS.JOB_ID,
        JOBS.JOB_TITLE, 
        JOBS.MIN_SALARY, 
        JOBS.MAX_SALARY, 
        DEPARTMENTS.DEPARTMENT_ID, 
        DEPARTMENTS.DEPARTMENT_NAME,
        EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME AS NAME
        
    BULK COLLECT 
    INTO 
        DATOS_INFORMACION_EMPLEADO
    FROM 
        EMPLOYEES
    INNER JOIN 
        DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
    INNER JOIN 
        JOBS ON EMPLOYEES.JOB_ID = JOBS.JOB_ID
    ;

    DBMS_OUTPUT.PUT_LINE('La cantidad de registros es: ' || SQL%ROWCOUNT);

     WHILE (ITERACION < SQL%ROWCOUNT) LOOP
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('ID del trabajo: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).JOB_ID);
        DBMS_OUTPUT.PUT_LINE('Nombre del trabajo: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).JOB_TITLE);
        DBMS_OUTPUT.PUT_LINE('Límite inferior(minímo) del salario: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).MIN_SALARY);
        DBMS_OUTPUT.PUT_LINE('Límite superior(máximo) del salario: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).MAX_SALARY);
        DBMS_OUTPUT.PUT_LINE('ID del departamento del trabajo: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).DEPARTMENT_ID);
        DBMS_OUTPUT.PUT_LINE('Nombre del departamento: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).DEPARTMENT_NAME);
        DBMS_OUTPUT.PUT_LINE('Nombre completo: ' || DATOS_INFORMACION_EMPLEADO(ITERACION + 1).FULL_NAME_EMPLOYEE);
        DBMS_OUTPUT.PUT_LINE('');

        ITERACION := ITERACION + 1;
    END LOOP;

END; 



/*
    EJERCICIO 4
*/

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Creación de la tabla
CREATE TABLE TBL_REGISTRO_LOGS_20141010391(
    ID_LOG NUMBER PRIMARY KEY, 
    FECHA_LOG TIMESTAMP, 
    DESCRIPCION_LOG VARCHAR(500), 
    USUARIO VARCHAR2(50), 
    TIPO_OPERACION VARCHAR2(20), 
    TABLA_AFECTADA VARCHAR2(30)
);

-- Secuencia
CREATE SEQUENCE SQ_LOGS_20141010391
START WITH 5
INCREMENT BY 5;


-- Trigger que maneja la secuencia de los campos ID de la tabla TBL_REGISTRO_LOGS_20141010391
CREATE OR REPLACE TRIGGER TG_AUTOINCREMENTAL_20141010391
    BEFORE INSERT ON TBL_REGISTRO_LOGS_20141010391
    FOR EACH ROW 

    BEGIN
        -- Secuencia
        :NEW.ID_LOG := SQ_LOGS_20141010391.NEXTVAL;
    END;


-- uno en la tabla EMPLOYEES que se ejecute después de realizar un INSERT
CREATE OR REPLACE TRIGGER TG_INSERTAR_LOGS_20141010391
    AFTER INSERT ON EMPLOYEES
    FOR EACH ROW 

    BEGIN

        INSERT INTO TBL_REGISTRO_LOGS_20141010391(FECHA_LOG, DESCRIPCION_LOG, USUARIO, TIPO_OPERACION, TABLA_AFECTADA) VALUES
        ( 
            SYSTIMESTAMP, 
            'Se realizó un INSERT en la tabla EMPLOYEES, el ID es: ' 
            || :NEW.EMPLOYEE_ID
            || ' Los datos del empleado son:  ' 
            || 'Nombre completo: '
            || :NEW.FIRST_NAME || ' ' || :NEW.LAST_NAME 
            || ' Correo: ' 
            || :NEW.EMAIL, 
            USER, 
            'INSERT', 
            'EMPLOYEES'              
        );

    END; 


-- otro en la tabla DEPARTMENTS que se ejecute antes de realizar un UPDATE
CREATE OR REPLACE TRIGGER TG_ACTUALIZAR_LOGS_20141010391
    BEFORE UPDATE ON DEPARTMENTS
    FOR EACH ROW 

    BEGIN

        INSERT INTO TBL_REGISTRO_LOGS_20141010391(FECHA_LOG, DESCRIPCION_LOG, USUARIO, TIPO_OPERACION, TABLA_AFECTADA) VALUES
        ( 
            SYSTIMESTAMP, 
            'Se realizó un UPDATE en la tabla DEPARTMENTS ' 
            || 'y el nombre anterior del departamento es: '  
            || :OLD.DEPARTMENT_NAME
            || ' el valor nuevo de la categoría es: '
            || :NEW.DEPARTMENT_NAME, 
            USER, 
            'UPDATE', 
            'DEPARTMENTS'              
        );

    END; 


-- el último trigger en la tabla JOB_HISTORY que se ejecute después de realizar un DELETE.
CREATE OR REPLACE TRIGGER TG_ELIMINAR_LOGS_20141010391
    AFTER DELETE ON JOB_HISTORY
    FOR EACH ROW 

    BEGIN

        INSERT INTO TBL_REGISTRO_LOGS_20141010391(FECHA_LOG, DESCRIPCION_LOG, USUARIO, TIPO_OPERACION, TABLA_AFECTADA) VALUES
        ( 
            SYSTIMESTAMP, 
            'Se realizó un DELETE en la tabla JOB_HISTORY ' 
            || 'y el dato eliminado con ID es: '  
            || :OLD.EMPLOYEE_ID
            || ' El empleado inició a laborar en:  '
            || :OLD.START_DATE 
            || ' Fue despedido en: ' 
            || :OLD.END_DATE,
            USER, 
            'DELETE', 
            'JOB_HISTORY'              
        );

    END; 

-- Datos de prueba

SELECT * FROM EMPLOYEES;  -- INSERT
SELECT * FROM DEPARTMENTS; -- UPDATE
SELECT * FROM JOB_HISTORY;  -- DELETE

SELECT * FROM TBL_REGISTRO_LOGS_20141010391; 


INSERT INTO EMPLOYEES VALUES (SQ_EMPLOYEES_20141010391.NEXTVAL,'Garwood', 'Greger', 'garwood@good.com', '409-694-0127' , SYSDATE, 'SA_REP', 25000, 0.1, 100, 60);


UPDATE DEPARTMENTS
SET 
    DEPARTMENT_NAME = 'Logistic Operation Management'
    
WHERE 
    DEPARTMENT_ID = 22
;


DELETE FROM 
    JOB_HISTORY
WHERE 
    EMPLOYEE_ID = 200
;

SELECT * FROM TBL_REGISTRO_LOGS_20141010391; 