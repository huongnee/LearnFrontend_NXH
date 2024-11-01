--tạo cơ sở dữ liệu QLHH với các kích thước thiết lập cho Data File và Log
CREATE DATABASE QLHH
ON 
PRIMARY (
    NAME = QLHH_Data,
    FILENAME = 'E:\Tutorial_SQL\luutruSQL\QLHH_Data.mdf',  
    SIZE = 50MB,                            -- Kích thước ban đầu là 50MB
    FILEGROWTH = 10MB,                      -- Mỗi lần tăng thêm 10MB
    MAXSIZE = 200MB                         -- Giới hạn kích thước tối đa là 200MB
)
LOG ON (
    NAME = QLHH_Log,
    FILENAME = 'E:\Tutorial_SQL\luutruSQL\QLHH_Log.ldf',   
    SIZE = 10MB,                            -- Kích thước ban đầu là 10MB
    FILEGROWTH = 5MB                        -- Mỗi lần tăng thêm 5MB, không giới hạn kích thước
);
GO
-- 
USE QLHH;
GO
--
-- Bảng VATTU
CREATE TABLE VATTU (
    MaVTu CHAR(4) NOT NULL PRIMARY KEY,
    TenVTu VARCHAR(100) NOT NULL UNIQUE, 
    DvTinh VARCHAR(10) NULL DEFAULT '', -- Đơn vị tính
    PhanTram REAL CHECK (PhanTram >= 0 AND PhanTram <= 100) -- Tỷ lệ phần trăm (0 <= PhanTram <= 100)
);

-- Bảng NHACC
CREATE TABLE NHACC (
    MaNhaCc CHAR(3) NOT NULL PRIMARY KEY, 
    TenNhaCc VARCHAR(100) NOT NULL,
    DiaChi VARCHAR(200) NOT NULL, 
    DienThoai VARCHAR(20) NULL DEFAULT 'Chưa có' 
);

-- Bảng DONDH
CREATE TABLE DONDH (
    SoDh CHAR(4) NOT NULL PRIMARY KEY, 
    NgayDh DATETIME DEFAULT GETDATE(), -- Ngày đặt hàng, mặc định là ngày hiện hành
    MaNhaCc CHAR(3) NOT NULL, 

    -- Thiết lập khóa ngoại liên kết tới bảng NHACC
    FOREIGN KEY (MaNhaCc) REFERENCES NHACC(MaNhaCc)
);
--
-- Bảng CTDONDH (Chi tiết Đơn đặt hàng)
CREATE TABLE CTDONDH (
    SoDh CHAR(4) NOT NULL, 
    MaVTu CHAR(4) NOT NULL, 
    SlDat INT NOT NULL CHECK (SlDat > 0),
    
    -- Thiết lập khóa chính kết hợp SoDh và MaVTu tức là 1 bản ghi phải có cặp giá trị SoDh và MaVTu duy nhất.
    PRIMARY KEY (SoDh, MaVTu),

    -- Thiết lập khóa ngoại
    FOREIGN KEY (SoDh) REFERENCES DONDH(SoDh),
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)
);

-- Bảng PNHAP (Phiếu nhập hàng)
CREATE TABLE PNHAP (
    SoPn CHAR(4) NOT NULL PRIMARY KEY, 
    NgayNhap DATETIME DEFAULT GETDATE(),
    SoDh CHAR(4) NOT NULL, 
    
    -- Thiết lập khóa ngoại
    FOREIGN KEY (SoDh) REFERENCES DONDH(SoDh)
);

-- Bảng CTPNHAP (Chi tiết nhập hàng)
CREATE TABLE CTPNHAP (
    SoPn CHAR(4) NOT NULL, 
    MaVTu CHAR(4) NOT NULL, 
    SlNhap INT NOT NULL CHECK (SlNhap > 0), -- Số lượng nhập hàng (SlNhap > 0)
    DgNhap MONEY NOT NULL CHECK (DgNhap > 0),
    
    -- Thiết lập khóa chính kết hợp SoPn và MaVTu
    PRIMARY KEY (SoPn, MaVTu),

    -- Thiết lập khóa ngoại
    FOREIGN KEY (SoPn) REFERENCES PNHAP(SoPn),
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)
);
--
-- Bảng PXUAT (Phiếu xuất hàng)
CREATE TABLE PXUAT (
    SoPx CHAR(4) NOT NULL PRIMARY KEY, 
    NgayXuat DATETIME DEFAULT GETDATE(), 
    TenKh VARCHAR(100) NOT NULL 
);

-- Bảng CTPXUAT (Chi tiết xuất hàng)
CREATE TABLE CTPXUAT (
    SoPx CHAR(4) NOT NULL, 
    MaVTu CHAR(4) NOT NULL, 
    SlXuat INT NOT NULL CHECK (SlXuat > 0), 
    DgXuat MONEY NOT NULL CHECK (DgXuat > 0), 
    
    -- Thiết lập khóa chính kết hợp SoPx và MaVTu
    PRIMARY KEY (SoPx, MaVTu),

    -- Thiết lập khóa ngoại
    FOREIGN KEY (SoPx) REFERENCES PXUAT(SoPx),
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)
);

