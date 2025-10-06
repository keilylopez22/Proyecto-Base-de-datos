-- Actualizar Marca
CREATE OR ALTER PROCEDURE ActualizarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE Marca 
    SET Descripcion = @Descripcion
    WHERE IdMarca = @IdMarca
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarMarca @IdMarca = 1, @Descripcion = 'Toyota Motors'
