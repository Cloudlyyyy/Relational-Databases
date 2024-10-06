-- [Problem 1]
-- make min/max queries fast using specific branch name 
CREATE INDEX index ON account (branch_name, balance);

-- [Problem 2]
-- create table for mv_branch_account_stats
CREATE TABLE mv_branch_account_stats (
    branch_name           VARCHAR(15) PRIMARY KEY,
    num_accounts          INT NOT NULL; 
    total_deposits        DECIMAL(12,2) NOT NULL,
    avg_balance           DECIMAL(12,2) NOT NULL, 
    min_balance           DECIMAL(12,2) NOT NULL, 
    max_balance           DECIMAL(12,2) NOT NULL
);

-- [Problem 3]
-- write inital SQL DML statement to populate the materialized view table
INSERT INTO mv_branch_account_stats
SELECT branch_name, COUNT(*), SUM(balance), AVG(balance), MIN(balance), 
        MAX(balance)
FROM account
GROUP BY branch_name;

-- [Problem 4]
-- write view definition for branch_account_stats
CREATE VIEW branch_account_stats AS 
    SELECT branch, num_accounts, total_deposits, avg_balance, min_balance,
            max_balance
    FROM account
    GROUP BY branch_name;

-- [Problem 5]
-- Provided solution for Problem 5
DELIMITER !

-- Write the trigger (and related procedures) to handle inserts.

-- A procedure to execute when inserting a new branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated
-- to account for total deposits and adjusted min/max balances.
CREATE PROCEDURE sp_branchstat_newacct(
    new_branch_name VARCHAR(15),
    new_balance NUMERIC(12, 2)
)
BEGIN 
    INSERT INTO mv_branch_account_stats 
        -- branch not already in view; add row
        VALUES (new_branch_name, 1, new_balance, new_balance, new_balance)
    ON DUPLICATE KEY UPDATE 
        -- branch already in view; update existing row
        num_accounts = num_accounts + 1,
        total_deposits = total_deposits + new_balance,
        min_balance = LEAST(min_balance, new_balance),
        max_balance = GREATEST(max_balance, new_balance);
END !

-- Handles new rows added to account table, updates stats accordingly
CREATE TRIGGER trg_account_insert AFTER INSERT
       ON account FOR EACH ROW
BEGIN
      -- Example of calling our helper procedure, passing in the new row's information
    CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
END !
DELIMITER ;


-- [Problem 6]

DELIMITER ! 

-- Write the trigger (and related procedures) to handle deletes 
-- used problem 5 as a guideline

-- A procedure to execute when deleting a branch name and balance
-- to the bank account stats materialized view (mv_branch_account_stats).
-- If a branch is already in view, its current balance is updated 
-- to account for total deposits and adjusted min/max balances. 
CREATE PROCEDURE sp_branchstat_delacct(
    old_branch_name VARCHAR(15),
    old_balance NUMERIC(12,2)
)
BEGIN  
    DELETE FROM mv_branch_account_stats 
        WHERE branch_name = old_branch_name;
    ON DUPLICATE KEY UPDATE
        num_accounts = num_account - 1, 
        total_deposits = total_deposits - old_balance, 
        min_balance = LEAST(min_balance, old_balance),
        max_balance = GREATEST(max_balance, old_balance);
END !
    
CREATE TRIGGER trg_account_delete AFTER DELETE 
    ON account for EACH ROW
BEGIN 
    CALL sp_branchstat_delacct(OLD.branch_name, OLD.balance);
END!
DELIMITER ;

-- [Problem 7]

DELIMITER !

CREATE TRIGGER trg_account_update AFTER UPDATE
        ON account FOR EACH ROW
BEGIN
    IF OLD.branch_name != NEW.branch_name THEN
        CALL sp_branchstat_newacct(NEW.branch_name, NEW.balance);
        CALL sp_branchstat_deleteacct(OLD.branch_name, OLD.balance);
    ELSE IF OLD.balance != NEW.balance THEN
        UPDATE mv_branch_account_stats
            SET total_deposits = total_deposits + NEW.balance - OLD.balance,
            min_balance = LEAST(min_balance, NEW.balance),
            max_balance = GREATEST(max_balance, NEW.balance)
            WHERE branch_name = NEW.branch_name;
    END IF;

    IF OLD.balance = (SELECT min_balance FROM mv_branch_account_stats 
                      WHERE branch_name = OLD.branch)
    THEN UPDATE mv_branch_account_stats SET min_balance =
        (SELECT MIN(balance) FROM account WHERE branch_name = OLD.branch)
        WHERE branch_name = OLD.branch;
    ELSE IF OLD.balance = (SELECT max_balance FROM mv_branch_account_stats 
            WHERE branch_name = OLD.branch)
    THEN UPDATE mv_branch_account_stats SET OLD.balance =
        (SELECT MAX(balance) FROM account WHERE branch_name = OLD.branch)
        WHERE branch_name = OLD.branch;
    END IF;

END !
DELIMITER ;