-- Bảng TONKHO (Tồn kho)
CREATE TABLE TONKHO (
    NamThang CHAR(6) NOT NULL, 
    MaVTu CHAR(4) NOT NULL, 
    SlDau INT NOT NULL CHECK (SlDau > 0), 
    TongSLN INT NOT NULL CHECK (TongSLN > 0), 
    TongSLX INT NOT NULL CHECK (TongSLX > 0), 
    SlCuoi AS (SlDau + TongSLN - TongSLX), 
    
    -- Thiết lập khóa chính kết hợp NamThang và MaVTu
    PRIMARY KEY (NamThang, MaVTu),

    -- Thiết lập khóa ngoại
    FOREIGN KEY (MaVTu) REFERENCES VATTU(MaVTu)
);

--Thêm dữ liệu
--
INSERT INTO NHACC (MaNhaCc, TenNhaCc, DiaChi, DienThoai) VALUES
('C01', 'Lê Minh Thành', '54, Kim Mã, Cầu Giấy, Hà Nội', '8781024'),
('C02', 'Trần Quang Anh', '145, Hùng Vương, Hải Dương', '7698154'),
('C03', 'Bùi Hồng Phương', '154/85, Lê Chân, Hải Phòng', '9600125'),
('C04', 'Vũ Nhật Thắng', '198/40 Hương Lộ 14 QTB HCM', '8757757'),
('C05', 'Nguyễn Thị Thúy', '178 Nguyễn Văn Lượng Đà Lạt', '7964251'),
('C07', 'Cao Minh Trung', '125 Lê Quang Sung Nha Trang', 'Chưa có');
--
INSERT INTO VATTU (MaVTu, TenVTu, DvTinh, PhanTram) VALUES
('DD01', 'Đầu DVD Hitachi 1 đĩa', 'Bộ', 40),
('DD02', 'Đầu DVD Hitachi 3 đĩa', 'Bộ', 40),
('TL15', 'Tủ lạnh Sanyo 150 lit', 'Cái', 25),
('TL90', 'Tủ lạnh Sanyo 90 lit', 'Cái', 20),
('TV14', 'Tivi Sony 14 inches', 'Cái', 15),
('TV21', 'Tivi Sony 21 inches', 'Cái', 10),
('TV29', 'Tivi Sony 29 inches', 'Cái', 10),
('VD01', 'Đầu VCD Sony 1 đĩa', 'Bộ', 30),
('VD02', 'Đầu VCD Sony 3 đĩa', 'Bộ', 30);
--
INSERT INTO DONDH (SoDh, NgayDh, MaNhaCc) VALUES
('D001', '2012-01-15', 'C03'),
('D002', '2012-01-30', 'C01'),
('D003', '2012-02-10', 'C02'),
('D004', '2012-02-17', 'C05'),
('D005', '2012-03-01', 'C02'),
('D006', '2012-03-12', 'C05');
--
INSERT INTO CTDONDH (SoDh, MaVTu, SlDat) VALUES
('D001', 'DD01', 10),
('D001', 'DD02', 15),
('D002', 'VD02', 30),
('D003', 'TV14', 10),
('D003', 'TV29', 20),
('D004', 'TL90', 10),
('D005', 'TV14', 10),
('D005', 'TV29', 10),
('D006', 'TV14', 10);
--
INSERT INTO PNHAP (SoPn, NgayNhap, SoDh) VALUES
('N001', '2012-01-17', 'D001'),
('N002', '2012-01-20', 'D001'),
('N003', '2012-01-31', 'D002');
--
INSERT INTO PNHAP (SoPn, NgayNhap, SoDh) VALUES
('N004', '2012-02-01', 'D003');
--
INSERT INTO CTPNHAP (SoPn, MaVTu, SlNhap, DgNhap) VALUES
('N001', 'DD01', 8, 2500000),
('N001', 'DD02', 10, 3500000),
('N002', 'DD01', 2, 2500000),
('N002', 'DD02', 5, 3500000),
('N003', 'VD02', 30, 2500000),
('N004', 'TV14', 5, 2500000),
('N004', 'TV29', 12, 3500000);
--
--SELECT * FROM PNHAP WHERE SoPn IN ('N001', 'N002', 'N003', 'N004');
--
INSERT INTO PXUAT (SoPx, NgayXuat, TenKh) VALUES
('X001', '2012-01-17', 'Nguyễn Ngọc Phương Nhi'),
('X002', '2012-01-25', 'Nguyễn Hồng Phương'),
('X003', '2012-01-31', 'Nguyễn Tuấn Tú');
--
INSERT INTO CTPXUAT (SoPx, MaVTu, SlXuat, DgXuat) VALUES
('X001', 'DD01', 2, 3500000),
('X002', 'DD01', 1, 3500000),
('X002', 'DD02', 5, 4900000),
('X003', 'DD01', 3, 3500000),
('X003', 'DD02', 2, 4900000),
('X003', 'VD02', 10, 3250000);
--

--Bảng tồn kho
INSERT INTO TONKHO (NamThang, MaVTu, SlDau, TongSLN, TongSLX) VALUES
('201201', 'DD01', 1, 10, 6),
('201201', 'DD02', 1, 15, 7),
('201201', 'VD02', 1, 30, 10),
('201202', 'DD01', 4, 1, 1),
('201202', 'DD02', 8, 1, 1),
('201202', 'VD02', 20, 1, 1),
('201202', 'TV14', 5, 1, 1),
('201202', 'TV29', 12, 1, 1);

