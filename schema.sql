-- Create Database
CREATE DATABASE IF NOT EXISTS CyberSecurityLogs;
USE CyberSecurityLogs;

-- Create User Table
CREATE TABLE IF NOT EXISTS users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    Email VARCHAR(100),
    Role VARCHAR(50)
);

-- Create Login Attempts Table
CREATE TABLE IF NOT EXISTS login_attempts (
    AttemptID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Status ENUM('SUCCESS', 'FAILED'),
    IPAddress VARCHAR(50),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- Create IP Blacklist Table
CREATE TABLE IF NOT EXISTS ip_blacklist (
    BlacklistID INT AUTO_INCREMENT PRIMARY KEY,
    IPAddress VARCHAR(50) UNIQUE,
    BlacklistedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger to Auto-Blacklist IP after 3 Failed Attempts
DELIMITER $$
CREATE TRIGGER blacklist_ip_trigger
AFTER INSERT ON login_attempts
FOR EACH ROW
BEGIN
    IF (NEW.Status = 'FAILED') THEN
        IF (
            (SELECT COUNT(*) 
             FROM login_attempts 
             WHERE IPAddress = NEW.IPAddress 
             AND Status = 'FAILED' 
             AND Timestamp >= (NOW() - INTERVAL 5 MINUTE)
            ) >= 3
        ) THEN
            IF NOT EXISTS (
                SELECT 1 FROM ip_blacklist WHERE IPAddress = NEW.IPAddress
            ) THEN
                INSERT INTO ip_blacklist (IPAddress) VALUES (NEW.IPAddress);
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure for Weekly Report Generation
DELIMITER $$
CREATE PROCEDURE GenerateWeeklyReport()
BEGIN
    SELECT 'Firewall Breaches' AS EventType, SourceIP, DestinationIP, ThreatLevel, Timestamp
    FROM firewall_logs
    WHERE Timestamp >= (NOW() - INTERVAL 7 DAY);

    SELECT 'Unauthorized Access' AS EventType, UserID, Resource, IPAddress, Timestamp
    FROM access_logs
    WHERE Timestamp >= (NOW() - INTERVAL 7 DAY);

    SELECT 'Blacklisted IPs' AS EventType, IPAddress, BlacklistedAt
    FROM ip_blacklist
    WHERE BlacklistedAt >= (NOW() - INTERVAL 7 DAY);
END $$
DELIMITER ;
