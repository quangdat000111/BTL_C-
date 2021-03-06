USE [master]
GO
/****** Object:  Database [QLDSV]    Script Date: 24/05/2021 4:39:27 CH ******/
CREATE DATABASE [QLDSV]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLDSV', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QLDSV.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QLDSV_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\QLDSV_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [QLDSV] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLDSV].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLDSV] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLDSV] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLDSV] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLDSV] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLDSV] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLDSV] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QLDSV] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLDSV] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLDSV] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLDSV] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLDSV] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLDSV] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLDSV] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLDSV] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLDSV] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QLDSV] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLDSV] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLDSV] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLDSV] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLDSV] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLDSV] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLDSV] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLDSV] SET RECOVERY FULL 
GO
ALTER DATABASE [QLDSV] SET  MULTI_USER 
GO
ALTER DATABASE [QLDSV] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLDSV] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLDSV] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLDSV] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QLDSV] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QLDSV] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'QLDSV', N'ON'
GO
ALTER DATABASE [QLDSV] SET QUERY_STORE = OFF
GO
USE [QLDSV]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_KiemTra_Diem]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fn_KiemTra_Diem] (@MaSV nvarchar(50), @MaMH nvarchar(50))
RETURNS INT
AS
BEGIN
	DECLARE @check int
	SET @check= 1
	IF NOT EXISTS (SELECT * FROM DIEM WHERE CONVERT(char(10), @MaMH)= MaMH AND CONVERT(char(10), @MaSV)= MaSV)
	SET @check= 0
	RETURN @check
END
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_KiemTra_MonHoc]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fn_KiemTra_MonHoc] (@MaMH nvarchar(50))
RETURNS INT
AS
BEGIN
	DECLARE @check int
	SET @check= 1
	IF NOT EXISTS (SELECT * FROM MONHOC WHERE CONVERT(char(10), @MaMH)= MaMH)
	SET @check= 0
	RETURN @check
END
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_KiemTra_SinhVien]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fn_KiemTra_SinhVien] (@MaSV nvarchar(50))
RETURNS INT
AS
BEGIN
	DECLARE @check int
	SET @check= 1
	IF NOT EXISTS (SELECT * FROM SINHVIEN WHERE CONVERT(char(10), @MaSV)= MaSV)
	SET @check= 0
	RETURN @check
END
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_ThongKe]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fn_ThongKe](@TenMH nvarchar(50))
RETURNS @ThongKe TABLE
(
	MaLop char(10),
	SLSV int,
	DiemF int,
	DiemD int,
	DiemDp int,
	DiemC int,
	DiemCp int,
	DiemB int,
	DIemBp int,
	DiemA int
)
AS
BEGIN
DECLARE @MaMH char(10)
-- Tìm MaMH theo tên MH
SELECT @MaMH= MaMH FROM MONHOC WHERE @TenMH= TenMonHoc
-- Biến bảng @Lop dùng để lưu thông tin các lớp chính có sinh viên học môn này
DECLARE @Lop TABLE
(
	MaLop char(10)
)
-- Chèn dữ liệu vào bảng @Lop
INSERT INTO @Lop SELECT DISTINCT MaLop FROM SINHVIEN WHERE MaSV IN (SELECT MaSV FROM DIEM WHERE @MaMH= MaMH)
-- Biến @SoLop lưu số lượng lớp trong bảng @Lop, phục vụ cho vòng while sau này
DECLARE @SoLop int
SELECT @SoLop= COUNT(*) FROM @Lop
WHILE @SoLop > 0
	BEGIN
		DECLARE @SLSV int, @A int, @Bp int, @B int, @Cp int, @C int, @Dp int, @D int, @F int
		DECLARE @MaLop char(10)
		SELECT TOP(1) @MaLop= MaLop FROM @Lop
		DECLARE @DIEMTAM TABLE
		(MaSV char(10),
		 MaMH char(10),
		 DiemTB real
		 )
		 INSERT INTO @DIEMTAM SELECT MaSV, MaMH, DiemTB FROM DIEM WHERE MaMH= @MaMH AND MaSV IN (SELECT MaSV FROM SINHVIEN WHERE MaLop= @MaLop)
		 SELECT @SLSV= COUNT(*) FROM @DIEMTAM
		 SELECT @A= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 8.5
		 SELECT @Bp= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 7.7 AND DiemTB < 8.5 
		 SELECT @B= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 7 AND DiemTB < 7.7 
		 SELECT @Cp= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 6.2 AND DiemTB < 7
		 SELECT @C= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 5.5 AND DiemTB < 6.2
		 SELECT @Dp= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 4.7 AND DiemTB < 5.5 
		 SELECT @D= COUNT(*) FROM @DIEMTAM WHERE DiemTB >= 4 AND DiemTB < 4.7 
		 SELECT @F= COUNT(*) FROM @DIEMTAM WHERE DiemTB < 4
		 INSERT INTO @ThongKe VALUES(@MaLop, @SLSV, @F, @D, @Dp, @C, @Cp, @B, @Bp, @A)
		 DELETE FROM @DIEMTAM
		 DELETE TOP(1) FROM @Lop
		 SELECT @SoLop= @SoLop - 1
	END
	RETURN
