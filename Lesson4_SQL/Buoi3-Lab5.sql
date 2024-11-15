--Lab 05
use [QLSINHVIEN];
go
--1,
SELECT HoSV, TenSV, MaKH, NoiSinh, HocBong
FROM SinhVien
WHERE HocBong > 10000 AND NoiSinh = N'Tp. HCM';
--2,
-- cách 1
SELECT MaSV, sv.MaKH, Phai
FROM SinhVien as sv
join Khoa as k on sv.MaKH = k.MaKH
where k.TenKH = N'Anh văn' OR k.TenKH = N'Triết'
-- cách 2
SELECT MaSV, MaKH, Phai
FROM SinhVien
WHERE MaKH IN (SELECT MaKH FROM Khoa WHERE TenKH = N'Anh văn' OR TenKH = N'Triết');
--3,
SELECT MaSV, NgaySinh, NoiSinh, HocBong
FROM SinhVien
WHERE NgaySinh BETWEEN '19860101' AND '19920605';
--4,
SELECT MaSV, NgaySinh, Phai, MaKH
FROM SinhVien
WHERE HocBong BETWEEN 20000 AND 800000;
--5,
SELECT MaMH, TenMH, Sotiet
FROM MonHoc
WHERE Sotiet > 40 AND Sotiet < 60;
--6,
SELECT MaSV, HoSV, TenSV, Phai
FROM SinhVien
WHERE Phai = '0' AND MaKH = (SELECT MaKH FROM Khoa WHERE TenKH = N'Anh văn');
--7,
SELECT HoSV, TenSV, NoiSinh, NgaySinh
FROM SinhVien
WHERE NoiSinh = N'Hà Nội' AND NgaySinh > '19900101';
--8,
SELECT * FROM SinhVien as sv
where TenSV like N'%N%' AND Phai = '1'
--9,
SELECT MaSV, HoSV, TenSV, NgaySinh
FROM SinhVien
WHERE Phai = '0' AND MaKH = (SELECT MaKH FROM Khoa WHERE TenKH = N'Tin Học') AND NgaySinh > '19860530';
--10,
SELECT HoSV, TenSV , CASE WHEN Phai = 0 THEN N'Nam' ELSE N'Nữ' END AS GioiTinh,NgaySinh
FROM SinhVien;
--11,
SELECT MaSV,YEAR(GETDATE()) - YEAR(NgaySinh) AS Tuoi,NoiSinh,MaKH
FROM SinhVien;
--12,
SELECT HoSV, TenSV,DATEDIFF(YEAR, NgaySinh, GETDATE()) AS Tuoi,Khoa.TenKH
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) BETWEEN 20 AND 30;
--13,
SELECT MaSV,
       CASE WHEN Phai = 0 THEN N'Nam' ELSE N'Nữ' END AS GioiTinh,
       MaKH,
       CASE WHEN HocBong > 500000 THEN N'Học bổng cao' ELSE N'Mức trung bình' END AS MucHocBong
FROM SinhVien;
--14,
SELECT HoSV, TenSV,
       CASE WHEN Phai = 0 THEN N'Nam' ELSE N'Nữ' END AS GioiTinh,
       Khoa.TenKH
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE Khoa.TenKH = N'Anh văn';
--15,
SELECT Khoa.TenKH,SinhVien.HoSV, SinhVien.TenSV,MonHoc.TenMH,MonHoc.SoTiet,KetQua.Diem
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
JOIN KetQua ON SinhVien.MaSV = KetQua.MaSV
JOIN MonHoc ON KetQua.MaMH = MonHoc.MaMH
WHERE Khoa.TenKH = N'Tin Học';
--16,
SELECT SinhVien.HoSV, SinhVien.TenSV,SinhVien.MaKH,MonHoc.TenMH,KetQua.Diem,
       CASE 
           WHEN KetQua.Diem > 8 THEN N'Giỏi'
           WHEN KetQua.Diem >= 6 THEN N'Khá'
           ELSE N'Trung Bình'
       END AS Loai
FROM SinhVien
JOIN KetQua ON SinhVien.MaSV = KetQua.MaSV
JOIN MonHoc ON KetQua.MaMH = MonHoc.MaMH;
--17,
SELECT Khoa.MaKH, Khoa.TenKH, MAX(SinhVien.HocBong) AS HocBongCaoNhat
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
GROUP BY Khoa.MaKH, Khoa.TenKH;
--18,
SELECT MonHoc.MaMH, MonHoc.TenMH, COUNT(Ketqua.MaSV) AS SoSinhVienDangHoc
FROM MonHoc
JOIN Ketqua ON MonHoc.MaMH = Ketqua.MaMH
GROUP BY MonHoc.MaMH, MonHoc.TenMH;

