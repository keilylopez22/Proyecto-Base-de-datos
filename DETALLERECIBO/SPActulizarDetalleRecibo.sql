--actualiza el detalle del recibo 
CREATE OR ALTER PROCEDURE ActulizarDetalleRecibo
@IdDetalleRecibo INT,
@IdRecibo INT, 
@idCobroServicio INT, 
@IdMultaVivienda INT
AS
BEGIN
	UPDATE DetalleRecibo
	SET IdRecibo = @IdRecibo,
		idCobroServicio = @idCobroServicio,
		IdMultaVivienda = @IdMultaVivienda
	WHERE IdDetalleRecibo = @IdDetalleRecibo

END;
GO
EXEC ActulizarDetalleRecibo
@IdDetalleRecibo =3,
@IdRecibo =3, 
@idCobroServicio = 5, 
@IdMultaVivienda = 4

select * from DetalleRecibo
select * from TipoMulta