END
GO
/****** Object:  Table [dbo].[DIEM]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIEM](
	[MaSV] [char](10) NOT NULL,
	[MaMH] [char](10) NOT NULL,
	[DiemTX] [real] NULL,
	[DiemKTHP] [real] NULL,
	[DiemTB] [real] NULL,
	[DiemChu] [nvarchar](50) NULL,
 CONSTRAINT [PK_DIEM] PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC,
	[MaMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GIANGVIEN]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIANGVIEN](
	[MaGV] [char](10) NOT NULL,
	[TenGV] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[GioiTinh] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOP]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP](
	[MaLop] [char](10) NOT NULL,
	[TenLop] [nvarchar](50) NULL,
	[TenKhoa] [nvarchar](50) NULL,
	[GVCN] [nvarchar](50) NULL,
	[SoLuongSV] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOP_MONHOC]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOP_MONHOC](
	[MaLopHoc] [char](10) NOT NULL,
	[MaMH] [char](10) NULL,
	[MaGV] [char](10) NULL,
	[PhongHoc] [nvarchar](50) NULL,
	[ThoiGian] [nvarchar](50) NULL,
	[BatDau] [date] NULL,
	[KetThuc] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLopHoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MONHOC]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MONHOC](
	[MaMH] [char](10) NOT NULL,
	[TenMonHoc] [nvarchar](50) NULL,
	[SoTC] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MaMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MaSV] [char](10) NOT NULL,
	[TenSV] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[GioiTinh] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [nvarchar](50) NULL,
	[MaLop] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaSV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAIKHOANGV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOANGV](
	[TaiKhoan] [nvarchar](50) NOT NULL,
	[MatKhau] [char](10) NULL,
	[MaGV] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[TaiKhoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAIKHOANQTV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOANQTV](
	[TaiKhoan] [char](10) NOT NULL,
	[MatKhau] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TaiKhoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TAIKHOANSV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAIKHOANSV](
	[TaiKhoan] [nvarchar](50) NOT NULL,
	[MatKhau] [char](10) NULL,
	[MaSV] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[TaiKhoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DIEM]  WITH CHECK ADD  CONSTRAINT [FK_MONHOC_DIEM] FOREIGN KEY([MaMH])
REFERENCES [dbo].[MONHOC] ([MaMH])
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [FK_MONHOC_DIEM]
GO
ALTER TABLE [dbo].[DIEM]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_DIEM] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SINHVIEN] ([MaSV])
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [FK_SINHVIEN_DIEM]
GO
ALTER TABLE [dbo].[LOP_MONHOC]  WITH CHECK ADD  CONSTRAINT [FK_GIANGVIEN_MH_GV] FOREIGN KEY([MaGV])
REFERENCES [dbo].[GIANGVIEN] ([MaGV])
GO
ALTER TABLE [dbo].[LOP_MONHOC] CHECK CONSTRAINT [FK_GIANGVIEN_MH_GV]
GO
ALTER TABLE [dbo].[LOP_MONHOC]  WITH CHECK ADD  CONSTRAINT [FK_MONHOC_MH_GV] FOREIGN KEY([MaMH])
REFERENCES [dbo].[MONHOC] ([MaMH])
GO
ALTER TABLE [dbo].[LOP_MONHOC] CHECK CONSTRAINT [FK_MONHOC_MH_GV]
GO
ALTER TABLE [dbo].[SINHVIEN]  WITH CHECK ADD  CONSTRAINT [FK_LOP_SINHVIEN] FOREIGN KEY([MaLop])
REFERENCES [dbo].[LOP] ([MaLop])
GO
ALTER TABLE [dbo].[SINHVIEN] CHECK CONSTRAINT [FK_LOP_SINHVIEN]
GO
ALTER TABLE [dbo].[TAIKHOANGV]  WITH CHECK ADD  CONSTRAINT [FK_GIANGVIEN_TAOKHOANGV] FOREIGN KEY([MaGV])
REFERENCES [dbo].[GIANGVIEN] ([MaGV])
GO
ALTER TABLE [dbo].[TAIKHOANGV] CHECK CONSTRAINT [FK_GIANGVIEN_TAOKHOANGV]
GO
ALTER TABLE [dbo].[TAIKHOANSV]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_TAIKHOANSV] FOREIGN KEY([MaSV])
REFERENCES [dbo].[SINHVIEN] ([MaSV])
GO
ALTER TABLE [dbo].[TAIKHOANSV] CHECK CONSTRAINT [FK_SINHVIEN_TAIKHOANSV]
GO
/****** Object:  StoredProcedure [dbo].[DangNhap_GV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hàm kiểm tra đăng nhập
CREATE PROCEDURE [dbo].[DangNhap_GV] @taikhoan nvarchar(50), @matkhau nvarchar(50)
AS
SELECT * FROM TAIKHOANGV
			WHERE CONVERT(char(10), @matkhau)= MatKhau
			AND @taikhoan= TaiKhoan
GO
/****** Object:  StoredProcedure [dbo].[DangNhap_QTV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DangNhap_QTV] @taikhoan nvarchar(50), @matkhau nvarchar(50)
AS
SELECT * FROM TAIKHOANQTV
			WHERE CONVERT(char(10), @matkhau)= MatKhau
			AND @taikhoan= TaiKhoan
GO
/****** Object:  StoredProcedure [dbo].[DangNhap_SV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
--
--
CREATE PROCEDURE [dbo].[DangNhap_SV] @taikhoan nvarchar(50), @matkhau nvarchar(50)
AS
SELECT * FROM TAIKHOANSV
			WHERE CONVERT(char(10), @matkhau)= MatKhau
			AND @taikhoan= TaiKhoan
GO
/****** Object:  StoredProcedure [dbo].[Delete_Diem]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Delete_Diem] @MaSV nvarchar(50), @MaMH nvarchar(50)
AS
BEGIN
IF EXISTS(SELECT * FROM DIEM WHERE CONVERT(char(10), @MaMH)= MaMH AND CONVERT(char(10), @MaSV)= MaSV)
BEGIN
DELETE FROM DIEM WHERE  CONVERT(char(10), @MaMH)= MaMH AND CONVERT(char(10), @MaSV)= MaSV
END
END
GO
/****** Object:  StoredProcedure [dbo].[Insert_Diem]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
--
-- Trigger thêm dữ liệu thêm mới dữ liệu
-- Thủ tục thêm dữ liệu

CREATE PROCEDURE [dbo].[Insert_Diem] @MaSV nvarchar(50), @MaMH nvarchar(50), @DiemTX real, @DiemKTHP real, @DiemTB real, @DiemChu nvarchar(50)
AS
BEGIN
	
	INSERT INTO DIEM
	VALUES(CONVERT(char(10), @MaSV), CONVERT(char(10), @MaMH), @DiemTX, @DiemKTHP, @DiemTB, @DiemChu)
END
GO
/****** Object:  StoredProcedure [dbo].[TenMonHoc_GiangVienDay]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TenMonHoc_GiangVienDay] @MaGV nvarchar(50)
AS
SELECT TenMonHoc FROM MONHOC
WHERE MaMH IN (SELECT MaMH FROM LOP_MONHOC WHERE CONVERT(char(10), @MaGV) = MaGV)
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_Diem]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TimKiem_Diem] @masv nvarchar(50), @mamh nvarchar(50)
AS
SELECT MaSV N'Mã sinh viên', MaMH N'Mã môn học', DiemTX N'Điểm thường xuyên', DiemKTHP N'Điểm thi kết thúc học phần', DiemTB N'Điểm trung bình', DiemChu 'Điểm chữ' FROM DIEM
WHERE CONVERT(char(10), @masv)= MaSV
AND CONVERT(char(10), @mamh)= MaMH
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_Diem_TheoMaMH]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TimKiem_Diem_TheoMaMH] @mamh nvarchar(50)
AS
SELECT MaSV N'Mã sinh viên', MaMH N'Mã môn học', DiemTX N'Điểm thường xuyên', DiemKTHP N'Điểm thi kết thúc học phần', DiemTB N'Điểm trung bình', DiemChu 'Điểm chữ'
FROM DIEM
WHERE CONVERT(char(10), @mamh) = MaMH
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_Diem_TheoMaSV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TimKiem_Diem_TheoMaSV] @masv nvarchar(50)
AS
SELECT MaMH N'Mã môn học', DiemTX N'Điểm thường xuyên', DiemKTHP N'Điểm thi kết thúc học phần', DiemTB N'Điểm trung bình', DiemChu 'Điểm chữ'
FROM DIEM
WHERE CONVERT(char(10), @masv) = MaSV
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_GiangVien]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
-- Tìm kiếm giảng viên theo mã giảng viên
--
CREATE PROCEDURE [dbo].[TimKiem_GiangVien] @magv nvarchar(50)
AS
SELECT MaGV N'Mã giảng viên', TenGV N'Tên giảng viên', NgaySinh N'Ngày sinh', GioiTinh N'Giới tính', DiaChi N'Địa chỉ', SDT N'Số điện thoại'
FROM GIANGVIEN
WHERE CONVERT(char(10), @magv)= MaGV
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_Lop]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
-- Danh sach lop
--
-- PROCEDURE tim kiem lop theo MaLop
CREATE PROCEDURE [dbo].[TimKiem_Lop] @malop nvarchar(50)
AS
SELECT MaLop N'Mã lớp', TenLop N'Tên lớp', TenKhoa N'Tên khoa', GVCN, SoLuongSV N'Số lượng sinh viên'
FROM LOP WHERE CONVERT(char(10), @malop) = MaLop
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_LopMonHoc]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
--
-- Tìm kiếm Lơp mon hoc theo ma lop mon hoc
CREATE PROCEDURE [dbo].[TimKiem_LopMonHoc] @malopmonhoc nvarchar(50)
AS
SELECT MaLopHoc N'Mã lớp môn học', MaMH N'Mã môn học', MaGV N'Mã giảng viên', PhongHoc N'Phòng học', ThoiGian N'Thời gian', BatDau N'Bắt đầu', KetThuc N'Kết thúc'
FROM LOP_MONHOC
WHERE CONVERT(char(10), @malopmonhoc) = MaLopHoc
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_LopMonHoc_TheoMaGV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
--
--
CREATE PROCEDURE [dbo].[TimKiem_LopMonHoc_TheoMaGV] @magv nvarchar(50)
AS
SELECT MaLopHoc N'Mã lớp học', MaMH N'Mã môn học', MaGV N'Mã giảng viên', PhongHoc N'Phòng học', ThoiGian N'Thời gian', BatDau N'Bắt đầu', KetThuc N'Kết thúc'
FROM LOP_MONHOC
WHERE CONVERT(char(10), @magv)= MaGV
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_LopMonHoc_TheoMaMH]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
-- Tìm kiếm lớp môn học theo mã môn học
CREATE PROCEDURE [dbo].[TimKiem_LopMonHoc_TheoMaMH] @mamonhoc nvarchar(50)
AS
SELECT MaLopHoc N'Mã lớp môn học', MaMH N'Mã môn học', MaGV N'Mã giảng viên', PhongHoc N'Phòng học', ThoiGian N'Thời gian', BatDau N'Bắt đầu', KetThuc N'Kết thúc'
FROM LOP_MONHOC
WHERE CONVERT(char(10), @mamonhoc) = MaMH
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_MonHoc]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--
-- Taoj procedure tìm môn học theo mã môn học
CREATE PROCEDURE [dbo].[TimKiem_MonHoc] @mamh nvarchar(50)
AS
SELECT MaMH N'Mã môn học', TenMonHoc N'Tên môn học', SoTC N'Số tín chỉ'
FROM MONHOC
WHERE CONVERT(char(10), @mamh) = MaMH
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_SinhVien]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TimKiem_SinhVien] @masv nvarchar(50)
AS
SELECT * 
FROM SINHVIEN
WHERE CONVERT(char(10), @masv)= MaSV
GO
/****** Object:  StoredProcedure [dbo].[TimKiem_SinhVien_TheoLop]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[TimKiem_SinhVien_TheoLop] @malop nvarchar(50)
AS
SELECT MaSV N'Mã sinh viên', TenSV N'Tên sinh viên', NgaySinh N'Ngày sinh', GioiTinh N'Giới tính', DiaChi N'Địa chỉ', SDT N'Số điện thoại', MaLop N'Mã lớp'
FROM SINHVIEN
WhERE CONVERT(char(10), @malop) = MaLop
GO
/****** Object:  StoredProcedure [dbo].[TimKiemMonHoc_TheoMaGV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TimKiemMonHoc_TheoMaGV] @tendn nvarchar(50)
AS
DECLARE @magv nvarchar(50)
SELECT @magv = MaGV FROM TAIKHOANGV WHERE TaiKhoan = @tendn
SELECT MaMH N'Mã môn học', TenMonHoc N'Tên môn học', SoTC N'Số tín chỉ' FROM MONHOC
WHERE MaMH IN (SELECT MaMH FROM LOP_MONHOC WHERE MaGV = @magv)
GO
/****** Object:  StoredProcedure [dbo].[Update_Diem]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Update_Diem] @MaSV nvarchar(50), @MaMH nvarchar(50), @DiemTX real, @DiemKTHP real, @DiemTB real, @DiemChu nvarchar(50)
AS
BEGIN
IF EXISTS(SELECT * FROM DIEM WHERE CONVERT(char(10), @MaSV) = MaSV AND CONVERT(char(10), @MaMH)= MaMH)
UPDATE DIEM
SET DiemTX= @DiemTX, DiemKTHP= @DiemKTHP, DiemTB= @DiemTB, DiemChu= @DiemChu
WHERE CONVERT(char(10), @MaSV) = MaSV AND CONVERT(char(10), @MaMH)= MaMH
ELSE
EXEC Insert_Diem @MaSV, @MaMH, @DiemTX, @DiemKTHP, @DiemTB, @DiemChu
END
GO
/****** Object:  StoredProcedure [dbo].[Update_GiangVien]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Update_GiangVien] @MaGV nvarchar(50), @TenGV nvarchar(50), @NgaySinh nvarchar(50), @GioiTinh nvarchar(50), @DiaChi nvarchar(50), @SDT nvarchar(50), @matkhau nvarchar(50)
AS
BEGIN
UPDATE GIANGVIEN
SET TenGV= @TenGV, NgaySinh= CONVERT(date, @NgaySinh), DiaChi= @DiaChi, GioiTinh= @GioiTinh, SDT= @SDT
WHERE MaGV= CONVERT(char(10), @MaGV)
UPDATE TAIKHOANGV
SET MatKhau= CONVERT(char(10), @matkhau)
WHERE MaGV= CONVERT(char(10), @MaGV)
END
GO
/****** Object:  StoredProcedure [dbo].[Update_SinhVien]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Update_SinhVien] @MaSV nvarchar(50), @TenSV nvarchar(50), @NgaySinh nvarchar(50), @GioiTinh nvarchar(50), @DiaChi nvarchar(50), @SDT nvarchar(50), @matkhau nvarchar(50)
AS
BEGIN
UPDATE SINHVIEN
SET TenSV= @TenSV, NgaySinh= CONVERT(date, @NgaySinh), DiaChi= @DiaChi, GioiTinh= @GioiTinh, SDT= @SDT
WHERE MaSV= CONVERT(char(10), @MaSV)
UPDATE TAIKHOANSV
SET MatKhau= CONVERT(char(10), @matkhau)
WHERE MaSV= CONVERT(char(10), @MaSV)
END
GO
/****** Object:  StoredProcedure [dbo].[Update_TaiKhoanGV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Update_TaiKhoanGV] @TaiKhoan nvarchar(50), @MatKhau nvarchar(50), @MaGV nvarchar(50)
AS
BEGIN
IF EXISTS (SELECT * FROM TAIKHOANGV WHERE @TaiKhoan = TaiKhoan) 
BEGIN
UPDATE TAIKHOANGV
SET MatKhau= CONVERT(char(10), @MatKhau)
WHERE TaiKhoan= @TaiKhoan
END
ELSE
INSERT INTO TAIKHOANGV VALUES(@TaiKhoan, CONVERT(char(10), @MatKhau), CONVERT(char(10), @MaGV))
END
GO
/****** Object:  StoredProcedure [dbo].[Update_TaiKhoanQTV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Update_TaiKhoanQTV] @TaiKhoan nvarchar(50), @MatKhau nvarchar(50)
AS
BEGIN
IF EXISTS (SELECT * FROM TAIKHOANQTV WHERE @TaiKhoan = TaiKhoan)
BEGIN
UPDATE TAIKHOANQTV
SET MatKhau= CONVERT(char(10), @MatKhau)
END
ELSE
INSERT INTO TAIKHOANQTV VALUES (@TaiKhoan, CONVERT(char(10), @MatKhau))
END
GO
/****** Object:  StoredProcedure [dbo].[Update_TaiKhoanSV]    Script Date: 24/05/2021 4:39:27 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Update_TaiKhoanSV] @TaiKhoan nvarchar(50), @MatKhau nvarchar(50), @MaSV nvarchar(50)
AS
BEGIN
IF EXISTS (SELECT * FROM TAIKHOANSV WHERE @TaiKhoan = TaiKhoan) 
BEGIN
UPDATE TAIKHOANSV
SET MatKhau= CONVERT(char(10), @MatKhau)
WHERE TaiKhoan= @TaiKhoan
END
ELSE
INSERT INTO TAIKHOANSV VALUES(@TaiKhoan, CONVERT(char(10), @MatKhau), CONVERT(char(10), @MaSV))
END
GO
USE [master]
GO
ALTER DATABASE [QLDSV] SET  READ_WRITE 
GO
