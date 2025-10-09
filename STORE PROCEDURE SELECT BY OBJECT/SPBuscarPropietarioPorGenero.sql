CREATE OR ALTER PROCEDURE PSBuscarPropietarioPorGenero
@Genero CHAR(1)
AS
BEGIN
	SELECT P.IdPropietario,CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario', PS.Genero
	FROM Propietario AS P
	INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
	WHERE PS.Genero = @Genero

END;

EXEC PSBuscarPropietarioPorGenero
@Genero = 'F'