--busca detalle recibo por Multa
CREATE OR ALTER PROCEDURE BuscarDetalleReciboPorMulta
@IdMultaVivienda int 
AS
	BEGIN
		SELECT dr.IdDetalleRecibo,dr.idCobroServicio,  dr.IdRecibo, dr.IdMultaVivienda, tm.Nombre AS NombreMulta
		From DetalleRecibo
		AS dr
		INNER JOIN MultaVivienda 
		AS mv 
		ON dr.IdMultaVivienda = mv.IdMultaVivienda
		INNER JOIN TipoMulta
		AS tm 
		ON mv.IdTipoMulta = tm.IdTipoMulta
		WHERE dr.IdMultaVivienda = @IdMultaVivienda
	END;
GO
EXEC BuscarDetalleReciboPorMulta
@IdMultaVivienda = 2
select * from DetalleRecibo