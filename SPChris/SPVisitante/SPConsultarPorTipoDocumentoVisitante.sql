CREATE OR ALTER PROCEDURE ConsultarPorTipoDocumentoVisitante
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento
END;

EXEC ConsultarPorTipoDocumentoVisitante @IdTipoDocumento = 1;