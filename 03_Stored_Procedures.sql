-- ==========================================================
-- Exercise 3 : Stored Procedures
-- ==========================================================

SET SERVEROUTPUT ON;

-- ==========================================================
-- Scenario 1
-- ProcessMonthlyInterest
-- ==========================================================

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
AS
BEGIN

    FOR acc IN (
        SELECT AccountID, AccountType, Balance
        FROM Accounts
    )
    LOOP

        IF acc.AccountType = 'Savings' THEN

            UPDATE Accounts
            SET Balance = Balance + (Balance * 1 / 100)
            WHERE AccountID = acc.AccountID;

            DBMS_OUTPUT.PUT_LINE('Interest Updated for Account ID : '
                                 || acc.AccountID);

        END IF;

    END LOOP;

    COMMIT;

END;
/

-- Execute

BEGIN
    ProcessMonthlyInterest;
END;
/

-- ==========================================================
-- Scenario 2
-- UpdateEmployeeBonus
-- ==========================================================

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
    p_department IN VARCHAR2,
    p_bonus IN NUMBER
)
AS
BEGIN

    UPDATE Employees
    SET Salary = Salary + (Salary * p_bonus / 100)
    WHERE Department = p_department;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Bonus Updated Successfully');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error : ' || SQLERRM);
        ROLLBACK;

END;
/

-- Execute

BEGIN
    UpdateEmployeeBonus('IT',10);
END;
/

-- ==========================================================
-- Scenario 3
-- TransferFunds
-- ==========================================================

CREATE OR REPLACE PROCEDURE TransferFunds(
    p_fromAccount IN NUMBER,
    p_toAccount IN NUMBER,
    p_amount IN NUMBER
)
AS
    v_balance NUMBER;
BEGIN

    -- Get source account balance
    SELECT Balance
    INTO v_balance
    FROM Accounts
    WHERE AccountID = p_fromAccount;

    -- Check sufficient balance
    IF v_balance >= p_amount THEN

        -- Deduct amount from source account
        UPDATE Accounts
        SET Balance = Balance - p_amount
        WHERE AccountID = p_fromAccount;

        -- Add amount to destination account
        UPDATE Accounts
        SET Balance = Balance + p_amount
        WHERE AccountID = p_toAccount;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Fund Transfer Successful');

    ELSE

        DBMS_OUTPUT.PUT_LINE('Insufficient Balance');
        ROLLBACK;

    END IF;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Account Not Found');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error : ' || SQLERRM);
        ROLLBACK;

END;
/

-- Execute

BEGIN
    TransferFunds(101,102,5000);
END;
/