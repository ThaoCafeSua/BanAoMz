create database BanAo05_MzShop
use BanAo05_MzShop

CREATE TABLE khach_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_va_ten NVARCHAR(255),
    ngay_sinh DATE,
    gioi_tinh NVARCHAR(10),
    email NVARCHAR(255),
    so_dien_thoai NVARCHAR(50),
    mat_khau NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE dia_chi (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    ten_nguoi_nhan NVARCHAR(255),
    dien_thoai_nguoi_nhan NVARCHAR(50),
    dia_chi_chi_tiet NVARCHAR(255),
    xa NVARCHAR(100),
    huyen NVARCHAR(100),
    tinh NVARCHAR(100),
    dia_chi_mac_dinh BIT,
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE xuat_xu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_xuat_xu NVARCHAR(255),
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE danh_muc (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_danh_muc NVARCHAR(255),
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE thuong_hieu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_thuong_hieu NVARCHAR(255),
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_xuat_xu INT FOREIGN KEY REFERENCES xuat_xu(id),
    id_danh_muc INT FOREIGN KEY REFERENCES danh_muc(id),
    id_thuong_hieu INT FOREIGN KEY REFERENCES thuong_hieu(id),
	ma_san_pham NVARCHAR(50),
    ten_san_pham NVARCHAR(255),
    url_anh NVARCHAR(255),
	so_luong_da_ban INT,
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);
CREATE TABLE mau_sac (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_mau_sac NVARCHAR(50),
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE size (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_size NVARCHAR(50),
	trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE san_pham_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_mau_sac INT FOREIGN KEY REFERENCES mau_sac(id),
    id_size INT FOREIGN KEY REFERENCES size(id),
    id_san_pham INT FOREIGN KEY REFERENCES san_pham(id),
    so_luong INT,
    ma_vach NVARCHAR(50),
    gia_ban DECIMAL(18, 2),
    trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE gio_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_san_pham_chi_tiet INT FOREIGN KEY REFERENCES san_pham_chi_tiet(id),
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    so_luong INT,
    nguoi_tao NVARCHAR(255),
    nguoi_sua NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE chuc_vu (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_chuc_vu NVARCHAR(50)
);

CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_chuc_vu INT FOREIGN KEY REFERENCES chuc_vu(id),
    ten_nhan_vien NVARCHAR(255),
    sdt NVARCHAR(50),
    dia_chi NVARCHAR(255),
    email NVARCHAR(255),
    ngay_sinh DATE,
    gioi_tinh NVARCHAR(10),
    mat_khau NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE phieu_giam_gia (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_phieu_giam_gia NVARCHAR(50),
    ten_phieu_giam_gia NVARCHAR(255),
    gia_tri_giam DECIMAL(18, 2),
    dieu_kien_ap_dung DECIMAL(18, 2),
    ngay_bat_dau DATETIME,
    ngay_ket_thuc DATETIME,
    so_luong INT,
    mo_ta NVARCHAR(255),
    trang_thai NVARCHAR(50),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE hoa_don (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_khach_hang INT FOREIGN KEY REFERENCES khach_hang(id),
    id_nhan_vien INT FOREIGN KEY REFERENCES nhan_vien(id),
    id_phieu_giam_gia INT FOREIGN KEY REFERENCES phieu_giam_gia(id),
	ma_hoa_don NVARCHAR(50),
    phuong_thuc_thanh_toan NVARCHAR(255),
    loai_hoa_don NVARCHAR(50),
    hinh_thuc_hoa_don NVARCHAR(50),
    tong_tien DECIMAL(18, 2),
	tien_giam DECIMAL(18, 2),
	phi_van_chuyen DECIMAL(18, 2),
	thanh_tien DECIMAL(18, 2),
	dia_chi_nguoi_nhan NVARCHAR(255),
    ngay_dat DATETIME,
    ngay_giao DATETIME,
    ngay_hoan_thanh DATETIME,
	ten_nguoi_nhan NVARCHAR(255),
    so_dien_thoai_nguoi_nhan NVARCHAR(20),
	trang_thai NVARCHAR(50),   
	mo_ta NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

CREATE TABLE hoa_don_chi_tiet (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don INT FOREIGN KEY REFERENCES hoa_don(id),
    id_san_pham_chi_tiet INT FOREIGN KEY REFERENCES san_pham_chi_tiet(id),
    gia_ban DECIMAL(18, 2),
    gia_goc DECIMAL(18, 2),
    gia_giam DECIMAL(18, 2),
    so_luong INT,
    mo_ta NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);
CREATE TABLE lich_su_thanh_toan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_hoa_don INT FOREIGN KEY REFERENCES hoa_don(id),
    ma_giao_dich NVARCHAR(50),
    loai_thanh_toan NVARCHAR(50),
    so_tien_thanh_toan DECIMAL(18, 2),
    mo_ta NVARCHAR(255),
    ngay_tao DATETIME,
    ngay_sua DATETIME
);

INSERT INTO khach_hang (ho_va_ten, ngay_sinh, gioi_tinh, email, so_dien_thoai, mat_khau, ngay_tao, ngay_sua)
VALUES 
(N'Trần Thị Thanh Thảo', '1995-03-15', N'Nữ', N'thao@gmail.com', '0987654321', N'123456', GETDATE(), GETDATE());

INSERT INTO dia_chi (id_khach_hang, ten_nguoi_nhan, dien_thoai_nguoi_nhan, dia_chi_chi_tiet, xa, huyen, tinh, dia_chi_mac_dinh,  ngay_tao, ngay_sua)
VALUES
(1, N'Nguyễn Thị Hương', '0987654321', N'Số 12, Đường X', N'Phường A', N'Quận B', N'TP Hà Nội', 1,GETDATE(), GETDATE()),
(1, N'Lê Hoàng Nam', '0987654322', N'Số 45, Đường Y', N'Phường C', N'Quận D', N'TP HCM', 1,GETDATE(), GETDATE());
-- Bảng xuat_xu
INSERT INTO xuat_xu (ten_xuat_xu, trang_thai, ngay_tao, ngay_sua)
VALUES 
  (N'Pháp', N'HOAT_DONG', GETDATE(), GETDATE()),
  (N'Hàn Quốc', N'HOAT_DONG', GETDATE(), GETDATE());

-- Bảng danh_muc
INSERT INTO danh_muc (ten_danh_muc, trang_thai, ngay_tao, ngay_sua)
VALUES 
  (N'Áo thun', N'HOAT_DONG', GETDATE(), GETDATE()),
  (N'Áo sơ mi', N'HOAT_DONG', GETDATE(), GETDATE());

-- Bảng thuong_hieu
INSERT INTO thuong_hieu (ten_thuong_hieu, trang_thai, ngay_tao, ngay_sua)
VALUES 
  (N'Nike', N'HOAT_DONG', GETDATE(), GETDATE()),
  (N'Adidas', N'HOAT_DONG', GETDATE(), GETDATE());

INSERT INTO san_pham
  (id_xuat_xu, id_danh_muc, id_thuong_hieu,ma_san_pham,
   ten_san_pham, so_luong_da_ban, url_anh, trang_thai, ngay_tao, ngay_sua)
VALUES
  (1,1,1,'SP01' ,N'Áo thun Nike',0, N'url_anh_dior_rouge1.png','HOAT_DONG',GETDATE(),GETDATE()),
  (2,2,2,'SP02', N'Áo sơ mi Adidas',0, N'url_anh_dior_rouge2.png','NGUNG_HOAT_DONG',GETDATE(),GETDATE());

-- Bảng mau_sac
INSERT INTO mau_sac (ten_mau_sac, trang_thai, ngay_tao, ngay_sua)
VALUES 
  (N'Xanh dương', N'HOAT_DONG', GETDATE(), GETDATE()),
  (N'Ghi',      N'HOAT_DONG', GETDATE(), GETDATE());

-- Bảng size
INSERT INTO size (ten_size, trang_thai, ngay_tao, ngay_sua)
VALUES 
  (N'M', N'HOAT_DONG', GETDATE(), GETDATE()),
  (N'S', N'HOAT_DONG', GETDATE(), GETDATE());
INSERT INTO san_pham_chi_tiet (id_mau_sac, id_size, id_san_pham,  so_luong, ma_vach, gia_ban, trang_thai,ngay_tao, ngay_sua)
VALUES 
(1, 1, 1,  200, N'1234567890123', 950000, N'Còn hàng',  GETDATE(), GETDATE()),
(2, 2, 2, 150, N'9876543210987', 850000, N'Còn hàng',  GETDATE(), GETDATE());


INSERT INTO phieu_giam_gia 
(ma_phieu_giam_gia, ten_phieu_giam_gia, gia_tri_giam, dieu_kien_ap_dung, ngay_bat_dau, ngay_ket_thuc, so_luong, mo_ta, trang_thai, ngay_tao, ngay_sua)
VALUES
('GG001', N'Giảm giá khai trương', 10.00, 500000.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', 100, N'Khuyến mãi khai trương dành cho áo sơ mi', N'DANG_DIEN_RA', '2024-12-01 09:00:00', NULL),
('GG002', N'Giảm giá cuối năm', 50000.00, 1000000.00, '2024-12-15 00:00:00', '2024-12-31 23:59:59', 50, N'Khuyến mãi cuối năm dành cho đơn hàng áo thun', N'DANG_DIEN_RA', '2024-12-10 10:00:00', NULL);
INSERT INTO chuc_vu (ten_chuc_vu)
VALUES 
(N'Admin');

INSERT INTO nhan_vien 
(id_chuc_vu, ten_nhan_vien, sdt, dia_chi, email, ngay_sinh, gioi_tinh, mat_khau, ngay_tao, ngay_sua)
VALUES 
( 1,N'Trần Thị Thanh Thảo', N'0987654321', N'Hà Nội', N'thao@gmail.com', '1990-01-01', N'Nữ', N'abc', GETDATE(), GETDATE());

select*from san_pham_chi_tiet