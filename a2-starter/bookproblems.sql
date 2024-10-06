-- [Problem 1a]
/* Find the names of all students who have taken at least one Comp. Sci. course
   by comparing the course and takes id 
*/
SELECT DISTINCT student.name 
FROM course, student, takes
WHERE course.dept_name = 'Comp. Sci.'
    AND takes.id = student.id
    AND course.course_id = takes.course_id;

-- [Problem 1b]
/* Grouping all instructors through department to find the max salary for each 
   department
*/
SELECT dept_name, MAX(salary) AS max_salary
FROM instructor
GROUP BY dept_name;

-- [Problem 1c]
/* By using the preceding query, find the lowest salary of the department max 
   salary by finding the min of the instructor
*/
SELECT MIN(max_salary) AS smallest_max_salary
FROM (SELECT dept_name, MAX(salary) AS max_salary
      FROM instructor
      GROUP BY dept_name) AS max;

-- [Problem 1d] 
/* Create preceding table by using CREATE TEMPORARY TABLE */
CREATE TEMPORARY TABLE memb_counts (
    SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name
);

SELECT MIN(max_salary) AS smallest_max_salary 
FROM memb_counts;

-- [Problem 2a]
/* Create a new course and add to existing course tables by using insert and 
   add values 
*/ 
INSERT INTO course (course_id, title, dept_name, credits)
    VALUES('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);

-- [Problem 2b]
/* Create a new section and add to existing section table by using insert and
   values
*/
INSERT INTO section (course_id, sec_id, semester, year)
    VALUES('CS-001', 1, 'Winter', 2023);

-- [Problem 2c]
/* Enroll every student whose department is CS in CS-001 by inserting through
   checking their department
*/
INSERT INTO takes 
SELECT id, 'CS-001', 1, 'Winter', year, NULL
FROM student, section
WHERE student.dept_name = 'Comp. Sci.'
    AND section.course_id = 'CS-001';

-- [Problem 2d] 
/* Delete Snow from CS-001 by checking for Snow's id (76543) and remove from 
   table by id
*/ 
DELETE FROM takes 
WHERE id = (SELECT DISTINCT student.id 
            FROM student 
            WHERE student.name = 'Snow') 
    AND takes.course_id = 'CS-001';

-- [Problem 2e]
/* Delete CS-001 from table by checking if course_id is CS-001 */
/* If we run this delete statement without first deleting offerings of this
   course, it won't work because course_id is used for takes and section, so 
   there will still be some courses still remaining after deleting.
*/ 
DELETE FROM course
WHERE course_id = 'CS-001';

-- [Problem 2f]
/* Delete all tuples from takes with any course with the word "database" by 
   checking title of the courses and deleting if contains database
*/ 
DELETE FROM takes 
WHERE course_id  = (SELECT course_id 
                    FROM course 
                    WHERE title LIKE '%database%');

-- [Problem 3a]
/* Find all names of members who borrowed any book from author McGraw-Hill by 
   checking that book id match and that the memb_no matches borrow. Order is in
   ASC by default.
*/
SELECT DISTINCT name
FROM member, book, borrowed 
WHERE member.memb_no = borrowed.memb_no
    AND book.isbn = borrowed.isbn
    AND book.publisher = 'McGraw-Hill'
ORDER BY name;

-- [Problem 3b]
/* Get names of members who borrow all book from author McGraw by creating a
   temp table for all the mcgraw-hill books and selecting the names that has 
   count of all the books (8) meaning that borrow all books by this author
*/
CREATE TEMPORARY TABLE mcgraw_hill_books (
    SELECT DISTINCT name, COUNT(book.isbn) AS count
    FROM member, book, borrowed 
    WHERE member.memb_no = borrowed.memb_no
        AND book.isbn = borrowed.isbn
        AND book.publisher = 'McGraw-Hill'
    GROUP BY name
);

SELECT DISTINCT name
FROM mcgraw_hill_books, book
WHERE mcgraw_hill_books.count = (SELECT COUNT(isbn) 
                                 FROM book 
                                 WHERE book.publisher = 'McGraw-Hill');

-- [Problem 3c]
/* Find the publisher of atleast 5 books by grouping the publisher and name
   and checking the books that have been borrowed by looking if the book 
   ibsn matches the borrow and the member matches. Default is already in ASC.
*/
SELECT book.publisher, member.name 
FROM member, book, borrowed
WHERE book.isbn = borrowed.isbn 
    AND member.memb_no = borrowed.memb_no
GROUP BY publisher, name
HAVING COUNT(publisher) > 5
ORDER BY name;

-- [Problem 3d]
/* Compute the average number of books across all members by division of all
   books checked out (39) by books borrowed by member (10)
 */ 
SELECT COUNT(*) / (SELECT COUNT(*) FROM member) AS avg_num_books
FROM borrowed;

-- [Problem 3e]
/* same thing has 3d but by using temp table of all the books that members 
   borrowed and dividing all books by books borrowed from members. Can't use
   Count(*) since it brings down avg 0.8. Instead we use sum of count 
   from table which is how many times member borrowed 
*/
CREATE TEMPORARY TABLE memb_book_counts (
    SELECT memb_no, COUNT(isbn) AS count
    FROM borrowed
    GROUP BY memb_no
);

SELECT SUM(count) / (SELECT COUNT(*) FROM member) AS avg_num_books
FROM memb_book_counts;
