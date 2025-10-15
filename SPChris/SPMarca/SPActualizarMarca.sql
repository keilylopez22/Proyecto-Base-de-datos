CREATE OR ALTER PROCEDURE SPActualizarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE Marca 
    SET Descripcion = @Descripcion
    WHERE IdMarca = @IdMarca
    
    RETURN @@ROWCOUNT
END;

EXEC SPActualizarMarca @IdMarca = 1, @Descripcion = 'Toyota Motors'