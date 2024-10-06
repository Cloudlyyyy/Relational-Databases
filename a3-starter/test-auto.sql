-- [Problem 2a]

INSERT INTO person (driver_id, name, address)
VALUES
('0000000000', 'Adam', '1200 E California Blvd'),
('1010101010', 'Bob', '293 S Holliston Ave'),
('0101010101', 'Cloudly', '275 Cairo Rd');

INSERT INTO car (license, year) 
VALUES 
('ABC1234', 'truck',2000),
('EFG5678', 'SUV', 2001),
('HIJ9012', 'civic', 2002);

INSERT INTO accident (date_occurred, location, summary) 
VALUES
('2005-06-06 10:32:21', 'Merging lane into 880 Highway', 'two vehicles collided while merging'),
('2004-07-04 01:38:24', 'Holliston Ave', 'hit a pedestrian'),
('2003-05-02 11:11:11', 'California Blvd', 'hit a curb');

INSERT INTO owns (driver_id, license)
VALUES
('000000000', 'ABC1234'),
('1010101010', 'EFG5678'),
('0101010101', 'HIJ9012');

INSERT INTO participated (driver_id, license, report_number, damage_amount) 
VALUES
('000000000', 'ABC1234', 1500.00),
('1010101010', 'EFG5678', 750.00 ),
('0101010101', 'HIJ9012', 2000.00);

-- [Problem 2b]

UPDATE person SET driver_id = '0000000001'
WHERE name = 'Justin';

UPDATE car SET license = 'LMN3456' WHERE 
year = 2003;

-- [Problem 2c]

-- DELETE FROM car 
-- WHERE license = 'HIJ9012';