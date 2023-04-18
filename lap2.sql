--câu 1--
CREATE TRIGGER Nhapdulieu1 ON Nhap
FOR INSERT AS
BEGIN 
	DECLARE @masp nvarchar(10), @manv nvarchar(10), @sln int, @dgn money
	SELECT @masp = masp, @manv = @manv , @sln = SoluongN, @dgn = DongiaN FROM inserted
	UPDATE Sanpham SET soluong = soluong + @sln WHERE masp = @masp
	IF @masp NOT IN (SELECT masp FROM Sanpham) OR @manv NOT IN (SELECT manv FROM Nhanvien)
	BEGIN
		IF @masp NOT IN (SELECT masp FROM Sanpham)
		BEGIN
			RAISERROR (N'Ma San Pham Khong Ton Tai',16,1)
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			RAISERROR (N'Ma Nhan Vien Khong Ton Tai',16,1)
			ROLLBACK TRAN
		END
	END
	ELSE
	BEGIN
		IF @sln <=0 OR @dgn <= 0
		BEGIN
			RAISERROR (N'So luong nhap va don gia nhap sai',16,1)
			ROLLBACK TRAN
		END
	END
END
--câu 2--
CREATE TRIGGER XuatHang123 ON Xuat
FOR INSERT AS
BEGIN 
	DECLARE @masp nvarchar(10), @manv nvarchar(10), @slx int
	SELECT @masp = masp, @manv = @manv , @slx = soluongX FROM inserted
	UPDATE Sanpham SET soluong = soluong - @slx WHERE masp = @masp
	IF @masp NOT IN (SELECT masp FROM Sanpham) OR @manv NOT IN (SELECT manv FROM Nhanvien)
	BEGIN
		IF @masp NOT IN (SELECT masp FROM Sanpham)
		BEGIN
			RAISERROR (N'Ma San Pham Khong Ton Tai',16,1)
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			RAISERROR (N'Ma Nhan Vien Khong Ton Tai',16,1)
			ROLLBACK TRAN
		END
	END
	ELSE
	BEGIN
		IF @slx > (SELECT TOP 1 Soluong FROM Sanpham)
		BEGIN
			RAISERROR (N'So luong xuat cao hon ton kho',16,1)
			ROLLBACK TRAN
		END
	END
END
--câu 3--
CREATE TRIGGER XoaPhieuXuat ON Xuat
FOR DELETE AS
BEGIN
	UPDATE Sanpham SET soluong=soluong+(SELECT soluongX FROM deleted WHERE masp=Sanpham.masp)
	FROM Sanpham 
	JOIN deleted ON Sanpham.masp=deleted.Masp
END
--câu 4--
CREATE TRIGGER [dbo].[XuatHang123] ON [dbo].[Xuat]
FOR UPDATE AS
BEGIN 
	DECLARE @masp nvarchar(10), @slx int
	SELECT @masp = masp, @slx = soluongX FROM inserted
	UPDATE Sanpham SET soluong = soluong - @slx WHERE masp = @masp
	IF @slx > (SELECT TOP 1 Soluong FROM Sanpham)
	BEGIN
		RAISERROR (N'So luong xuat cao hon ton kho',16,1)
		ROLLBACK TRAN
	END
END
--câu 5--
CREATE TRIGGER [dbo].[Capnhatdulieu] ON [dbo].[Nhap]
FOR UPDATE AS
BEGIN 
	DECLARE @masp nvarchar(10), @sln int, @dgn money
	SELECT @masp = masp, @sln = soluongN, @dgn = dongiaN FROM inserted
	UPDATE Sanpham SET soluong = soluong + @sln WHERE masp = @masp
	IF @sln <=0 OR @dgn <= 0
		BEGIN
			RAISERROR (N'So luong nhap va don gia nhap sai',16,1)
			ROLLBACK TRAN
		END
END
--câu 6--
CREATE TRIGGER XoaPhieuNhap ON Nhap
FOR DELETE AS
BEGIN
	UPDATE Sanpham SET soluong=soluong-(SELECT soluongN FROM deleted WHERE masp=Sanpham.masp)
	FROM Sanpham 
	JOIN deleted ON Sanpham.masp=deleted.Masp
END