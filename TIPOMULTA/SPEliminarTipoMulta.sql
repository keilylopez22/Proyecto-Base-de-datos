--elimina un tipo de multa por medio del id 
CREATE OR ALTER PROCEDURE EliminarTipoMulta
@IdTipoMulta int 
AS
	IF NOT EXISTS (SELECT 1 FROM TipoMulta WHERE IdTipoMulta= @IdTipoMulta)
	BEGIN
		RAISERROR('El tipo de multa solicitado no existe.',16,1);
		RETURN;
	END
	IF EXISTS (SELECT 1 FROM MultaVivienda WHERE IdTipoMulta = @IdTipoMulta)
	BEGIN
		RAISERROR ('El tipo pagono se puede eliminar bedido a que esta asociado a otra entidad', 16,1);
		RETURN;
	END
 
BEGIN
	DELETE TipoMulta
	WHERE IdTipoMulta= @IdTipoMulta; 
	PRINT 'El tipo multa se ha eliminado correctamente.'
END;
GO
EXEC EliminarTipoMulta
@IdTipoMulta = 5 
select * from TipoMulta