SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE EmployeeManagement AS

    PROCEDURE HireEmployee(
        p_empid NUMBER,
        p_name VARCHAR2,
        p_position VARCHAR2,
        p_salary NUMBER,
        p_department VARCHAR2,
        p_hiredate DATE
    );

    PROCEDURE UpdateEmployee(
        p_empid NUMBER,
        p_salary NUMBER
    );

    FUNCTION CalculateAnnualSalary(
        p_empid NUMBER
    ) RETURN NUMBER;

END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS

    PROCEDURE HireEmployee(
        p_empid NUMBER,
        p_name VARCHAR2,
        p_position VARCHAR2,
        p_salary NUMBER,
        p_department VARCHAR2,
        p_hiredate DATE
    )
    AS
    BEGIN
        INSERT INTO Employees
        VALUES
        (
            p_empid,
            p_name,
            p_position,
            p_salary,
            p_department,
            p_hiredate
        );

        COMMIT;
    END HireEmployee;

    PROCEDURE UpdateEmployee(
        p_empid NUMBER,
        p_salary NUMBER
    )
    AS
    BEGIN
        UPDATE Employees
        SET Salary = p_salary
        WHERE EmployeeID = p_empid;

        COMMIT;
    END UpdateEmployee;

    FUNCTION CalculateAnnualSalary(
        p_empid NUMBER
    ) RETURN NUMBER
    AS
        v_salary NUMBER;
    BEGIN
        SELECT Salary
        INTO v_salary
        FROM Employees
        WHERE EmployeeID = p_empid;

        RETURN v_salary * 12;
    END CalculateAnnualSalary;

END EmployeeManagement;
/

BEGIN
    EmployeeManagement.HireEmployee(
        5,
        'David',
        'Tester',
        45000,
        'QA',
        SYSDATE
    );
END;
/

BEGIN
    EmployeeManagement.UpdateEmployee(5,50000);
END;
/

DECLARE
    v_salary NUMBER;
BEGIN
    v_salary := EmployeeManagement.CalculateAnnualSalary(5);
    DBMS_OUTPUT.PUT_LINE('Annual Salary = ' || v_salary);
END;
/