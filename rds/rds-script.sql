CREATE DATABASE AWS_COURSE;

CREATE TABLE TRAINERS {
    TRAINER_ID INTEGER PRIMARY KEY,
    TRAINER_NAME VARCHAR(100)
}

INSERT INTO TRAINERS VALUES (1, 'Alex');
INSERT INTO TRAINERS VALUES (2, 'Vova');

SELECT * FROM TRAINERS;
