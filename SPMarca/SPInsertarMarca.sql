--Insertar en Marca
CREATE OR ALTER PROCEDURE InsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarMarca @Descripcion = 'Kia'