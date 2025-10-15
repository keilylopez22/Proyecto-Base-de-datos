--actualiza tipo multa por fila
CREATE OR ALTER PROCEDURE ActualizarTipoMulta
@IdTipoMulta int, 
@Nombre VARCHAR (50),
@Monto MONEY
AS
BEGIN
	UPDATE TipoMulta 
	SET Nombre = @Nombre,
		Monto = @Monto
	WHERE IdTipoMulta = @IdTipoMulta
	
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
EXEC ActualizarTipoMulta
@IdTipoMulta = 5,
@Nombre = 'Embriaguez excesiva',
@Monto = 950
select * from TipoMulta