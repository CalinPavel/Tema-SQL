use homework;

drop table if exists advisorship;
drop table if exists student;
drop table if exists professor;
drop table if exists person;
drop table if exists address;

CREATE TABLE address (
    address_id VARCHAR(36) PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    postalcode INT,
    country VARCHAR(255)
);

CREATE TABLE person (
    person_id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255),
    phoneNumber VARCHAR(14),
    emailAddress VARCHAR(255),
    address_id VARCHAR(36),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);


CREATE TABLE professor (
    professor_id VARCHAR(36) PRIMARY KEY,
    salary int not null,
    staffNumber int not null,
    yearsOfService int,
    numberOfClasses int,
	person_id VARCHAR(36) UNIQUE,
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);

CREATE TABLE student (
    student_id VARCHAR(36) PRIMARY KEY,
    studentNumber int,
    averageMark int,
    advisor_id VARCHAR(36),
    FOREIGN KEY (advisor_id) REFERENCES Professor(professor_id),
	person_id VARCHAR(36) UNIQUE,
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);

CREATE TABLE advisorship (
    advisorship_id VARCHAR(36) PRIMARY KEY,
    professor_id VARCHAR(36),
    student_id VARCHAR(36),
    FOREIGN KEY (professor_id) REFERENCES professor(professor_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

DELIMITER //
CREATE TRIGGER check_student_limit
BEFORE INSERT ON advisorship
FOR EACH ROW
BEGIN
    DECLARE student_count INT;
    SET student_count = (
        SELECT COUNT(*) FROM advisorship WHERE professor_id = NEW.professor_id
    );
    IF student_count >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prea multi studenti adaugati la un singur profesor!';
    END IF;
END;