SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE CustomerManagement AS

    PROCEDURE AddCustomer(
        p_customerid NUMBER,
        p_name VARCHAR2,
        p_dob DATE,
        p_balance NUMBER
    );

    PROCEDURE UpdateCustomer(
        p_customerid NUMBER,
        p_balance NUMBER
    );

    FUNCTION GetCustomerBalance(
        p_customerid NUMBER
    ) RETURN NUMBER;

END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS

    PROCEDURE AddCustomer(
        p_customerid NUMBER,
        p_name VARCHAR2,
        p_dob DATE,
        p_balance NUMBER
    )
    AS
    BEGIN
        INSERT INTO Customers
        (
            CustomerID,
            Name,
            DOB,
            Balance,
            LastModified
        )
        VALUES
        (
            p_customerid,
            p_name,
            p_dob,
            p_balance,
            SYSDATE
        );

        COMMIT;
    END AddCustomer;

    PROCEDURE UpdateCustomer(
        p_customerid NUMBER,
        p_balance NUMBER
    )
    AS
    BEGIN
        UPDATE Customers
        SET Balance = p_balance
        WHERE CustomerID = p_customerid;

        COMMIT;
    END UpdateCustomer;

    FUNCTION GetCustomerBalance(
        p_customerid NUMBER
    ) RETURN NUMBER
    AS
        v_balance NUMBER;
    BEGIN
        SELECT Balance
        INTO v_balance
        FROM Customers
        WHERE CustomerID = p_customerid;

        RETURN v_balance;
    END GetCustomerBalance;

END CustomerManagement;
/

BEGIN
    CustomerManagement.AddCustomer(
        10,
        'Monii',
        TO_DATE('2003-08-15','YYYY-MM-DD'),
        25000
    );
END;
/

BEGIN
    CustomerManagement.UpdateCustomer(10,30000);
END;
/

DECLARE
    v_balance NUMBER;
BEGIN
    v_balance := CustomerManagement.GetCustomerBalance(10);
    DBMS_OUTPUT.PUT_LINE('Balance = ' || v_balance);
END;
/