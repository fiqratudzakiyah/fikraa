CREATE TABLE Student (
    StudentNo INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Major VARCHAR(50) NOT NULL
);

CREATE TABLE Instructor (
    InstructorNo INT PRIMARY KEY,
    InstructorName VARCHAR(100) NOT NULL,
    InstructorLocation VARCHAR(100) NOT NULL
);

CREATE TABLE Course (
    CourseNo INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    InstructorNo INT,
    FOREIGN KEY (InstructorNo) REFERENCES Instructor(InstructorNo)
);

CREATE TABLE Enrollment (
    StudentNo INT,
    CourseNo INT,
    Grade CHAR(2),
    PRIMARY KEY (StudentNo, CourseNo),
    FOREIGN KEY (StudentNo) REFERENCES Student(StudentNo),
    FOREIGN KEY (CourseNo) REFERENCES Course(CourseNo)
);

CREATE OR REPLACE PROCEDURE update_replacement_cost(new_cost NUMERIC) 
LANGUAGE plpgsql 
AS $$
BEGIN
    UPDATE film
    SET replacement_cost = new_cost;
END;
$$;

CREATE OR REPLACE FUNCTION get_rating_category(rating VARCHAR) 
RETURNS VARCHAR AS $$
BEGIN
    RETURN CASE 
        WHEN rating IN ('G', 'PG') THEN 'Family'
        WHEN rating IN ('PG-13') THEN 'Teen'
        WHEN rating IN ('R', 'NC-17') THEN 'Adult'
        ELSE 'Unknown'
    END;
END;
$$ LANGUAGE plpgsql;

SELECT category.name AS category, film.title, COUNT(rental.rental_id) AS total_rentals,
       RANK() OVER (PARTITION BY category.name ORDER BY COUNT(rental.rental_id) DESC) AS rank
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name, film.title
ORDER BY category.name, rank
LIMIT 5;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100;

CREATE INDEX idx_payment_amount ON payment(amount);

EXPLAIN ANALYZE 
SELECT payment_id, customer_id 
FROM payment 
WHERE amount > 5;
CREATE INDEX idx_amount ON payment(amount);
EXPLAIN ANALYZE 
SELECT payment_id, customer_id 
FROM payment 
WHERE amount > 5;

SELECT MIN(payment_date), MAX(payment_date) FROM payment;
CREATE TABLE payment_partitioned (
    payment_id SERIAL NOT NULL,
    customer_id INT NOT NULL,
    amount NUMERIC(5,2) NOT NULL,
    payment_date DATE NOT NULL
) PARTITION BY RANGE (payment_date);
CREATE TABLE payment_2023 PARTITION OF payment_partitioned 
FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');

CREATE TABLE payment_2024 PARTITION OF payment_partitioned 
FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
EXPLAIN ANALYZE 
SELECT * FROM payment WHERE payment_date BETWEEN '2023-01-01' AND '2023-12-31';
