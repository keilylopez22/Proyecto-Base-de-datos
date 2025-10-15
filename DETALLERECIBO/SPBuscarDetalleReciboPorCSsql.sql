--busca detalle recibo por cobro del servicio vivienda 
CREATE OR ALTER PROCEDURE BuscarDetalleReciboPorCS
@idCobroServicio int 
AS
	BEGIN
		SELECT idCobroServicio, IdDetalleRecibo, IdRecibo, IdMultaVivienda
		From DetalleRecibo
		WHERE idCobroServicio = @idCobroServicio
	END;
GO
EXEC BuscarDetalleReciboPorCS
@idCobroServicio = 3
select * from DetalleRecibo