CREATE PROCEDURE ActualizarTipoDoc
    @IdTipoDocumento INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    UPDATE TipoDocumento 
    SET Nombre = @Nombre
    WHERE IdTipoDocumento = @IdTipoDocumento
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarTipoDoc @IdTipoDocumento = 1, @Nombre = 'Documento Personal de Identificación'