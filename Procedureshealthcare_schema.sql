-- =================================================================
-- SQL Query Script: Stored Procedures & Functions
-- =================================================================
-- This script shows how to create and use Stored Procedures (for actions)
-- and Stored Functions (for calculations). These are like saved recipes
-- that you can reuse without rewriting the whole query every time.
-- =================================================================
-- Selects the 'healthcare' database to ensure all subsequent commands are run against it.
use healthcare;
-- =================================================================
-- 1. CREATE PROCEDURE (Performing an Action)
-- =================================================================
-- A PROCEDURE is a pre-packaged set of commands to perform a specific
-- action, like adding a new appointment. It can take inputs and give
-- back outputs, but it doesn't have to return a value.

-- IMPORTANT NOTE ON DELIMITER:
-- Normally, SQL runs a command when it sees a semicolon (;).
-- But our procedure recipe contains many semicolons inside it.
-- So, we temporarily change the "end of command" signal to `//`.
-- This lets SQL swallow the whole recipe in one go.
DELIMITER //

CREATE PROCEDURE ScheduleNewAppointment(
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_AppointmentDateTime DATETIME,
    IN p_Reason TEXT,
    OUT p_StatusMessage VARCHAR(255)
)
BEGIN
    -- This is our business logic. We don't want to double-book a doctor.
    -- We'll use a variable to check if an appointment already exists at that time.
    DECLARE appointment_count INT DEFAULT 0;

    -- Check for a conflicting appointment for the same doctor at the same time.
    SELECT COUNT(*)
    INTO appointment_count
    FROM Appointments
    WHERE DoctorID = p_DoctorID AND AppointmentDateTime = p_AppointmentDateTime;

    -- Now for the conditional logic (the IF statement).
    IF appointment_count > 0 THEN
        -- If a conflict exists, set an error message.
        SET p_StatusMessage = 'ERROR: Doctor is already booked at this time.';
    ELSE
        -- If no conflict, go ahead and insert the new appointment.
        INSERT INTO Appointments(PatientID, DoctorID, AppointmentDateTime, Reason)
        VALUES (p_PatientID, p_DoctorID, p_AppointmentDateTime, p_Reason);
        SET p_StatusMessage = 'SUCCESS: Appointment scheduled successfully.';
    END IF;
END //

-- Now, we change the delimiter back to the normal semicolon.
DELIMITER ;

-- HOW TO USE THE PROCEDURE:
-- We use the CALL command and pass in our parameters.
-- The '@status' variable will catch the output message from our procedure.

-- Let's try to book a valid appointment.
CALL ScheduleNewAppointment(5, 5, '2025-12-01 11:00:00', 'Follow-up Consultation', @status);
-- Now, let's see what the procedure told us.
SELECT @status;

-- Now, let's try to book an appointment at the exact same time (this should fail).
CALL ScheduleNewAppointment(6, 5, '2025-12-01 11:00:00', 'Second Opinion', @status);
SELECT @status;


-- =================================================================
-- 2. CREATE FUNCTION (Returning a Single Value)
-- =================================================================
-- A FUNCTION is a different beast. It's a recipe that always
-- returns a single value. You use it for calculations, like working
-- out a patient's age. You can use a function right in a SELECT statement.

DELIMITER //

CREATE FUNCTION CalculatePatientAge(
    p_DateOfBirth DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    -- The logic for the calculation.
    -- This is a simple calculation based on the year.
    DECLARE age INT;
    SET age = YEAR(CURDATE()) - YEAR(p_DateOfBirth);
    RETURN age;
END //

DELIMITER ;

-- HOW TO USE THE FUNCTION:
-- You can use a function directly in your SELECT queries, just like
-- any other built-in SQL function.

-- Get the age of a specific patient (PatientID 4, born in 1965).
SELECT
    FirstName,
    SecondName,
    CalculatePatientAge(DateOfBirth) AS Age
FROM
    Patients
WHERE
    PatientID = 4;

-- Get the age for ALL patients.
SELECT
    FirstName,
    SecondName,
    DateOfBirth,
    CalculatePatientAge(DateOfBirth) AS CurrentAge
FROM
    Patients;
