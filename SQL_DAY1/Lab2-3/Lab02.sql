-- Tạo cơ sở dữ liệu Lab02
CREATE DATABASE Lab02;
GO
-- Gọi cơ sở dữ liệu ra sử dụng
USE Lab02;
GO
-- Khai báo biến Name, gán giá trị và in ra
DECLARE @Name NVARCHAR(50) = 'Ngô Xuân Hưởng';
PRINT @Name;
GO
-- Khai báo biến Age, gán giá trị và in ra
DECLARE @Age INT = 20;
PRINT @Age;
GO
-- Tạo bảng Employee với các cột được yêu cầu
CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(35),
    Gender BIT,
    BirthDay DATETIME,
    Address NVARCHAR(MAX),
    Email VARCHAR(50),
    Salary FLOAT
);
GO
-- Thêm cột Phone vào bảng Employee
ALTER TABLE Employee
ADD Phone VARCHAR(20);
GO
-- Nhập vào ít nhất 5 bản ghi
INSERT INTO Employee (ID, FullName, Gender, BirthDay, Address, Email, Salary, Phone)
VALUES 
(1, 'Nguyen Van A', 1, '1985-03-15', 'Ha Noi', 'a@example.com', 2500000, '0123456789'),
(2, 'Le Thi B', 0, '1990-07-22', 'Hai Phong', 'b@example.com', 1800000, '0987654321'),
(3, 'Tran Van C', 1, '1988-11-05', 'Ha Noi', 'c@example.com', 3000000, '0912345678'),
(4, 'Pham Thi D', 0, '1995-05-10', 'Da Nang', 'd@example.com', 2100000, '0908765432'),
(5, 'Hoang Van E', 1, '1979-12-25', 'HCM City', 'e@example.com', 1500000, '0934567890');
GO
-- Đưa ra những nhân viên có địa chỉ ở Hà Nội
SELECT * FROM Employee
WHERE Address LIKE '%Ha Noi%';
GO
-- Sửa tên nhân viên có mã là NV01 thành tên Tôi là ai (giả sử ID = 1 là mã NV01)
UPDATE Employee
SET FullName = 'Tôi là ai'
WHERE ID = 1;
GO
-- Xóa những nhân viên có tuổi > 50
DELETE FROM Employee
WHERE DATEDIFF(YEAR, BirthDay, GETDATE()) > 50;
GO
-- Tạo bảng OldEmployees với cấu trúc tương tự bảng Employee
CREATE TABLE OldEmployees (
    ID INT PRIMARY KEY,
    FullName NVARCHAR(35),
    Gender BIT,
    BirthDay DATETIME,
    Address NVARCHAR(MAX),
    Email VARCHAR(50),
    Salary FLOAT,
    Phone VARCHAR(20)
);
GO

INSERT INTO Employee (ID, FullName, Gender, BirthDay, Address, Email, Salary, Phone)
VALUES 
(6, 'Nguyen Van A1', 1, '1935-03-15', 'Ha Noi', 'a@example.com', 2500000, '0123456789'),
(7, 'Le Thi B1', 0, '1910-07-22', 'Hai Phong', 'b@example.com', 1800000, '0987654321'),
(8, 'Tran Van C1', 1, '1918-11-05', 'Ha Noi', 'c@example.com', 3000000, '0912345678'),
(9, 'Pham Thi D1', 0, '1905-05-10', 'Da Nang', 'd@example.com', 2100000, '0908765432'),
(10, 'Hoang Van E1', 1, '1999-12-25', 'HCM City', 'e@example.com', 1500000, '0934567890');
GO

-- Sao chép những nhân viên có tuổi > 50 từ bảng Employee sang bảng OldEmployees
INSERT INTO OldEmployees (ID, FullName, Gender, BirthDay, Address, Email, Salary, Phone)
SELECT ID, FullName, Gender, BirthDay, Address, Email, Salary, Phone
FROM Employee
WHERE DATEDIFF(YEAR, BirthDay, GETDATE()) > 50;
GO

-- Đếm số sinh viên
SELECT COUNT(*) AS EmployeeCount FROM Employee;
GO