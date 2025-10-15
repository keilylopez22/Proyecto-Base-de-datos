CREATE OR ALTER PROCEDURE SPActualizarLinea
    @IdLinea INT,
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    UPDATE Linea 
    SET Descripcion = @Descripcion,
        IdMarca = @IdMarca
    WHERE IdLinea = @IdLinea
    
    RETURN @@ROWCOUNT
END;

EXEC SPActualizarLinea @IdLinea = 1, @Descripcion = 'Corolla SE', @IdMarca = 1