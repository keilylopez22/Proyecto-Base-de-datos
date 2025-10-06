--Eliminar de ListaNegra
CREATE OR ALTER PROCEDURE EliminarListaNegra
    @IdListaNegra INT
AS
BEGIN
    DELETE FROM ListaNegra WHERE IdListaNegra = @IdListaNegra
    
    RETURN @@ROWCOUNT
END;

EXEC EliminarListaNegra @IdListaNegra = 1;
EXEC EliminarListaNegra @IdListaNegra = 2
--hacer primero estos para eliminar las dependecias de un vehículo