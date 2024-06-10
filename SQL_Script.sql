--     S  T  A  G  E  2     --

-- Creating the database

CREATE database Aurelius;
USE Aurelius;

-- Creating the tables in the database

CREATE TABLE CustomerTable
(
	CustomerID   CHAR (13)     PRIMARY KEY,
	FirstName    VARCHAR (100) NOT NULL,
	LastName     VARCHAR (100) NOT NULL,
	DateOfBirth  DATE          NOT NULL,
	StreetNumber INT           NOT NULL,
	StreetName   VARCHAR (100) NOT NULL,
	Area         VARCHAR (100) NOT NULL,
	ZipCode      INT           NOT NULL,
	Province     VARCHAR (100) NOT NULL
);

CREATE TABLE AccountTable
(
	CustomerID     CHAR (13)                 NOT NULL,
	AccountNumber  CHAR (16)                 PRIMARY KEY,
	AccountType    ENUM('Checking','Saving') NOT NULL,
	CurrentBalance NUMERIC(10,2)             NOT NULL DEFAULT 0.00 CHECK (CurrentBalance >= 0),
    
    CONSTRAINT fkCustomerID FOREIGN KEY (CustomerID) REFERENCES CustomerTable(CustomerID)
);

CREATE TABLE TransactionTable
(
	AccountNumber   CHAR (16)                    NOT NULL,
	TransactionID   INT                          AUTO_INCREMENT PRIMARY KEY,
	Amount          NUMERIC(10,2)                NOT NULL CHECK (Amount >= 0),
	TransactionType ENUM ('Deposit','Withdrawl') NOT NULL,
	TransactionDate DATE                         NOT NULL,
    
    CONSTRAINT fkAccountNumber FOREIGN KEY (AccountNumber) REFERENCES AccountTable(AccountNumber)
);

-- Altering the auto increment on transaction table to display how we want it

ALTER TABLE TransactionTable AUTO_INCREMENT = 1001;

-- Inserting into the tables

-- CustomerTable inserts

INSERT INTO CustomerTable
VALUES
('8505150100057','Sarah', 'Connor', '1985-05-15','123','Elm Street','Los Angeles','90210','USA'),

('7811230250089','Bob', 'Smith','1978-11-23', '456','Oak Avenue','New York','10001','USA');

-- AccountTable inserts

-- S A R A H ' S   A C C O U N T
INSERT INTO AccountTable (CustomerID, AccountNumber, AccountType)
VALUES
('8505150100057', '7369449868901234', 'Checking'),

('8505150100057', '4575051833457645', 'Saving');

-- B O B ' S   A C C O U N T 
INSERT INTO AccountTable (CustomerID, AccountNumber, AccountType)
VALUES
('7811230250089', '3067104739007895', 'Checking'),

('7811230250089', '8315208657672837', 'Saving');

-- TransactionTable inserts

-- S A R A H ' S   C H E C K I N G ' S   A C C O U N T
INSERT INTO TransactionTable(AccountNumber, Amount, TransactionType, TransactionDate)
VALUES
('7369449868901234',100,'Deposit','2024-01-01'),
('7369449868901234',20,'Withdrawl','2024-01-28'),
('7369449868901234',50,'Deposit','2024-02-01');

-- S A R A H ' S   S A V I N G ' S   A C C O U N T
INSERT INTO TransactionTable(AccountNumber, Amount, TransactionType, TransactionDate)
VALUES
('4575051833457645',200,'Deposit','2024-01-01'),
('4575051833457645',50,'Withdrawl','2024-02-05'),
('4575051833457645',150,'Deposit','2024-02-15');

-- B O B ' S   C H E C K I N G   A C C O U N T
INSERT INTO TransactionTable(AccountNumber, Amount, TransactionType, TransactionDate)
VALUES
('3067104739007895',300,'Deposit','2024-02-14'),
('3067104739007895',100, 'Withdrawl','2024-03-05'),
('3067104739007895',50,'Withdrawl','2024-03-11');


