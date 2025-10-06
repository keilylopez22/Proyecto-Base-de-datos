-- Consulta por tipo de documento
CREATE OR ALTER PROCEDURE ConsultarPorTipoDocumentoVisitante
    @TipoDocumento VARCHAR(50)
AS
BEGIN
    SELECT * FROM Visitante WHERE TipoDocumento = @TipoDocumento
END;

EXEC ConsultarPorTipoDocumentoVisitante @TipoDocumento = 'DPI';