SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE AccountOperations AS

    PROCEDURE OpenAccount(
        p_accountid NUMBER,
        p_customerid NUMBER,
        p_type VARCHAR2,
        p_balance NUMBER
    );

    PROCEDURE CloseAccount(
        p_accountid NUMBER
    );

    FUNCTION GetTotalBalance(
        p_customerid NUMBER
    ) RETURN NUMBER;

END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS

    PROCEDURE OpenAccount(
        p_accountid NUMBER,
        p_customerid NUMBER,
        p_type VARCHAR2,
        p_balance NUMBER
    )
    AS
    BEGIN
        INSERT INTO Accounts
        (
            AccountID,
            CustomerID,
            AccountType,
            Balance,
            LastModified
        )
        VALUES
        (
            p_accountid,
            p_customerid,
            p_type,
            p_balance,
            SYSDATE
        );

        COMMIT;
    END OpenAccount;

    PROCEDURE CloseAccount(
        p_accountid NUMBER
    )
    AS
    BEGIN
        DELETE FROM Accounts
        WHERE AccountID = p_accountid;

        COMMIT;
    END CloseAccount;

    FUNCTION GetTotalBalance(
        p_customerid NUMBER
    ) RETURN NUMBER
    AS
        v_total NUMBER;
    BEGIN
        SELECT SUM(Balance)
        INTO v_total
        FROM Accounts
        WHERE CustomerID = p_customerid;

        RETURN NVL(v_total,0);
    END GetTotalBalance;

END AccountOperations;
/

BEGIN
    AccountOperations.OpenAccount(
        200,
        1,
        'Savings',
        5000
    );
END;
/

DECLARE
    v_total NUMBER;
BEGIN
    v_total := AccountOperations.GetTotalBalance(1);
    DBMS_OUTPUT.PUT_LINE('Total Balance = ' || v_total);
END;
/

BEGIN
    AccountOperations.CloseAccount(200);
END;
/