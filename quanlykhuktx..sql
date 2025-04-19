create database QUANLYKTX
use QUANLYKTX

--drop database QUANLYKTX

-- Bảng phòng 
CREATE TABLE Phong (
    ma_phong INT PRIMARY KEY IDENTITY(1,1),
    so_phong NVARCHAR(10) UNIQUE NOT NULL,
    suc_chua INT NOT NULL,
    so_nguoi_hien_tai INT DEFAULT 0,
    gia DECIMAL(10,2) NOT NULL
);

-- Bảng sinh viên 
CREATE TABLE SinhVien (
    ma_sinh_vien INT PRIMARY KEY IDENTITY(1,1),
    ho_ten NVARCHAR(100) NOT NULL,
    gioi_tinh NVARCHAR(10) CHECK (gioi_tinh IN (N'Nam', N'Nữ', N'Khác')),
    ngay_sinh DATE NOT NULL,
    dien_thoai NVARCHAR(15) UNIQUE,
    email NVARCHAR(100) UNIQUE,
    ma_phong INT NULL,
    FOREIGN KEY (ma_phong) REFERENCES Phong(ma_phong) ON DELETE SET NULL
);

-- Bảng dịch vụ 
CREATE TABLE DichVu (
    ma_dich_vu INT PRIMARY KEY IDENTITY(1,1),
    ten_dich_vu NVARCHAR(100) UNIQUE NOT NULL,
    mo_ta NVARCHAR(MAX),
    gia DECIMAL(10,2) NOT NULL
);

-- Bảng đăng kí dịch vụ 
CREATE TABLE DangKyDichVu (
    ma_dang_ky INT PRIMARY KEY IDENTITY(1,1),
    ma_sinh_vien INT FOREIGN KEY REFERENCES SinhVien(ma_sinh_vien) ON DELETE CASCADE,
    ma_dich_vu INT FOREIGN KEY REFERENCES DichVu(ma_dich_vu) ON DELETE CASCADE,
    ngay_dang_ky DATE DEFAULT GETDATE(),
    trang_thai NVARCHAR(20) CHECK (trang_thai IN (N'Đang sử dụng', N'Hủy')) DEFAULT N'Đang sử dụng'
);

-- Bảng hóa đơn 
CREATE TABLE HoaDon (
    ma_hoa_don INT PRIMARY KEY IDENTITY(1,1),
    ma_sinh_vien INT FOREIGN KEY REFERENCES SinhVien(ma_sinh_vien) ON DELETE CASCADE,
    tong_so_tien DECIMAL(10,2) NOT NULL,
    trang_thai_thanh_toan NVARCHAR(20) CHECK (trang_thai_thanh_toan IN (N'Chưa thanh toán', N'Đã thanh toán')) DEFAULT N'Chưa thanh toán',
    ngay_tao DATETIME DEFAULT GETDATE()
);

-- Bảng chi tiết hóa đơn 
CREATE TABLE ChiTietHoaDon (
    ma_chi_tiet INT PRIMARY KEY IDENTITY(1,1),
    ma_hoa_don INT FOREIGN KEY REFERENCES HoaDon(ma_hoa_don) ON DELETE CASCADE,
    ma_dich_vu INT FOREIGN KEY REFERENCES DichVu(ma_dich_vu) ON DELETE CASCADE,
    so_luong DECIMAL(10,2) NOT NULL
);

-- Bảng khiếu nại 
CREATE TABLE KhieuNai (
    ma_khieu_nai INT PRIMARY KEY IDENTITY(1,1),
    ma_sinh_vien INT FOREIGN KEY REFERENCES SinhVien(ma_sinh_vien) ON DELETE CASCADE,
    noi_dung_khieu_nai NVARCHAR(MAX) NOT NULL,
    trang_thai NVARCHAR(20) CHECK (trang_thai IN (N'Chưa giải quyết', N'Đang xử lý', N'Đã giải quyết')) DEFAULT N'Chưa giải quyết',
    ngay_tao DATETIME DEFAULT GETDATE()
);

