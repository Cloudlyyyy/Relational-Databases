-- [Problem 1a]
SELECT SUM(maxscore) AS perfect_score
FROM assignment;

-- [Problem 1b]
SELECT sec_name, COUNT(username) AS num_students 
FROM section NATURAL JOIN student
GROUP BY sec_name;

-- [Problem 1c]
CREATE VIEW score_totals AS
    SELECT username, SUM(score) AS total_score
    FROM student NATURAL JOIN submission
    WHERE graded = 1
    GROUP BY username;

SELECT * FROM score_totals;

-- [Problem 1d]
CREATE VIEW passing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score > 40
    ORDER BY total_score DESC;

SELECT * FROM passing;

-- [Problem 1e]
CREATE VIEW failing AS
    SELECT username, total_score
    FROM score_totals
    WHERE total_score < 40
    ORDER BY total_score DESC;

SELECT * FROM failing;

-- [Problem 1f]
SELECT username
FROM assignment NATURAL JOIN submission NATURAL LEFT JOIN fileset NATURAL JOIN 
    passing
WHERE fset_id IS NULL
AND shortname LIKE 'lab%';

-- [Problem 1g]
SELECT DISTINCT username
FROM assignment NATURAL JOIN submission NATURAL LEFT JOIN fileset NATURAL JOIN 
    passing
WHERE fset_id IS NULL
AND shortname IN ('midterm', 'final');

--collins

-- [Problem 2a]
SELECT DISTINCT username 
FROM fileset NATURAL JOIN assignment NATURAL JOIN submission
WHERE sub_date > due
AND shortname LIKE 'midterm%' 
ORDER BY username ASC;

-- [Problem 2b]
SELECT EXTRACT(HOUR from sub_date) AS submit_hour, COUNT(sub_id) AS num_submits
FROM fileset NATURAL JOIN assignment NATURAL JOIN submission
WHERE shortname LIKE 'lab%'
GROUP BY submit_hour
ORDER BY submit_hour ASC;

-- [Problem 2c]
SELECT COUNT(sub_id) AS total_number_final_exams 
FROM fileset NATURAL JOIN submission NATURAL JOIN assignment 
WHERE shortname LIKE 'final%'
AND sub_date >= due - INTERVAL '30' MINUTE
AND sub_date < due;

-- [Problem 3a]
ALTER TABLE student 
ADD email VARCHAR(200) NULL;

UPDATE student
SET email =  CONCAT(username, '@school.edu');

ALTER TABLE student 
MODIFY email VARCHAR(200) NOT NULL; 

-- [Problem 3b]
ALTER TABLE assignment 
ADD submit_files TINYINT
DEFAULT 1;

UPDATE assignment 
SET submit_files = 0
WHERE shortname LIKE 'dq%';

-- [Problem 3c]
CREATE TABLE gradescheme (
    scheme_id       INTEGER, 
    scheme_desc     VARCHAR(100)     NOT NULL, 
    PRIMARY KEY(scheme_id)
);

INSERT INTO gradescheme VALUES
    (0, 'Lab assignment with min-grading.'),
    (1, 'Daily quiz.'), 
    (2, 'Midterm or final exam.');

ALTER TABLE assignment 
RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment
MODIFY scheme_id INTEGER NOT NULL;

ALTER TABLE assignment 
ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);


