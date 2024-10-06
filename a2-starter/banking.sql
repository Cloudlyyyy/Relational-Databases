-- [Problem 0a]
/* If we were to use FLOAT or DOUBLE instead of NUMERIC, balance will have many
   decimal places which doesn't accurately represent money since we can't have 
   a fraction of a penny, so its better to represent money as whole numbers.
*/

-- [Problem 0b]
/* One attribute in the account relation which could reasonably be represented 
   with a type different is Char and an advantage would be that it's a fixed 
   length.
*/

-- [Problem 1a]
/* Find the loan number and amount that have loan of 1000 <= amount <= 2000 */
SELECT loan_number, amount
FROM loan
WHERE amount >= 1000
    AND amount <= 2000;

-- [Problem 1b]
/* Find loan number and amount owned by Smith (customer). Order is in ASC by 
   default.
*/ 
SELECT loan.loan_number, loan.amount
FROM customer NATURAL JOIN loan NATURAL JOIN borrower
WHERE customer.customer_name = 'Smith'
ORDER by loan.loan_number;

-- [Problem 1c]
/* Select city of branch where A-446 is open by joining branch and account */
SELECT branch.branch_city
FROM branch NATURAL JOIN account
WHERE account.account_number = 'A-446';

-- [Problem 1d]
/* Find customer name, account number, branch name, and balance by joining 
   account and depositor
*/
SELECT depositor.customer_name, account.account_number, account.branch_name,
       account.balance
FROM account NATURAL JOIN depositor
WHERE depositor.customer_name LIKE 'J%';

-- [Problem 1e]
/* Retrieve names from all customers with more than 5 accounts by grouping by
   customer name and checking if account number is more than 5
*/
SELECT customer_name
FROM depositor 
GROUP BY customer_name
HAVING COUNT(account_number) > 5;

-- [Problem 2a]
/* Find cities where customers live where no bank branch is in city by taking
   the set difference of customer-city and branch city. Order is already at ASC
*/
SELECT DISTINCT customer_city
FROM customer
WHERE customer_city
    NOT IN (SELECT branch_city FROM branch)
ORDER BY customer_city;

-- [Problem 2b]
SELECT customer_name 
FROM customer 
WHERE customer_name NOT IN (SELECT customer_name 
                            FROM depositor)
AND customer_name NOT IN (SELECT customer_name 
                          FROM borrower);

-- [Problem 2c]
UPDATE account 
SET balance = 75 + balance 
WHERE account.branch_name IN (SELECT branch_name
                              FROM branch 
                              WHERE branch_city = 'Horseneck');

-- [Problem 2d]
UPDATE account, branch 
SET balance = 75 + balance
WHERE branch.branch_city = 'Horseneck'
AND account.branch_name = branch.branch_name;

-- [Problem 2e]
SELECT account.account_number, account.branch_name, account.balance 
FROM account JOIN (SELECT branch_name, MAX(balance) AS max 
                           FROM account 
                           GROUP BY branch_name) AS max_account
ON account.balance = max_account.max
AND account.branch_name = max_account.branch_name;

-- [Problem 2f]
SELECT account_number, branch_name, balance
FROM account
WHERE (branch_name, balance) IN (SELECT branch_name, MAX(balance) AS max_balance
                                 FROM account
                                 GROUP BY branch_name);

-- [Problem 3]
SELECT (branch.branch_name, branch.assets, COUNT(branch_copy.branch_name) + 1 AS 'rank')
FROM branch LEFT JOIN branch as branch_copy
ON branch.assets < branch_copy.assets
GROUP BY branch.branch_name
ORDER BY branch.assets DESC;


