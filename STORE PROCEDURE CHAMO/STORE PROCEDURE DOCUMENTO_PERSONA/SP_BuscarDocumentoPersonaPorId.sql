CREATE OR ALTER PROCEDURE SP_BuscarDocumentoPersonaPorId
@IdTipoDocumento INT,
@IdPersona INT
AS
BEGIN

SELECT dp.NumeroDocumento, dp.Observaciones, td.Nombre AS TipoDocumento, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS Persona FROM DocumentoPersona dp
INNER JOIN TipoDocumento td ON dp.IdTipoDocumento = td.IdTipoDocumento
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
WHERE dp.IdTipoDocumento = @IdTipoDocumento AND dp.IdPersona = @IdPersona;
END;
