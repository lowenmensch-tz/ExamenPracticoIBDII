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




/*
    EJERCICIO 3
*/


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




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
            || :NEW.ID_LOG
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
            || :OLD.START_DATE, 
            || ' Fue despedido en: ' 
            || :OLD.END_DATE
            USER, 
            'DELETE', 
            'JOB_HISTORY'              
        );

    END; 