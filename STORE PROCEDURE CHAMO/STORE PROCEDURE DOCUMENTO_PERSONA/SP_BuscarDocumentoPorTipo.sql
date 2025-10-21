CREATE OR ALTER PROCEDURE SP_BuscarDocumentoPorTipo
@IdTipoDocumento INT
AS
BEGIN

SELECT dp.NumeroDocumento, dp.Observaciones, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS Persona FROM DocumentoPersona dp
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
WHERE dp.IdTipoDocumento = @IdTipoDocumento
END

EXEC SP_BuscarDocumentoPorTipo
@IdTipoDocumento = 1
