
-- Scenario 1
-- CalculateAge

CREATE OR REPLACE FUNCTION CalculateAge(
    p_dob IN DATE
)
RETURN NUMBER
AS
    v_age NUMBER;
BEGIN

    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);

    RETURN v_age;

END;
/


DECLARE
    v_age NUMBER;
BEGIN
    v_age := CalculateAge(TO_DATE('1995-05-15','YYYY-MM-DD'));

    DBMS_OUTPUT.PUT_LINE('Age = ' || v_age);
END;
/

-- Scenario 2
-- CalculateMonthlyInstallment

CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment(
    p_loanAmount IN NUMBER,
    p_interestRate IN NUMBER,
    p_years IN NUMBER
)
RETURN NUMBER
AS
    v_monthlyInstallment NUMBER;
BEGIN

    v_monthlyInstallment :=
        (p_loanAmount +
        (p_loanAmount * p_interestRate * p_years /100))
        /(p_years * 12);

    RETURN v_monthlyInstallment;

END;
/


DECLARE
    v_installment NUMBER;
BEGIN

    v_installment :=
        CalculateMonthlyInstallment(500000,8,5);

    DBMS_OUTPUT.PUT_LINE(
        'Monthly Installment = '
        || ROUND(v_installment,2));

END;
/

-- Scenario 3
-- HasSufficientBalance

CREATE OR REPLACE FUNCTION HasSufficientBalance(
    p_accountid IN NUMBER,
    p_amount IN NUMBER
)
RETURN BOOLEAN
AS
    v_balance NUMBER;
BEGIN

    SELECT Balance
    INTO v_balance
    FROM Accounts
    WHERE AccountID = p_accountid;

    IF v_balance >= p_amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;

END;
/


DECLARE
    v_result BOOLEAN;
BEGIN

    v_result := HasSufficientBalance(101,5000);

    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('Sufficient Balance');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Insufficient Balance');
    END IF;

END;
/