--19
SELECT MonHoc.TenMH, MonHoc.SoTiet, SinhVien.TenSV, Ketqua.Diem
FROM Ketqua
JOIN MonHoc ON Ketqua.MaMH = MonHoc.MaMH
JOIN SinhVien ON Ketqua.MaSV = SinhVien.MaSV
WHERE Ketqua.Diem = (SELECT MAX(Diem) FROM Ketqua);

--20
SELECT TOP 1 Khoa.MaKH, Khoa.TenKH, COUNT(SinhVien.MaSV) AS TongSoSinhVien
FROM Khoa
JOIN SinhVien ON Khoa.MaKH = SinhVien.MaKH
GROUP BY Khoa.MaKH, Khoa.TenKH
ORDER BY TongSoSinhVien DESC;

--21
SELECT Khoa.TenKH, SinhVien.HoSV, SinhVien.TenSV, SinhVien.HocBong
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE SinhVien.HocBong = (SELECT MAX(HocBong) FROM SinhVien);

--22
SELECT TOP 1 SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, SinhVien.HocBong
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE Khoa.TenKH = N'Tin học'
ORDER BY SinhVien.HocBong DESC;

--23
SELECT TOP 1 SinhVien.HoSV, SinhVien.TenSV, Ketqua.Diem
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
JOIN MonHoc ON Ketqua.MaMH = MonHoc.MaMH
WHERE MonHoc.TenMH = N'Cơ sở dữ liệu'
ORDER BY Ketqua.Diem DESC;

--24
SELECT TOP 3 SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, MonHoc.TenMH, Ketqua.Diem
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
JOIN MonHoc ON Ketqua.MaMH = MonHoc.MaMH
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE MonHoc.TenMH = N'Đồ họa'
ORDER BY Ketqua.Diem ASC;

--25
SELECT TOP 1 Khoa.MaKH, Khoa.TenKH, COUNT(SinhVien.MaSV) AS TongSoSinhVienNu
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
WHERE SinhVien.Phai = '1'
GROUP BY Khoa.MaKH, Khoa.TenKH
ORDER BY TongSoSinhVienNu DESC;


--26. Thống kê sinh viên theo khoa, gồm các thông tin: Mã khoa, Tên khoa, Tổng số sinh viên, Tổng số sinh viên nữ
SELECT Khoa.MaKH, Khoa.TenKH, COUNT(SinhVien.MaSV) AS TongSoSinhVien,
SUM(CASE WHEN SinhVien.Phai = N'Nữ' THEN 1 ELSE 0 END) AS TongSoSinhVienNu
FROM SinhVien
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
GROUP BY Khoa.MaKH, Khoa.TenKH;

--27. Cho biết kết quả học tập của sinh viên, gồm Họ tên sinh viên, Tên khoa, Kết quả
SELECT SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH,
CASE WHEN MIN(Ketqua.Diem) >= 4 THEN N'Đậu' ELSE N'Rớt' END AS KetQua
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
GROUP BY SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH;

--28. Danh sách những sinh viên không có môn nào nhỏ hơn 4 điểm, gồm các thông tin: Họ tên sinh viên, Tên khoa, Phái
SELECT SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, SinhVien.Phai
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
GROUP BY SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, SinhVien.Phai
HAVING MIN(Ketqua.Diem) >= 4;

--29. Cho biết danh sách những môn không có điểm thi nhỏ hơn 4, gồm các thông tin: Mã môn, Tên Môn
SELECT MonHoc.MaMH, MonHoc.TenMH
FROM MonHoc
JOIN Ketqua ON MonHoc.MaMH = Ketqua.MaMH
GROUP BY MonHoc.MaMH, MonHoc.TenMH
HAVING MIN(Ketqua.Diem) >= 4;

--30. Cho biết những khoa không có sinh viên rớt, sinh viên rớt nếu điểm thi của môn nhỏ hơn 5, gồm các thông tin: Mã khoa, Tên khoa
SELECT Khoa.MaKH, Khoa.TenKH
FROM Khoa
JOIN SinhVien ON Khoa.MaKH = SinhVien.MaKH
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
GROUP BY Khoa.MaKH, Khoa.TenKH
HAVING MIN(Ketqua.Diem) >= 5;

