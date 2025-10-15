--Actualización de tipo de pago
CREATE OR  ALTER PROCEDURE ActualizarTipoPago
@idTipoPago int, 
@NuevoNombre VARCHAR (50),
@NuevaDescripcion VARCHAR(100)
AS

BEGIN 
	UPDATE TipoPago
	SET Nombre = @NuevoNombre,
		Descripcion = @NuevaDescripcion
	WHERE idTipoPago = @idTipoPago
	
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
@idTipoPago = 4,
@NuevoNombre = 'Tarjeta de Credito',
@NuevaDescripcion = 'Pago mediante tarjeta bancaria con crédito disponible'