--Bảng thuê trả phòng 
CREATE TABLE THUETRAPHONG (
    ma_phong INT,
    so_phong NVARCHAR(10),
    khoang_thoi_gian NVARCHAR(50),
    tinh_tu_ngay DATE,
    ma_sinh_vien INT,
    gioi_tinh NVARCHAR(5),
    CONSTRAINT PK_ThueTraPhong PRIMARY KEY (ma_phong),
    CONSTRAINT FK_ThueTraPhong_Phong FOREIGN KEY (ma_phong) REFERENCES Phong(ma_phong),
    CONSTRAINT FK_ThueTraPhong_SinhVien FOREIGN KEY (ma_sinh_vien) REFERENCES SinhVien(ma_sinh_vien)
);
ALTER TABLE THUETRAPHONG DROP CONSTRAINT PK_ThueTraPhong;
ALTER TABLE THUETRAPHONG
ALTER COLUMN ma_phong INT NOT NULL;

ALTER TABLE THUETRAPHONG
ALTER COLUMN ma_sinh_vien INT NOT NULL;

ALTER TABLE THUETRAPHONG
ADD CONSTRAINT PK_ThueTraPhong PRIMARY KEY (ma_phong, ma_sinh_vien);

INSERT INTO THUETRAPHONG (ma_phong, so_phong, khoang_thoi_gian, tinh_tu_ngay, ma_sinh_vien, gioi_tinh)
SELECT
    p.ma_phong,
    p.so_phong,
    N'T1/2024',               -- Khoảng thời gian thuê mặc định
    GETDATE(),                -- Ngày hiện tại
    sv.ma_sinh_vien,
    sv.gioi_tinh
FROM
    SinhVien sv
JOIN
    Phong p ON sv.ma_phong = p.ma_phong
WHERE
    p.so_nguoi_hien_tai < p.suc_chua
    AND sv.ma_phong IS NOT NULL
    AND (
        NOT EXISTS (
            SELECT 1
            FROM THUETRAPHONG ttp
            WHERE ttp.ma_phong = p.ma_phong
                  AND ttp.gioi_tinh <> sv.gioi_tinh
        )
    );



	INSERT INTO Phong (so_phong, suc_chua, so_nguoi_hien_tai, gia) VALUES
	('A101', 4, 3, 1500000),
	('A102', 4, 2, 1500000),
	('B201', 6, 5, 1200000),
	('B202', 6, 4, 1200000),
	('C301', 8, 6, 1000000),
	('C302', 8, 7, 1000000),
	('D401', 10, 9, 800000),
	('D402', 10, 10, 800000),
	('E501', 12, 10, 600000),
	('E502', 12, 12, 600000);


ALTER TABLE Phong
ADD gioi_tinh NVARCHAR(13) NOT NULL DEFAULT N'Chưa xác định';

-- Giả sử các mã phòng từ 1 đến 5 dành cho Nam
UPDATE Phong
SET gioi_tinh = N'Nam'
WHERE ma_phong BETWEEN 1 AND 5;

-- Giả sử các mã phòng từ 6 đến 10 dành cho Nữ
UPDATE Phong
SET gioi_tinh = N'Nữ'
WHERE ma_phong BETWEEN 6 AND 10;




	INSERT INTO SinhVien (ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email, ma_phong) VALUES
(N'Nguyễn Văn A', N'Nam', '2002-05-10', '0901234001', 'nguyenvana@gmail.com', 1),
(N'Trần Thị B', N'Nữ', '2001-08-15', '0901234002', 'tranthib@gmail.com', 1),
(N'Lê Hoàng C', N'Nam', '2003-02-20', '0901234003', 'lehoangc@gmail.com', 2),
(N'Phạm Minh D', N'Nam', '2002-11-30', '0901234004', 'phamminhd@gmail.com', 2),
(N'Võ Thị E', N'Nữ', '2001-06-25', '0901234005', 'vothie@gmail.com', 3),
(N'Bùi Thanh F', N'Nam', '2002-09-14', '0901234006', 'buithanhf@gmail.com', 3),
(N'Đinh Hồng G', N'Nữ', '2003-03-08', '0901234007', 'dinhhongg@gmail.com', 4),
(N'Ngô Quang H', N'Nam', '2002-12-01', '0901234008', 'ngoquangh@gmail.com', 4),
(N'Hoàng Mai I', N'Nữ', '2001-07-21', '0901234009', 'hoangmaii@gmail.com', 5),
(N'Phan Quốc J', N'Nam', '2003-01-18', '0901234010', 'phanquocj@gmail.com', 5),
(N'Đặng Văn K', N'Nam', '2002-04-27', '0901234011', 'dangvank@gmail.com', 6),
(N'Nguyễn Thị L', N'Nữ', '2001-10-30', '0901234012', 'nguyenthil@gmail.com', 6),
(N'Vũ Minh M', N'Nam', '2003-06-12', '0901234013', 'vuminhm@gmail.com', 7),
(N'Lý Phương N', N'Nữ', '2002-05-15', '0901234014', 'lyphuongn@gmail.com', 7),
(N'Trịnh Công O', N'Nam', '2001-08-22', '0901234015', 'trinhcongo@gmail.com', 8),
(N'Đoàn Thu P', N'Nữ', '2002-02-05', '0901234016', 'doanthup@gmail.com', 8),
(N'Châu Hải Q', N'Nam', '2003-09-17', '0901234017', 'chauhaiq@gmail.com', 9),
(N'Tô Lan R', N'Nữ', '2001-11-29', '0901234018', 'tolanr@gmail.com', 9),
(N'Hồ Văn S', N'Nam', '2002-07-04', '0901234019', 'hovans@gmail.com', 10),
(N'Tạ Bích T', N'Nữ', '2003-12-10', '0901234020', 'tabicht@gmail.com', 10);


