CREATE OR ALTER PROCEDURE EliminarMultaVivienda
@IdMultaVivienda int 
AS
	IF NOT EXISTS (SELECT 1 FROM MultaVivienda WHERE IdMultaVivienda=@IdMultaVivienda )
		BEGIN
			RAISERROR('La multa vivienda no existe',16,1);
			RETURN; 
		END 
	IF NOT EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdMultaVivienda=@IdMultaVivienda )
	BEGIN
		RAISERROR('La multa vivienda nose puede eliminiar porque esta asociada con otra entidad',16,1);
		RETURN; 
	END 
BEGIN
	DELETE MultaVivienda
	WHERE IdMultaVivienda = @IdMultaVivienda;
	PRINT 'La multa de la vivienda se ha eliminado correctamente.'

END;
GO
EXEC EliminarMultaVivienda
@IdMultaVivienda = 14

select * from MultaVivienda