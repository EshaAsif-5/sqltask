CREATE DATABASE Student_db;
USE Student_db;
-- CREATE TABLES
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    class_id INT
);
CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50),
    teacher_id INT
);
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50)
);
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject VARCHAR(50),
    marks INT
);

-- INSERT DATA
-- Students
INSERT INTO Students (student_id, name, age, gender, class_id) VALUES
(1, 'Ahmed', 17, 'Male', 1),
(2, 'Sara', 18, 'Female', 2),
(3, 'Ali', 19, 'Male', 1),
(4, 'Ayesha', 17, 'Female', 3),
(5, 'Usman', 21, 'Male', 2),
(6, 'Zara', 22, 'Female', 3),
(7, 'Hassan', 20, 'Male', 1);

-- Classes
INSERT INTO Classes (class_id, class_name, teacher_id) VALUES
(1, 'Class 10', 101),
(2, 'Class 9', 102),
(3, 'Class 8', 103);

-- Teachers
INSERT INTO Teachers (teacher_id, name, subject) VALUES
(101, 'Mr. Khan', 'Math'),
(102, 'Ms. Fatima', 'Science'),
(103, 'Mr. Bilal', 'English');

-- Marks
INSERT INTO Marks (mark_id, student_id, subject, marks) VALUES
(1, 1, 'Math', 88),
(2, 2, 'Science', 75),
(3, 3, 'Math', 90),
(4, 4, 'English', 65),
(5, 5, 'Science', 95),
(6, 6, 'English', 85),
(7, 7, 'Math', 72),
(8, 1, 'Science', 70),
(9, 2, 'Math', 67),
(10, 4, 'Math', 78);

-- 1. Get the names of all students
SELECT name FROM Students;

-- 2. Get the names of all male students
SELECT name FROM Students WHERE gender = 'Male';

-- 3. Find all students older than 18 years
SELECT * FROM Students WHERE age > 18;

-- 4. Get details of students who are in class_id = 2
SELECT * FROM Students WHERE class_id = 2;

-- 5. List all students ordered by age, youngest first
SELECT * FROM Students ORDER BY age ASC;

-- 6. Show top 5 students with the highest marks in "Math"
SELECT student_id, marks 
FROM Marks 
WHERE subject = 'Math' 
ORDER BY marks DESC 
LIMIT 5;

-- 7. List student names along with their class names
SELECT Students.name, Classes.class_name
FROM Students
JOIN Classes ON Students.class_id = Classes.class_id;

-- 8. Show student names with their teacher’s name for each class
SELECT Students.name AS student_name, Teachers.name AS teacher_name
FROM Students
JOIN Classes ON Students.class_id = Classes.class_id
JOIN Teachers ON Classes.teacher_id = Teachers.teacher_id;

-- 9. Find the average marks for each subject
SELECT subject, AVG(marks) AS average_marks
FROM Marks
GROUP BY subject;

-- 10. Count how many students are in each class
SELECT class_id, COUNT(*) AS total_students
FROM Students
GROUP BY class_id;

-- 11. Find the highest marks scored in "Science"
SELECT MAX(marks) AS highest_science_marks
FROM Marks
WHERE subject = 'Science';

-- 12. List names of students who scored more than the average marks
SELECT name
FROM Students
WHERE student_id IN (
  SELECT student_id
  FROM Marks
  GROUP BY student_id
  HAVING AVG(marks) > (
    SELECT AVG(marks) FROM Marks
  )
);

-- 13. Find the class name where the oldest student studies
SELECT class_name
FROM Classes
WHERE class_id = (
  SELECT class_id
  FROM Students
  ORDER BY age DESC
  LIMIT 1
);

-- 14. Insert a new student named "Ali", age 17, male, in class 3
INSERT INTO Students (student_id, name, age, gender, class_id)
VALUES (8, 'Ali', 17, 'Male', 3);

-- 15. Update the subject of teacher with teacher_id = 1 to "Computer Science"
--  Check teacher_id first; in your data, IDs start from 101
UPDATE Teachers
SET subject = 'Computer Science'
WHERE teacher_id = 101;

-- 16. Delete all students who have age > 25
DELETE FROM Students
WHERE age > 25;

-- 17. Get names of students who have not received marks in "English"
SELECT name
FROM Students
WHERE student_id NOT IN (
  SELECT student_id
  FROM Marks
  WHERE subject = 'English'
);

-- 18. Display each class name with the total number of male and female students
SELECT 
  c.class_name,
  SUM(CASE WHEN s.gender = 'Male' THEN 1 ELSE 0 END) AS male_students,
  SUM(CASE WHEN s.gender = 'Female' THEN 1 ELSE 0 END) AS female_students
FROM Students s
JOIN Classes c ON s.class_id = c.class_id
GROUP BY c.class_name;

-- 19. Get a list of students with total marks across all subjects, ordered from highest to lowest
SELECT s.name, SUM(m.marks) AS total_marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
GROUP BY s.name
ORDER BY total_marks DESC;

-- 20. Create a temp table and store Query #8 in it
CREATE TEMPORARY TABLE Temp_Student_Teachers AS
SELECT Students.name AS student_name, Teachers.name AS teacher_name
FROM Students
JOIN Classes ON Students.class_id = Classes.class_id
JOIN Teachers ON Classes.teacher_id = Teachers.teacher_id;