UPDATE SinhVien
SET ma_phong = 
    CASE 
        WHEN ma_sinh_vien = 2 THEN 6
        WHEN ma_sinh_vien = 5 THEN 7
        WHEN ma_sinh_vien = 7 THEN 8
        WHEN ma_sinh_vien = 9 THEN 9
    END
WHERE ma_sinh_vien IN (2, 5, 7, 9);

UPDATE SinhVien
SET ma_phong = 
    CASE 
        WHEN ma_sinh_vien = 11 THEN 1
        WHEN ma_sinh_vien = 13 THEN 2
        WHEN ma_sinh_vien = 15 THEN 3
        WHEN ma_sinh_vien = 17 THEN 4
        WHEN ma_sinh_vien = 19 THEN 5
    END
WHERE ma_sinh_vien IN (11, 13, 15, 17, 19);


SELECT sv.*
FROM SinhVien sv
JOIN Phong p ON sv.ma_phong = p.ma_phong
WHERE sv.gioi_tinh <> p.gioi_tinh;

--Khi sinh viên chuyển ra, cập nhật trạng thái
ALTER TABLE SinhVien ADD trang_thai NVARCHAR(20) NOT NULL DEFAULT N'Đang ở';

UPDATE SinhVien 
SET trang_thai = N'Đã chuyển đi' 
WHERE ma_sinh_vien = 5;

--Theo dõi số lượng sinh viên trong từng phòng
SELECT COUNT(*) AS so_luong_sinh_vien_con_lai
FROM SinhVien
WHERE trang_thai = N'Đang ở';

--Theo dõi số lượng sinh viên trong từng phòng
SELECT ma_phong, COUNT(*) AS so_sinh_vien
FROM SinhVien
WHERE trang_thai = N'Đang ở'
GROUP BY ma_phong;





INSERT INTO DichVu (ten_dich_vu, mo_ta, gia) VALUES
(N'Giặt ủi', N'Dịch vụ giặt ủi quần áo hàng ngày', 200000),
(N'Internet', N'Wi-Fi tốc độ cao', 100000),
(N'Ve sinh', N'Dịch vụ vệ sinh phòng hàng tuần', 50000),
(N'Gửi xe', N'Giữ xe máy/tháng', 150000),
(N'Điện', N'Chi phí điện nước hàng tháng', 300000),
(N'Nước uống', N'Cung cấp nước uống hàng tháng', 70000);


INSERT INTO DangKyDichVu (ma_sinh_vien, ma_dich_vu, ngay_dang_ky, trang_thai) VALUES
(4, 1, '2025-04-01', N'Đang sử dụng'),
(5, 2, '2025-04-02', N'Đang sử dụng'),
(6, 3, '2025-04-03', N'Đang sử dụng'),
(7, 4, '2025-04-04', N'Hủy'),
(8, 5, '2025-04-05', N'Đang sử dụng'),
(9, 6, '2025-04-06', N'Hủy');

