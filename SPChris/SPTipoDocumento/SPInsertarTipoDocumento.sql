CREATE OR ALTER PROCEDURE InsertarTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO TipoDocumento (Nombre)
    VALUES (@Nombre)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarTipoDoc @Nombre = 'Cédula de Identidad'