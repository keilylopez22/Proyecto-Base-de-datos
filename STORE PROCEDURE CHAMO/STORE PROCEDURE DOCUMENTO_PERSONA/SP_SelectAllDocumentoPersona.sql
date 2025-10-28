CREATE OR ALTER PROCEDURE SP_SelectAllDocumentoPersona
    @Offset INT,
    @Limit INT,
    @NumeroDocumento INT = NULL,
    @IdTipoDocumento INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    SELECT 
        dp.NumeroDocumento, 
        dp.IdTipoDocumento, 
        dp.IdPersona, 
        dp.Observaciones,
        td.Nombre AS TipoDocumentoNombre,
        CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS NombrePersona
FROM DocumentoPersona dp
INNER JOIN TipoDocumento td ON dp.IdTipoDocumento = td.IdTipoDocumento
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
WHERE (@NumeroDocumento IS NULL OR dp.NumeroDocumento = @NumeroDocumento) AND (@IdTipoDocumento IS NULL OR dp.IdTipoDocumento = @IdTipoDocumento)
ORDER BY dp.IdPersona, dp.IdTipoDocumento
OFFSET 
@Offset ROWS 
FETCH NEXT @Limit ROWS ONLY;

SELECT COUNT(*) AS TotalCount FROM DocumentoPersona dp
WHERE (@NumeroDocumento IS NULL OR dp.NumeroDocumento = @NumeroDocumento) AND (@IdTipoDocumento IS NULL OR dp.IdTipoDocumento = @IdTipoDocumento);
END
GO