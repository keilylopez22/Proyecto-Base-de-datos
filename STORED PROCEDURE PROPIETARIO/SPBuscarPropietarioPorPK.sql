CREATE OR ALTER PROCEDURE SPBuscarPropietario
@IdPropiestario INT
AS
BEGIN
	SELECT P.IdPropietario,PS.IdPersona,CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario'
	FROM Propietario AS P 
	INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
	WHERE IdPropietario = @IdPropiestario
END;
EXEC SPBuscarPropietario
@IdPropiestario = 10