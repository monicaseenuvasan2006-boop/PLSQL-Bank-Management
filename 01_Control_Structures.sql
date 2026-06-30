SET SERVEROUTPUT ON;

DECLARE
    v_age NUMBER;
BEGIN
    FOR c IN (SELECT CustomerID, Name, DOB FROM Customers)
    LOOP
        v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, c.DOB)/12);

        IF v_age > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE CustomerID = c.CustomerID;

            DBMS_OUTPUT.PUT_LINE(c.Name || ' - Interest Updated');
        END IF;
    END LOOP;

    COMMIT;
END;
/

ALTER TABLE Customers
ADD IsVIP VARCHAR2(5);


BEGIN
    FOR c IN (SELECT CustomerID, Name, Balance FROM Customers)
    LOOP

        IF c.Balance > 10000 THEN

            UPDATE Customers
            SET IsVIP = 'TRUE'
            WHERE CustomerID = c.CustomerID;

            DBMS_OUTPUT.PUT_LINE(c.Name || ' promoted to VIP');

        END IF;

    END LOOP;

    COMMIT;

END;
/


BEGIN
    FOR rec IN (
        SELECT c.Name,
               l.EndDate
        FROM Customers c
        JOIN Loans l
        ON c.CustomerID = l.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Reminder: Loan of '
            || rec.Name
            || ' is due on '
            || TO_CHAR(rec.EndDate,'DD-MON-YYYY')
        );
    END LOOP;
END;
/