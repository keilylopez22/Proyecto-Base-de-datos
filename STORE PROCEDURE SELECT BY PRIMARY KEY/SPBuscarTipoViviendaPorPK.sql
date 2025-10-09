CREATE OR ALTER PROCEDURE SPBuscarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN
	SELECT *
	FROM TipoVivienda
	WHERE IdTipoVivienda= @IdTipoVivienda
END;

EXEC SPBuscarTipoVivienda
@IdTipoVivienda = 1