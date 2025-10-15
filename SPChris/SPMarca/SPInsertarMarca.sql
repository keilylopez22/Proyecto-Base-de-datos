CREATE OR ALTER PROCEDURE SPInsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC SPInsertarMarca @Descripcion = 'Kia'