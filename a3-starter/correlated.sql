-- [Problem 1a]
/* This query is computing the customer_name and the loan_count by comparing
   the customer name to the borrower name and counts how many times there's a 
   match in descending order
*/ 
SELECT customer_name, COUNT(borrower.customer_name) AS loan_count
FROM borrower NATURAL RIGHT JOIN customer
GROUP by customer.customer_name
ORDER BY loan_count DESC;

-- [Problem 1b]
/* This query computes the branch name where the assets are less the loan
   amount 
*/
SELECT branch_name
FROM branch NATURAL JOIN
    (SELECT branch_name, SUM(amount) AS loan_amount
     FROM loan GROUP BY branch_name) AS loan_branch
WHERE branch.assets < loan_branch.loan_amount;

-- [Problem 1c]
-- This query computes the loan count and number of accounts for each branch
SELECT branch_name, 
    (SELECT COUNT(*) FROM loan l 
     WHERE l.branch_name = b.branch_name) AS loan_count,
    (SELECT COUNT(*) FROM account a
     WHERE a.branch_name = b.branch_name) AS num_accounts
FROM branch b
ORDER BY branch_name;

-- [Problem 1d]
-- Decorrelated the above query
SELECT branch_name,
    COUNT(DISTINCT loan_number) AS loan_count,
    COUNT(DISTINCT account_number) AS num_accounts
FROM branch NATURAL LEFT JOIN loan NATURAL LEFT JOIN account
GROUP BY branch_name
ORDER BY branch_name;