INSERT INTO HoaDon (ma_sinh_vien, tong_so_tien, trang_thai_thanh_toan, ngay_tao) VALUES
(7, 200000, N'Chưa thanh toán', GETDATE()),
(8, 100000, N'Đã thanh toán', GETDATE()),
(9, 50000, N'Chưa thanh toán', GETDATE()),
(10, 150000, N'Đã thanh toán', GETDATE()),
(11, 300000, N'Chưa thanh toán', GETDATE());



INSERT INTO ChiTietHoaDon (ma_hoa_don, ma_dich_vu, so_tien, so_luong) VALUES
(3, 1, 200000, 1),
(4, 2, 100000, 1),
(5, 3, 50000, 1),
(4, 4, 150000, 1),
(5, 5, 300000, 1);


INSERT INTO KhieuNai (ma_sinh_vien, noi_dung_khieu_nai, trang_thai, ngay_tao) VALUES
(4, N'Wi-Fi chậm, hay bị mất kết nối.', N'Chưa giải quyết', GETDATE()),
(5, N'Nhà vệ sinh bẩn, cần dọn dẹp thường xuyên hơn.', N'Đang xử lý', GETDATE()),
(6, N'Máy giặt bị hỏng, không sử dụng được.', N'Đã giải quyết', GETDATE()),
(7, N'Nhân viên bảo vệ không kiểm soát xe ra vào.', N'Chưa giải quyết', GETDATE()),
(8, N'Nước uống có mùi lạ.', N'Đang xử lý', GETDATE());


select * from THUETRAPHONG
select * from Phong
select * from SinhVien
select * from HoaDon
select * from ChiTietHoaDon
select * from DichVu
select * from DangKyDichVu
select * from KhieuNai

-- Cập nhật số lượng sinh viên hiện tại khi có sự thay đổi
CREATE TRIGGER trg_CapNhatSoLuongSinhVien
ON SinhVien
AFTER UPDATE
AS
BEGIN
    DECLARE @ma_phong INT;
    DECLARE @ma_phong_moi INT;
    
    -- Kiểm tra nếu có sự thay đổi về ma_phong
    IF UPDATE(ma_phong)
    BEGIN
        -- Lấy ma_phong trước khi cập nhật
        SELECT @ma_phong = ma_phong FROM deleted;
        
        -- Lấy ma_phong sau khi cập nhật
        SELECT @ma_phong_moi = ma_phong FROM inserted;

        -- Kiểm tra nếu phòng cũ và mới khác nhau mới cập nhật
        IF @ma_phong IS NOT NULL AND @ma_phong_moi IS NOT NULL AND @ma_phong <> @ma_phong_moi
        BEGIN
            -- Cập nhật số lượng sinh viên trong phòng cũ
            UPDATE Phong
            SET so_nguoi_hien_tai = (SELECT COUNT(*) FROM SinhVien WHERE ma_phong = @ma_phong)
            WHERE ma_phong = @ma_phong;

            -- Cập nhật số lượng sinh viên trong phòng mới
            UPDATE Phong
            SET so_nguoi_hien_tai = (SELECT COUNT(*) FROM SinhVien WHERE ma_phong = @ma_phong_moi)
            WHERE ma_phong = @ma_phong_moi;
        END
    END
END;

-- Thêm một sinh viên vào cơ sở dữ liệu với các thông tin cần thiết
CREATE PROCEDURE ThemSinhVien
    @ho_ten NVARCHAR(100),
    @gioi_tinh NVARCHAR(10),
    @ngay_sinh DATE,
    @dien_thoai NVARCHAR(15),
    @email NVARCHAR(100),
    @ma_phong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SinhVien (ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email, ma_phong)
    VALUES (@ho_ten, @gioi_tinh, @ngay_sinh, @dien_thoai, @email, @ma_phong);
END;

IF OBJECT_ID('CapNhatSinhVien', 'P') IS NOT NULL
    DROP PROCEDURE CapNhatSinhVien;
GO

-- Cập nhật thông tin sinh viên
CREATE PROCEDURE CapNhatSinhVien
    @ma_sinh_vien INT,
    @ho_ten NVARCHAR(100),
    @gioi_tinh NVARCHAR(10),
    @ngay_sinh DATE,
    @dien_thoai NVARCHAR(15),
    @email NVARCHAR(100),
    @ma_phong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SinhVien
    SET ho_ten = @ho_ten,
        gioi_tinh = @gioi_tinh,
        ngay_sinh = @ngay_sinh,
        dien_thoai = @dien_thoai,
        email = @email,
        ma_phong = @ma_phong
    WHERE ma_sinh_vien = @ma_sinh_vien;
