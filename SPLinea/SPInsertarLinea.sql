--Insertar en Linea
CREATE OR ALTER PROCEDURE InsertarLinea
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    INSERT INTO Linea (Descripcion, IdMarca)
    VALUES (@Descripcion, @IdMarca)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarLinea @Descripcion = 'Camry', @IdMarca = 1