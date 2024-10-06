-- [Problem 6a]
SELECT time_stamp, flight_date, last_name AS travelers_last_name, 
    first_name AS travelers_first_name
FROM tickets NATURAL JOIN ticket_info NATURAL JOIN customers NATURAL JOIN 
    (SELECT time_stamp
     FROM purchase 
     WHERE customer_id = 54321) AS pur
ORDER BY time_stamp DESC, flight_date ASC, last_name ASC, first_name ASC;

-- [Problem 6b]
WITH total_revenues AS (SELECT code, SUM(price) AS revenue
                        FROM flights NATURAL JOIN tickets 
                            NATURAL JOIN ticket_info
                        WHERE TIMESTAMP(flight_date, flight_time) BETWEEN NOW()
                        - INTERVAL 2 WEEK AND NOW()
                        GROUP BY code)
SELECT aircraft_code, IFNULL(revenue, 0) AS revenue
FROM aircraft NATURAL LEFT JOIN total_revenues;

-- [Problem 6c]
SELECT customer_id, first_name, last_name, email
FROM ticket_info NATURAL JOIN tickets NATURAL JOIN travelers NATURAL JOIN 
    customers NATURAL JOIN flights
WHERE flight_type = 'international' AND
 (ISNULL(passport_number) OR ISNULL(country_citizenship) OR 
  ISNULL(contact_name) OR ISNULL(contact_phone_number));



