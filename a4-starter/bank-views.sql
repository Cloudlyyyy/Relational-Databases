-- [Problem 1a]
CREATE VIEW stonewell_customers AS
    SELECT account_number, customer_name
    FROM depositor NATURAL JOIN account
    WHERE branch_name = 'Stonewell';

SELECT * FROM stonewell_customers;

-- [Problem 1b]
CREATE VIEW onlyacct_customers AS 
    SELECT DISTINCT customer_name, customer_street, customer_city 
    FROM customer 
    WHERE customer_name IN (SELECT customer_name 
                            FROM depositor
                            WHERE customer_name NOT IN (SELECT customer_name
                                                        FROM borrower));

SELECT * FROM onlyacct_customers;

-- [Problem 1c]
CREATE VIEW branch_deposits AS 
    SELECT branch_name, IFNULL(SUM(balance), 0) AS total_balance, 
        IFNULL(AVG(balance), NULL) AS avg_balance 
    FROM branch NATURAL LEFT JOIN account
    GROUP BY branch_name;

SELECT * FROM branch_deposits;