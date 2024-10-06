-- [Problem 1]
DELIMITER !

CREATE FUNCTION min_submit_interval (sub_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE min INT DEFAULT 0;
    DECLARE count INT DEFAULT 0;
    DECLARE time1 INT DEFAULT 0;
    DECLARE time2 INT DEFAULT 0; 

    DECLARE cur CURSOR FOR
        SELECT UNIX_TIMESTAMP(sub_date) AS time_sttamp
        FROM fileset 
        WHERE fileset.sub_id = sub_id
        ORDER BY time_stamp;

    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;

    OPEN cur; 
    FETCH cur INTO time1;
    WHILE NOT done DO 
        IF NOT done THEN 
            SET count = count + 1;
            IF (time1 - time2) < min THEN 
                SET min = time1 - time2;
            END IF;
            SET time2 = time1;
        END IF;
    END WHILE;
    CLOSE cur; 
    IF count < 2 THEN RETUEN NULL;
    ELSE RETURN min;
    END IF;

END!
DELIMITER ;


-- [Problem 2]
-- max_submit_interval 

DELIMITER !

CREATE FUNCTION max_submit_interval (sub_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE max INT DEFAULT 0;
    DECLARE temp INT DEFAULT 0;
    DECLARE time1 INT DEFAULT 0; 
    DECLARE time2 INT DEFAULT 0; 

    DECLARE cur CURSOR FOR
        SELECT UNIX_TIMESTAMP(sub_date) AS time_stamp
        FROM fileset.sub_id = sub_id 
        ORDER BY time_stamp;

    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
    OPEN cur; 
    FETCH cur INTO time1;
    WHILE NOT done DO 
        IF NOT done THEN 
            SET count = count + 1;
            IF (time1 - time2) > max THEN 
                SET max = time1 - time2;
            END IF;
            SET time2 = time1;
        END IF;
    END WHILE;
    CLOSE cur; 
    IF count < 2 THEN RETUEN NULL;
    ELSE RETURN max;
    END IF;

END!
DELIMITER ;

-- [Problem 3]
-- avg_submit_interval

DELIMITER !

CREATE FUNCTION avg_submit_interval (sub_id INT) RETURNS INT DETERMINISTIC
BEGIN 
    DECLARE avg DOUBLE;

    SELECT (MAX(UNIX_TIMESTAMP(sub_date)) - MIN(UNIX_TIMESTAMP(sub_date))) 
        / (COUNT(*) - 1)
    INTO avg FROM fileset
    WHERE sub_id = sub_id;

    RETURN avg;

END!
DELIMITER ; 

-- [Problem 4]
CREATE INDEX fileset_index ON fileset (sub_id);