END;
GO

-- Xóa sinh viên
IF OBJECT_ID('XoaSinhVien', 'P') IS NOT NULL
    DROP PROCEDURE XoaSinhVien;
GO

CREATE PROCEDURE XoaSinhVien
    @ma_sinh_vien INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM SinhVien WHERE ma_sinh_vien = @ma_sinh_vien;
END;
GO

-- Xem danh sách sinh viên
IF OBJECT_ID('XemDanhSachSinhVien', 'P') IS NOT NULL
    DROP PROCEDURE XemDanhSachSinhVien;
GO

CREATE PROCEDURE XemDanhSachSinhVien
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ma_sinh_vien, ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email, ma_phong
    FROM SinhVien;
END;
GO

-- Thêm dịch vụ mới
IF OBJECT_ID('ThemDichVu', 'P') IS NOT NULL
    DROP PROCEDURE ThemDichVu;
GO

CREATE PROCEDURE ThemDichVu
    @ten_dich_vu NVARCHAR(100),
    @mo_ta NVARCHAR(MAX),
    @gia DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO DichVu (ten_dich_vu, mo_ta, gia)
    VALUES (@ten_dich_vu, @mo_ta, @gia);
END;
GO

-- Cập nhật dịch vụ
IF OBJECT_ID('CapNhatDichVu', 'P') IS NOT NULL
    DROP PROCEDURE CapNhatDichVu;
GO

CREATE PROCEDURE CapNhatDichVu
    @ma_dich_vu INT,
    @ten_dich_vu NVARCHAR(100),
    @mo_ta NVARCHAR(MAX),
    @gia DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Services
    SET service_name = @ten_dich_vu,
        description = @mo_ta,
        price = @gia
    WHERE service_id = @ma_dich_vu;
END;
GO

-- Xóa dịch vụ
IF OBJECT_ID('XoaDichVu', 'P') IS NOT NULL
    DROP PROCEDURE XoaDichVu;
GO

CREATE PROCEDURE XoaDichVu
    @ma_dich_vu INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Services WHERE service_id = @ma_dich_vu;
END;
GO

-- Xem danh sách dịch vụ
IF OBJECT_ID('XemDanhSachDichVu', 'P') IS NOT NULL
    DROP PROCEDURE XemDanhSachDichVu;
GO

CREATE PROCEDURE XemDanhSachDichVu
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Services;
END;
GO

-- Sinh viên đăng ký dịch vụ
IF OBJECT_ID('SinhVienDangKyDichVu', 'P') IS NOT NULL
    DROP PROCEDURE SinhVienDangKyDichVu;
GO

CREATE PROCEDURE SinhVienDangKyDichVu
    @ma_sinh_vien INT,
    @ma_dich_vu INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Service_Registrations (student_id, service_id, register_date, status)
    VALUES (@ma_sinh_vien, @ma_dich_vu, GETDATE(), N'Đang sử dụng');
END;
GO

-- Hủy đăng ký dịch vụ
IF OBJECT_ID('HuyDangKyDichVu', 'P') IS NOT NULL
    DROP PROCEDURE HuyDangKyDichVu;
GO

CREATE PROCEDURE HuyDangKyDichVu
    @ma_dang_ky INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Service_Registrations
    SET status = N'Hủy'
    WHERE registration_id = @ma_dang_ky;
END;
GO



-- Xem danh sách dịch vụ của sinh viên
CREATE PROCEDURE XemDanhSachDichVuCuaSinhVien
    @ma_sinh_vien INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT sr.ma_dang_ky, s.ten_dich_vu, s.mo_ta, s.gia, sr.ngay_dang_ky, sr.trang_thai
    FROM DangKyDichVu sr
    JOIN DichVu s ON sr.ma_dich_vu = s.ma_dich_vu
    WHERE sr.ma_sinh_vien = @ma_sinh_vien;
END;


-- Cập nhật trạng thái dịch vụ của sinh viên khi có thay đổi
CREATE TRIGGER trg_CapNhatTrangThaiDichVu
ON DangKyDichVu
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE trang_thai = N'Hủy')
    BEGIN
        PRINT N'Dịch vụ của sinh viên đã bị hủy';
    END
