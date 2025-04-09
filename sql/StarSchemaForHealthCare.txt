#database
CREATE DATABASE HealthAnalyticsDW;
USE HealthAnalyticsDW;

#Dimension tables
CREATE TABLE Dim_Individual (
    Individual_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Sex VARCHAR(10),
    DOB DATE,
    Blood_Group VARCHAR(5),
    Street_Address TEXT,
    City_Name VARCHAR(50),
    State_Name VARCHAR(50),
    Postal_Code VARCHAR(10),
    InsuranceRef_ID INT
);
#doctor Dimension Table
CREATE TABLE Dim_Physician (
    Physician_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(100),
    Last_Name VARCHAR(100),
    Department VARCHAR(100),
    Clinic_ID INT
);

#hospital dimension table
CREATE TABLE Dim_Clinic (
    Clinic_ID INT PRIMARY KEY AUTO_INCREMENT,
    Clinic_Name VARCHAR(100),
    Ownership_Type VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50)
);

#diagnosis table
CREATE TABLE Dim_Condition (
    Condition_ID INT PRIMARY KEY AUTO_INCREMENT,
    ICD_Code VARCHAR(20),
    Condition_Desc TEXT
);

#procedure table
CREATE TABLE Dim_Treatment (
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Treatment_Code VARCHAR(20),
    Procedure_Desc TEXT
);
#outcometable
CREATE TABLE Dim_Result (
    Result_ID INT PRIMARY KEY AUTO_INCREMENT,
    Result_Desc VARCHAR(100)
);

#insurance table
CREATE TABLE Dim_Coverage (
    Coverage_ID INT PRIMARY KEY AUTO_INCREMENT,
    Insurer_Name VARCHAR(100)
);
#fact Table
CREATE TABLE Fact_Healthcare_Service (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Individual_ID INT,
    Physician_ID INT,
    Clinic_ID INT,
    Condition_ID INT,
    Treatment_ID INT,
    Start_Date DATE,
    End_Date DATE,
    Cost DECIMAL(10,2),
    Covered_Amount DECIMAL(10,2),
    Paid_Amount DECIMAL(10,2),
    Result_ID INT,
    FOREIGN KEY (Individual_ID) REFERENCES Dim_Individual(Individual_ID),
    FOREIGN KEY (Physician_ID) REFERENCES Dim_Physician(Physician_ID),
    FOREIGN KEY (Clinic_ID) REFERENCES Dim_Clinic(Clinic_ID),
    FOREIGN KEY (Condition_ID) REFERENCES Dim_Condition(Condition_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Dim_Treatment(Treatment_ID),
    FOREIGN KEY (Result_ID) REFERENCES Dim_Result(Result_ID)
);

#dummy Data
#individual
INSERT INTO Dim_Individual (First_Name, Last_Name, Sex, DOB, Blood_Group, Street_Address, City_Name, State_Name, Postal_Code, InsuranceRef_ID)
VALUES 
('Shoyana', 'KC', 'Female', '1997-12-10', 'A+', 'Kathmandu', 'Bagmati', 'Nepal', '73301', 1),
('Samir', 'Sitaula', 'Male', '1995-06-05', 'B-', 'S Bristol St', 'Santa Ana', 'CA', '92704', 2);

#physician
INSERT INTO Dim_Physician (First_Name, Last_Name, Department, Clinic_ID)
VALUES 
('Nina', 'Thompson', 'Neurology', 1),
('Raj', 'Kumar', 'Pediatrics', 2);

#clinic
INSERT INTO Dim_Clinic (Clinic_Name, Ownership_Type, City, State)
VALUES 
('Kaiser Permanente', 'Public', 'Santa Ana', 'CA'),
('Covered Californoa', 'Private', 'Santa Clara', 'CA');

#condition
INSERT INTO Dim_Condition (ICD_Code, Condition_Desc)
VALUES 
('J45', 'Asthma'),
('I25', 'Chronic Ischemic Heart Disease');

#treatment
INSERT INTO Dim_Treatment (Treatment_Code, Procedure_Desc)
VALUES 
('TRT101', 'Inhaler Therapy'),
('TRT102', 'Cardiac Stress Test');

#result
INSERT INTO Dim_Result (Result_Desc)
VALUES 
('Improved'),
('Stable');

#coverage
INSERT INTO Dim_Coverage (Insurer_Name)
VALUES 
('BlueCross'), 
('Humana'), 
('Cigna');

#insert on fact table
INSERT INTO Fact_Healthcare_Service (
Individual_ID, Physician_ID, Clinic_ID, Condition_ID,
Treatment_ID, Start_Date, End_Date, Cost,
Covered_Amount, Paid_Amount, Result_ID)
VALUES 
(1, 1, 1, 1, 1, '2025-02-01', '2025-02-10', 500, 400, 100, 1),
(2, 2, 2, 2, 2, '2025-03-15', '2025-03-22', 1200, 800, 400, 2);

#analytical queries
#total cost
SELECT c.Clinic_Name AS Clinic, SUM(f.Cost) AS Total_Clinic_Cost
FROM Fact_Healthcare_Service f
JOIN Dim_Clinic c ON f.Clinic_ID = c.Clinic_ID
GROUP BY c.Clinic_Name;

#Most common condition
SELECT cond.Condition_Desc AS 'Condition', COUNT(f.Service_ID) AS Occurrences
FROM Fact_Healthcare_Service f
JOIN Dim_Condition cond ON f.Condition_ID = cond.Condition_ID
GROUP BY cond.Condition_Desc
ORDER BY Occurrences DESC;

#average lenght of stay per clinic
SELECT c.Clinic_Name, 
       AVG(DATEDIFF(f.End_Date, f.Start_Date)) AS Avg_Stay
FROM Fact_Healthcare_Service f
JOIN Dim_Clinic c ON f.Clinic_ID = c.Clinic_ID
GROUP BY c.Clinic_Name;

#total revenue
SELECT p.First_Name, p.Last_Name, SUM(f.Paid_Amount) AS Revenue
FROM Fact_Healthcare_Service f
JOIN Dim_Physician p ON f.Physician_ID = p.Physician_ID
GROUP BY p.First_Name, p.Last_Name
ORDER BY Revenue DESC;







