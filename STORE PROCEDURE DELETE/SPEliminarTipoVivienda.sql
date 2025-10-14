CREATE OR ALTER PROCEDURE PSEliminarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN 
	DELETE TipoVivienda
	WHERE IdTipoVivienda = @IdTipoVivienda
	SELECT @IdTipoVivienda
END;

EXEC PSEliminarTipoVivienda
@IdTipoVivienda = 4
