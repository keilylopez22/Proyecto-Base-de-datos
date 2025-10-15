--busca detalle recibo por el id 
CREATE OR ALTER PROCEDURE BuscarDetalleReciboPorID
@IdDetalleRecibo INT 
AS
BEGIN
	SELECT *
	From DetalleRecibo
	WHERE IdDetalleRecibo = @IdDetalleRecibo
END;
GO
EXEC BuscarDetalleReciboPorID
@IdDetalleRecibo = 1
