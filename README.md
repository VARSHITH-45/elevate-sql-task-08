**SQL Stored Procedures & Functions | Task 08**


This repository contains the SQL script Procedureshealthcare_schema.sql, which provides a practical demonstration of creating and utilizing Stored Procedures and User-Defined Functions (UDFs). Using a healthcare database schema, the script showcases how to encapsulate reusable logic to perform complex actions and calculations efficiently.

Stored routines are essential for creating a robust, maintainable, and secure database application layer.

**Tasks Performed & Core Concepts**


The script is divided into two clear sections, each demonstrating a key type of stored routine.

**1. Stored Procedure: ScheduleNewAppointment**


This section focuses on creating a routine to perform a specific action with business logic.

**Challenge:** Scheduling a new appointment requires more than a simple INSERT. It needs to check for scheduling conflicts to prevent double-booking a doctor. This logic would have to be repeated in every application that interacts with the database.

**Solution:** A stored procedure named ScheduleNewAppointment is created.

It accepts input parameters (IN) for patient, doctor, and appointment details.

It includes conditional logic (IF/ELSE) to check if the doctor is already busy at the requested time.

It returns a clear success or error message via an output parameter (OUT).

**Diagnosis:** This procedure encapsulates the entire business rule into a single, reusable CALL statement. It improves data integrity by centralizing the conflict-checking logic and simplifies application development. The script also demonstrates the use of DELIMITER to handle multi-statement procedure bodies.

**2. Stored Function: CalculatePatientAge**


This section demonstrates how to create a reusable routine for calculations that can be used directly within queries.

**Challenge:** Frequently needing to calculate a patient's age from their date of birth within different queries can lead to repetitive and inconsistent code.

**Solution:** A user-defined function named CalculatePatientAge is created.

It accepts a DATE parameter for the date of birth.

It performs a calculation and RETURNS a single INT value representing the patient's age.

It is marked as DETERMINISTIC because it will always return the same result for the same input on a given day.

**Diagnosis:** The function can be used in any SELECT statement just like a built-in SQL function (e.g., YEAR() or CONCAT()). This simplifies queries, ensures the age calculation is performed consistently everywhere, and makes the SQL code much more readable.

**How to Use**

Ensure the healthcare database schema is created and populated with data.

Open the Procedureshealthcare_schema.sql file in a MySQL-compatible client.

Execute the script to create the procedure and the function. Note the use of DELIMITER to allow the server to correctly parse the routines.

Run the subsequent CALL statement and SELECT queries provided as examples to see the stored routines in action.
