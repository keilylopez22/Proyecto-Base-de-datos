CREATE OR ALTER PROCEDURE SPInsertarLinea
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    INSERT INTO Linea (Descripcion, IdMarca)
    VALUES (@Descripcion, @IdMarca)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC SPInsertarLinea @Descripcion = 'Camry', @IdMarca = 1