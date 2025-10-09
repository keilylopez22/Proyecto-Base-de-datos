--Actualización de tipo de pago
CREATE OR  ALTER PROCEDURE ActualizarTipoPago
@IdTipoPago int, 
@NuevaDescripcion VARCHAR (75)
AS

BEGIN 
	UPDATE TipoPago
	SET Descripcion = @NuevaDescripcion
	WHERE IdTipoPago = @IdTipoPago
	
	IF @@ROWCOUNT > 0 
	BEGIN  
	PRINT 'La fila se actualizo correctamente'
	END
	ELSE 
	BEGIN
	PRINT 'la fila no se actualizo'
	END 
END;
GO
EXEC ActualizarTipoPago
@IdTipoPago = 1,
@NuevaDescripcion = Efectivo
