CREATE OR ALTER PROCEDURE PSBuscarResidentePorEstado
@Estado VARCHAR(10)
AS
BEGIN
	SELECT CONCAT(P.PrimerNombre, ' ', COALESCE(P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ',COALESCE (P.SegundoApellido, '')) AS 'NOMBRES Y APELLIDOS', R.Estado
	FROM Residente AS R
	INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona
	WHERE Estado = @Estado
END;

EXEC PSBuscarResidentePorEstado
@Estado = 'Activo'

