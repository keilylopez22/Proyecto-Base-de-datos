--insertar  detalle recibo 
CREATE OR ALTER PROCEDURE InsertarDetalleRecibo
@IdRecibo INT,
@idCobroServicio INT,
@IdMultaVivienda INT
AS
BEGIN
	INSERT INTO DetalleRecibo(IdRecibo, idCobroServicio, IdMultaVivienda)
	VALUES (@IdRecibo, @idCobroServicio, @IdMultaVivienda)
	SELECT SCOPE_IDENTITY () AS IdDetalleRecibo
END;
GO
EXEC InsertarDetalleRecibo
@IdRecibo= 10, 
@idCobroServicio= 3,
@IdMultaVivienda= 1
select * from DetalleRecibo