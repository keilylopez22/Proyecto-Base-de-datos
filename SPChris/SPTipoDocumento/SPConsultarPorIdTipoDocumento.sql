CREATE OR ALTER PROCEDURE ConsultarPorIdTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento
END;

EXEC ConsultarPorIdTipoDoc @IdTipoDocumento = 1