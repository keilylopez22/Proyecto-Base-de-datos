--elimina el detalle recibo 
CREATE OR ALTER PROCEDURE EliminarDetalleRecibo
@IdDetalleRecibo INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdDetalleRecibo = @IdDetalleRecibo)
	BEGIN
		DELETE FROM DetalleRecibo
		WHERE IdDetalleRecibo = @IdDetalleRecibo;
		PRINT 'Detalle eliminado correctamente.';
		END
		ELSE
		BEGIN
			PRINT 'El detalle solicitado no existe.';
		END
END;
GO
EXEC EliminarDetalleRecibo
@IdDetalleRecibo = 14
select * from DetalleRecibo