END;

-- Tạo hóa đơn mới
CREATE PROCEDURE TaoHoaDon
    @ma_sinh_vien INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra sinh viên có dịch vụ nào chưa thanh toán không
    IF NOT EXISTS (SELECT 1 FROM Service_Registrations WHERE student_id = @ma_sinh_vien AND status = N'Đang sử dụng')
    BEGIN
        PRINT N'Sinh viên không có dịch vụ nào để tạo hóa đơn.';
        RETURN;
    END

    -- Tính tổng tiền hóa đơn
    DECLARE @tong_tien DECIMAL(10,2);
    SET @tong_tien = (SELECT SUM(s.price)
                      FROM Service_Registrations sr
                      JOIN Services s ON sr.service_id = s.service_id
                      WHERE sr.student_id = @ma_sinh_vien AND sr.status = N'Đang sử dụng');

    -- Tạo hóa đơn mới
    DECLARE @hoa_don_id INT;
    INSERT INTO HoaDon(ma_sinh_vien, tong_so_tien, trang_thai_thanh_toan, ngay_tao)
    VALUES (@ma_sinh_vien, @tong_tien, N'Chưa thanh toán', GETDATE());

    SET @hoa_don_id = SCOPE_IDENTITY();
	declare @so_luong int;
	set @so_luong = (SELECT count(ma_dang_ky)
                      FROM DangKyDichVu sr
                      JOIN DichVu s ON sr.ma_dich_vu = s.ma_dich_vu
                      WHERE sr.ma_sinh_vien = @ma_sinh_vien AND sr.trang_thai = N'Đang sử dụng');

    -- Thêm chi tiết hóa đơn
    INSERT INTO ChiTietHoaDon(ma_hoa_don, ma_dich_vu, so_luong,so_tien)
    SELECT @hoa_don_id, s.ma_dich_vu, @so_luong,@tong_tien
    FROM DangKyDichVu sr
    JOIN DichVu s ON sr.ma_dich_vu = s.ma_dich_vu
    WHERE sr.ma_sinh_vien = @ma_sinh_vien AND sr.trang_thai = N'Đang sử dụng';

    PRINT N'Hóa đơn đã được tạo thành công.';
END;
exec TaoHoaDon 4
select * from ChiTietHoaDon

-- Xem danh sách hóa đơn của sinh viên
IF OBJECT_ID('XemDanhSachHoaDon', 'P') IS NOT NULL
    DROP PROCEDURE XemDanhSachHoaDon;
GO

CREATE PROCEDURE XemDanhSachHoaDon
    @ma_sinh_vien INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT invoice_id AS ma_hoa_don, 
           total_amount AS tong_tien, 
           payment_status AS trang_thai_thanh_toan, 
           created_at AS ngay_tao
    FROM Invoices
    WHERE student_id = @ma_sinh_vien;
END;
GO

-- Xem chi tiết một hóa đơn
IF OBJECT_ID('XemChiTietHoaDon', 'P') IS NOT NULL
    DROP PROCEDURE XemChiTietHoaDon;
GO

CREATE PROCEDURE XemChiTietHoaDon
    @ma_hoa_don INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id.detail_id AS ma_chi_tiet, 
           s.service_name AS ten_dich_vu, 
           id.amount AS so_tien
    FROM Invoice_Details id
    JOIN Services s ON id.service_id = s.service_id
    WHERE id.invoice_id = @ma_hoa_don;
END;
GO

-- Thanh toán hóa đơn
IF OBJECT_ID('ThanhToanHoaDon', 'P') IS NOT NULL
    DROP PROCEDURE ThanhToanHoaDon;
GO

CREATE PROCEDURE ThanhToanHoaDon
    @ma_hoa_don INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Invoices
    SET payment_status = N'Đã thanh toán'
    WHERE invoice_id = @ma_hoa_don;

    PRINT N'Hóa đơn đã được thanh toán.';
END;
GO

-- Tự động tạo hóa đơn hàng tháng
CREATE TRIGGER trg_TaoHoaDonTuDong
ON Service_Registrations
AFTER INSERT
AS
BEGIN
    DECLARE @ma_sinh_vien INT;
    SELECT @ma_sinh_vien = student_id FROM inserted;

    -- Gọi thủ tục tạo hóa đơn
    EXEC CreateInvoice @ma_sinh_vien;
