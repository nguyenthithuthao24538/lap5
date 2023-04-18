--câu 1--
CREATE PROC ChinhsuaNV(@manv nvarchar(10), @tennv nvarchar(20), @gioitinh nvarchar(10), @diachi nvarchar(20), @sodt nvarchar(10), @email nvarchar(20), @phong nvarchar(30), @Flag int)
AS
	IF @gioitinh IN('nam', 'nu')
	BEGIN
		IF @Flag = 0
		BEGIN
			INSERT INTO Nhanvien(manv, Tennv, Gioitinh, Diachi, soddt, email, Phong)
			VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
		END
		ELSE 
		BEGIN
			UPDATE Nhanvien SET Tennv = @tennv, Gioitinh = @gioitinh, Diachi = @diachi, soddt = @sodt, email = @email, Phong = @phong
			WHERE manv = @manv
		END
		RAISERROR(N'Ma Loi 0', 16,1)
	END
	ELSE 
	BEGIN
		RAISERROR(N'Ma loi 1',16,1)
		ROLLBACK TRAN
	END
GO

--câu 2--
CREATE PROC ThemMoiSanPham122(@masp nvarchar(10), @tensp nvarchar(20), @tenhang nvarchar(20), @soluong int, @mausac nvarchar(10), @giaban money,  @donvitinh nvarchar(10), @mota nvarchar(30), @flag int)
AS
	IF @flag = 0
	BEGIN
		IF @tenhang NOT IN (SELECT mahangsx FROM Sanpham )
		BEGIN
			RAISERROR (N'Ma loi 1',16,1)
			ROLLBACK TRAN
		END
		IF @soluong < 0 
		BEGIN
			RAISERROR (N'Ma loi 2',16,1)
			ROLLBACK TRAN
		END
		IF @tenhang IN (SELECT mahangsx FROM Sanpham) AND @soluong > 0
		BEGIN
			INSERT INTO Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
			VALUES(@masp, @tenhang, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
			RAISERROR (N'Ma loi 0',16,1)
		END
	END
	ELSE
	BEGIN
		IF @tenhang NOT IN (SELECT mahangsx FROM Sanpham )
		BEGIN
			RAISERROR (N'Ma loi 1',16,1)
			ROLLBACK TRAN
		END
		IF @soluong < 0 
		BEGIN
			RAISERROR (N'Ma loi 2',16,1)
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			UPDATE Sanpham SET mahangsx = @tenhang, tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota
			WHERE masp = @masp
			RAISERROR (N'Ma loi 0',16,1)
		END
	END
GO

--câu 3--
CREATE PROC XoaNhanVien (@manv nvarchar(10))
AS
	IF @manv IN (SELECT Manv FROM Nhanvien)
	BEGIN
		DELETE FROM Nhanvien WHERE manv = @manv
		DELETE FROM Nhap WHERE manv = @manv
		DELETE FROM Xuat WHERE manv = @manv
		RAISERROR(N'Ma loi 0',16,1)
	END
	ELSE 
	BEGIN
		RAISERROR (N'Ma loi 1',16,1)
		ROLLBACK TRAN
	END
GO
--câu 4--
CREATE PROC XoaSanPham (@masp nvarchar(10))
AS
	IF @masp IN (SELECT masp FROM sanpham)
	BEGIN
		DELETE FROM sanpham WHERE masp = @masp
		DELETE FROM Nhap WHERE masp = @masp
		DELETE FROM Xuat WHERE masp = @masp
		RAISERROR(N'Ma loi 0',16,1)
	END
	ELSE 
	BEGIN
		RAISERROR (N'Ma loi 1',16,1)
		ROLLBACK TRAN
	END
GO

--câu 5--
CREATE PROC NhapLieuHangSX1(@mahangsx nvarchar(10), @tenhang nvarchar(20), @diachi nvarchar(20), @sodt nvarchar(10), @email nvarchar(20))
AS 
	IF @tenhang NOT IN (SELECT Tenhang FROM Hangsx)
	BEGIN
		RAISERROR (N'Ma loi 0',16,1)
	END
	ELSE 
	BEGIN
		RAISERROR (N'Ma loi 1',16,1)
		ROLLBACK TRAN
	END
GO

--câu 6--
CREATE PROC Nhaphang12(@shdn nvarchar(10), @masp nvarchar(10), @manv nvarchar (10), @ngaynhap date, @soluongN int, @dongiaN money)
AS
	IF @masp IN (SELECT masp FROM Sanpham) AND @manv IN (SELECT Manv FROM Nhanvien)
	BEGIN
		IF @shdn IN (SELECT Sohdn FROM Nhap)
		BEGIN
			UPDATE Nhap SET masp = @masp, manv = @manv, Ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN
			WHERE Sohdn = @shdn
			RAISERROR (N'Ma loi 0',16,1)
		END
		ELSE
		BEGIN
			INSERT INTO Nhap(Sohdn, masp, manv, Ngaynhap, soluongN, dongiaN)
			VALUES (@shdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
			RAISERROR (N'Ma loi 0',16,1)
		END
	END
	ELSE
	BEGIN
		IF @masp NOT IN (SELECT masp FROM Sanpham) OR @manv NOT IN (SELECT manv FROM Nhanvien)
		BEGIN
			IF @masp NOT IN (SELECT masp FROM Sanpham)
			BEGIN
				RAISERROR (N'Ma loi 1',16,1)
				ROLLBACK TRAN
			END
			ELSE
			BEGIN
				RAISERROR (N'Ma loi 2',16,1)
				ROLLBACK TRAN
			END
		END
	END
GO
--câu 7--
CREATE PROC Xuathang12(@shdx nvarchar(10), @masp nvarchar(10), @manv nvarchar (10), @ngayxuat date, @soluongX int)
AS
	IF @masp IN (SELECT masp FROM Sanpham) AND @manv IN (SELECT Manv FROM Nhanvien) AND @soluongX <= (SELECT TOP 1 soluong FROM Sanpham)	
	BEGIN
		IF @shdx IN (SELECT Sohdx FROM Xuat)
		BEGIN
			UPDATE Xuat SET masp = @masp, manv = @manv, Ngayxuat = @ngayxuat, soluongX = @soluongX
			WHERE Sohdx = @shdx
		END
		ELSE
		BEGIN
			INSERT INTO Xuat(Sohdx, masp, manv, Ngayxuat, soluongX)
			VALUES (@shdx, @masp, @manv, @ngayxuat, @soluongX)
			RAISERROR (N'Ma loi 0',16,1)
		END
	END
	ELSE
	BEGIN
		IF @masp NOT IN(SELECT masp FROM Sanpham) OR @manv NOT IN (SELECT manv FROM Nhanvien) OR @soluongX >= (SELECT TOP 1 soluong FROM Sanpham)	
		BEGIN
			IF @masp NOT IN(SELECT masp FROM Sanpham)
			BEGIN
				RAISERROR (N'Ma loi 1',16,1)
				ROLLBACK TRAN
			END
			IF @manv NOT IN (SELECT manv FROM Nhanvien)
			BEGIN
				RAISERROR (N'Ma loi 2',16,1)
				ROLLBACK TRAN
			END
			ELSE
			BEGIN
				RAISERROR (N'Ma loi 1',16,1)
				ROLLBACK TRAN
			END
		END
	END
GO