--31. Thống kê số sinh viên đậu và số sinh viên rớt của từng môn, biết rằng sinh viên rớt khi điểm của môn nhỏ hơn 5
SELECT MonHoc.MaMH, MonHoc.TenMH,
SUM(CASE WHEN Ketqua.Diem >= 5 THEN 1 ELSE 0 END) AS SoSinhVienDau,
SUM(CASE WHEN Ketqua.Diem < 5 THEN 1 ELSE 0 END) AS SoSinhVienRot
FROM MonHoc
JOIN Ketqua ON MonHoc.MaMH = Ketqua.MaMH
GROUP BY MonHoc.MaMH, MonHoc.TenMH;

--32. Cho biết môn nào không có sinh viên rớt, gồm có: Mã môn, Tên môn
SELECT MonHoc.MaMH, MonHoc.TenMH
FROM MonHoc
JOIN Ketqua ON MonHoc.MaMH = Ketqua.MaMH
GROUP BY MonHoc.MaMH, MonHoc.TenMH
HAVING MIN(Ketqua.Diem) >= 5;

--33. Danh sách sinh viên không có môn nào rớt, thông tin gồm: Mã sinh viên, Họ tên, Mã khoa
SELECT SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, SinhVien.MaKH
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
GROUP BY SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, SinhVien.MaKH
HAVING MIN(Ketqua.Diem) >= 5;

--34. Danh sách các sinh viên rớt trên 2 môn, gồm Mã sinh viên, Họ sinh viên, Tên sinh viên, Mã khoa
SELECT SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, SinhVien.MaKH
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
WHERE Ketqua.Diem < 5
GROUP BY SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, SinhVien.MaKH
HAVING COUNT(*) > 2;

--35. Cho biết danh sách những khoa có nhiều hơn 10 sinh viên, gồm Mã khoa, Tên khoa, Tổng số sinh viên của khoa
SELECT Khoa.MaKH, Khoa.TenKH, COUNT(SinhVien.MaSV) AS TongSoSinhVien
FROM Khoa
JOIN SinhVien ON Khoa.MaKH = SinhVien.MaKH
GROUP BY Khoa.MaKH, Khoa.TenKH
HAVING COUNT(SinhVien.MaSV) > 10;

--36. Danh sách những sinh viên thi nhiều hơn 4 môn, gồm có Mã sinh viên, Họ tên sinh viên, Số môn thi
SELECT SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV, COUNT(Ketqua.MaMH) AS SoMonThi
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
GROUP BY SinhVien.MaSV, SinhVien.HoSV, SinhVien.TenSV
HAVING COUNT(Ketqua.MaMH) > 4;

--37. Cho biết khoa có 5 sinh viên nam trở lên, thông tin gồm có: Mã khoa, Tên khoa, Tổng số sinh viên nam
SELECT Khoa.MaKH, Khoa.TenKH, COUNT(SinhVien.MaSV) AS TongSoSinhVienNam
FROM Khoa
JOIN SinhVien ON Khoa.MaKH = SinhVien.MaKH
WHERE SinhVien.Phai = '0'
GROUP BY Khoa.MaKH, Khoa.TenKH
HAVING COUNT(SinhVien.MaSV) >= 2;

--38. Danh sách những sinh viên có trung bình điểm thi lớn hơn 4, gồm các thông tin sau: Họ tên sinh viên, Tên khoa, Phái, Điểm trung bình các môn
SELECT SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, SinhVien.Phai, AVG(Ketqua.Diem) AS DiemTrungBinh
FROM SinhVien
JOIN Ketqua ON SinhVien.MaSV = Ketqua.MaSV
JOIN Khoa ON SinhVien.MaKH = Khoa.MaKH
GROUP BY SinhVien.HoSV, SinhVien.TenSV, Khoa.TenKH, SinhVien.Phai
HAVING AVG(Ketqua.Diem) > 4;

--39. Cho biết trung bình điểm thi của từng môn, chỉ lấy môn nào có trung bình điểm thi lớn hơn 6
SELECT MonHoc.MaMH, MonHoc.TenMH, AVG(Ketqua.Diem) AS TrungBinhDiem
FROM MonHoc
JOIN Ketqua ON MonHoc.MaMH = Ketqua.MaMH
GROUP BY MonHoc.MaMH, MonHoc.TenMH
HAVING AVG(Ketqua.Diem) > 6;