END;

-- Xóa hóa đơn
CREATE PROCEDURE XoaHoaDon
    @invoice_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu hóa đơn đã thanh toán thì không thể xóa
    IF EXISTS (SELECT 1 FROM Invoices WHERE invoice_id = @invoice_id AND payment_status = N'Đã thanh toán')
    BEGIN
        PRINT N'Không thể xóa hóa đơn đã thanh toán.';
        RETURN;
    END;

    -- Xóa hóa đơn và chi tiết hóa đơn
    DELETE FROM Invoice_Details WHERE invoice_id = @invoice_id;
    DELETE FROM Invoices WHERE invoice_id = @invoice_id;

    PRINT N'Hóa đơn đã được xóa.';
END;


-- Thống kê tổng doanh thu
CREATE PROCEDURE ThongKeTongDoanhThu
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SUM(total_amount) AS Tong_Doanh_Thu
    FROM Invoices
    WHERE payment_status = N'Đã thanh toán';
END;
-- Gửi khiếu nại mới
CREATE PROCEDURE GuiKhieuNai
    @ma_sinh_vien INT,
    @noi_dung_khieu_nai NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO KhiuNai (ma_sinh_vien, noi_dung_khieu_nai, trang_thai, ngay_tao)
    VALUES (@ma_sinh_vien, @noi_dung_khieu_nai, N'Chưa giải quyết', GETDATE());

    PRINT N'Khiếu nại đã được gửi thành công.';
END;

-- Xem danh sách khiếu nại
CREATE PROCEDURE XemDanhSachKhieuNai
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.ma_khieu_nai, s.ho_ten, c.noi_dung_khieu_nai, c.trang_thai, c.ngay_tao
    FROM KhiuNai c
    JOIN SinhVien s ON c.ma_sinh_vien = s.ma_sinh_vien
    ORDER BY c.ngay_tao DESC;
END;

-- Xem khiếu nại của một sinh viên
CREATE PROCEDURE XemKhieuNaiCuaSinhVien
    @ma_sinh_vien INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ma_khieu_nai, noi_dung_khieu_nai, trang_thai, ngay_tao
    FROM KhiuNai
    WHERE ma_sinh_vien = @ma_sinh_vien
    ORDER BY ngay_tao DESC;
END;

-- Cập nhật trạng thái khiếu nại
CREATE PROCEDURE CapNhatTrangThaiKhieuNai
    @ma_khieu_nai INT,
    @trang_thai_moi NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra nếu trạng thái hợp lệ
    IF @trang_thai_moi NOT IN (N'Chưa giải quyết', N'Đang xử lý', N'Đã giải quyết')
    BEGIN
        PRINT N'Trạng thái không hợp lệ.';
        RETURN;
    END;

    UPDATE KhiuNai
    SET trang_thai = @trang_thai_moi
    WHERE ma_khieu_nai = @ma_khieu_nai;

    PRINT N'Trạng thái khiếu nại đã được cập nhật.';
END;

-- Xóa khiếu nại
CREATE PROCEDURE XoaKhieuNai
    @ma_khieu_nai INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM KhiuNai WHERE ma_khieu_nai = @ma_khieu_nai;

    PRINT N'Khiếu nại đã được xóa.';
END;

-- Thống kê khiếu nại theo trạng thái
CREATE PROCEDURE ThongKeKhieuNaiTheoTrangThai
AS
BEGIN
    SET NOCOUNT ON;
    SELECT status AS trang_thai, COUNT(*) AS tong_so_khieu_nai
    FROM KhiuNai
    GROUP BY status;
END;

EXEC CreateComplaint 1, N'Phòng bị rò rỉ nước.';
EXEC GetAllComplaints;
EXEC UpdateComplaintStatus 1, N'Đang xử lý';
EXEC DeleteComplaint 1;

EXEC GetAllStudents;

CREATE PROCEDURE XemDanhSachPhong
AS
BEGIN
    SELECT * FROM Phong
END

CREATE PROCEDURE XemDanhSachPhongTheoMa
    @ma_phong INT
AS
BEGIN
    SELECT * FROM Phong WHERE ma_phong = @ma_phong