-- B O B ' S   S A V I N G ' S   A C C O U N T
INSERT INTO TransactionTable(AccountNumber, Amount, TransactionType, TransactionDate)
VALUES
('8315208657672837',400,'Deposit','2024-01-25'),
('8315208657672837',150,'Withdrawl','2024-02-01'),
('8315208657672837',200,'Deposit','2024-03-25');


-- Display tables to ensure everything it there and inserted

SELECT * FROM CustomerTable;

SELECT * FROM AccountTable;

SELECT * FROM TransactionTable;

-- Altering my tables to add or subtract amounts in transaction table
SET SQL_SAFE_UPDATES=0;

UPDATE AccountTable AS A
JOIN (
    SELECT 
        AccountNumber,
        SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE -Amount END) AS TotalAmount
    FROM TransactionTable
    GROUP BY AccountNumber
) AS T ON A.AccountNumber = T.AccountNumber
SET A.CurrentBalance = A.CurrentBalance + T.TotalAmount;

--     S  T  A  G  E  3     --


-- Displaying address when given CustomerID (concating so displays in one column)

-- S A R A H ' S   A D D R E S S
SELECT CONCAT (StreetNumber, '-', StreetName, '-', Area, '-', ZipCode, '-', Province) AS Address
FROM CustomerTable WHERE CustomerID = '8505150100057';

-- B O B ' S   A D D R E S S
SELECT CONCAT (StreetNumber, '-', StreetName, '-', Area, '-', ZipCode, '-', Province) AS Address
FROM CustomerTable WHERE CustomerID = '7811230250089';


-- Displaying blances for all accounts linked to CustomerID

-- S A R A H ' S   B A L A N C E S
SELECT AccountNumber, CurrentBalance
FROM AccountTable WHERE CustomerID = '8505150100057';

-- B O B ' S   B A L A N C E S
SELECT AccountNumber, CurrentBalance
FROM AccountTable WHERE CustomerID = '7811230250089';


-- Displaying overview of all transactions for all Checking accounts linked to a CustomerID

-- S A R A H ' S   T R A N S A C T I O N S
SELECT 
    a.AccountNumber,
    a.AccountType,
    t.TransactionID,
    t.Amount,
    t.TransactionType,
    t.TransactionDate
FROM 
    CustomerTable AS c
INNER JOIN 
    AccountTable a ON c.CustomerID = a.CustomerID
INNER JOIN 
    TransactionTable t ON a.AccountNumber = t.AccountNumber
WHERE 
    a.AccountType = 'Checking' AND a.CustomerID = '8505150100057';

-- B O B ' S   T R A N S A C T I O N S
SELECT 
    a.AccountNumber,
    a.AccountType,
    t.TransactionID,
    t.Amount,
    t.TransactionType,
    t.TransactionDate
FROM 
    CustomerTable AS c
INNER JOIN 
    AccountTable a ON c.CustomerID = a.CustomerID
INNER JOIN 
    TransactionTable t ON a.AccountNumber = t.AccountNumber
WHERE 
    a.AccountType = 'Checking' AND a.CustomerID = '7811230250089';


--     S  T  A  G  E  4     --
-- Connecting mySQL in Java programming

--     S  T  A  G  E  5     --
-- Queries to run in java programming
SELECT COUNT(*) AS numRecords FROM customertable;

SELECT COUNT(AccountNumber) AS numAccount FROM CustomerTable
JOIN AccountTable ON CustomerTable.CustomerID = AccountTable.CustomerID
WHERE CustomerTable.FirstName = 'Sarah';

SELECT AccountNumber, SUM(CASE WHEN TransactionType = 'Deposit' THEN Amount ELSE -Amount END) AS TotalTransaction
FROM TransactionTable
WHERE AccountNumber = '3067104739007895'
GROUP BY AccountNumber;