END

CREATE PROCEDURE ThemPhong
    @so_phong NVARCHAR(10),
    @suc_chua INT,
    @so_nguoi_hien_tai INT,
    @gia DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Phong (so_phong, suc_chua, so_nguoi_hien_tai, gia)
    VALUES (@so_phong, @suc_chua, @so_nguoi_hien_tai, @gia)
END

CREATE PROCEDURE CapNhatPhong
    @ma_phong INT,
    @so_phong NVARCHAR(10),
    @suc_chua INT,
    @so_nguoi_hien_tai INT,
    @gia DECIMAL(10,2)
AS
BEGIN
    UPDATE Phong
    SET so_phong = @so_phong,
        suc_chua = @suc_chua,
        so_nguoi_hien_tai = @so_nguoi_hien_tai,
        gia = @gia
    WHERE ma_phong = @ma_phong
END

CREATE PROCEDURE XoaPhong
    @ma_phong INT
AS
BEGIN
    DELETE FROM Phong WHERE ma_phong = @ma_phong
END

CREATE VIEW v_DanhSachSinhVien AS
SELECT 
    ma_sinh_vien, ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email
FROM 
    SinhVien;

CREATE PROCEDURE TimKiemSinhVien
    @loai NVARCHAR(20),
    @giatri NVARCHAR(100)
AS
BEGIN
    IF @loai = 'ma'
        SELECT * FROM SinhVien WHERE ma_sinh_vien = @giatri
    ELSE IF @loai = 'ten'
        SELECT * FROM SinhVien WHERE ho_ten LIKE '%' + @giatri + '%'
END

CREATE TRIGGER trg_KiemTraEmailTrung
ON SinhVien
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SinhVien s INNER JOIN inserted i ON s.email = i.email)
    BEGIN
        RAISERROR('Email đã tồn tại.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    INSERT INTO SinhVien (ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email)
    SELECT ho_ten, gioi_tinh, ngay_sinh, dien_thoai, email FROM inserted
END

CREATE VIEW vw_DanhSachThueTraPhong AS
SELECT * FROM THUETRAPHONG;

CREATE PROCEDURE sp_ThemThuePhong
    @ma_phong NVARCHAR(10),
    @so_phong NVARCHAR(10),
    @khoang_thoi_gian NVARCHAR(100),
    @tinh_tu_ngay DATE,
    @ma_sinh_vien NVARCHAR(10),
    @gioi_tinh NVARCHAR(10)
AS
BEGIN
    INSERT INTO THUETRAPHONG (ma_phong, so_phong, khoang_thoi_gian, tinh_tu_ngay, ma_sinh_vien, gioi_tinh)
    VALUES (@ma_phong, @so_phong, @khoang_thoi_gian, @tinh_tu_ngay, @ma_sinh_vien, @gioi_tinh)
END;

CREATE PROCEDURE sp_CapNhatThuePhong
    @ma_phong NVARCHAR(10),
    @so_phong NVARCHAR(10),
    @khoang_thoi_gian NVARCHAR(100),
    @tinh_tu_ngay DATE,
    @ma_sinh_vien NVARCHAR(10),
    @gioi_tinh NVARCHAR(10)
AS
BEGIN
    UPDATE THUETRAPHONG 
    SET so_phong = @so_phong, 
        khoang_thoi_gian = @khoang_thoi_gian, 
        tinh_tu_ngay = @tinh_tu_ngay,
        gioi_tinh = @gioi_tinh
    WHERE ma_phong = @ma_phong AND ma_sinh_vien = @ma_sinh_vien
END;

CREATE PROCEDURE sp_XoaThuePhong
    @ma_phong NVARCHAR(10),
    @ma_sinh_vien NVARCHAR(10)
AS
BEGIN
    DELETE FROM THUETRAPHONG 
    WHERE ma_phong = @ma_phong AND ma_sinh_vien = @ma_sinh_vien
END;

CREATE PROCEDURE sp_TimKiemThuePhong
    @ma_phong NVARCHAR(10) = NULL,
    @so_phong NVARCHAR(10) = NULL
AS
BEGIN
    SELECT * FROM THUETRAPHONG
    WHERE (@ma_phong IS NULL OR ma_phong = @ma_phong)
      AND (@so_phong IS NULL OR so_phong = @so_phong)
END;
