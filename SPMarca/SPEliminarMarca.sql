-- 2. Eliminar de Marca
CREATE OR ALTER PROCEDURE EliminarMarca
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Linea WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'No se puede eliminar: existen líneas asociadas a esta marca'
            RETURN -1
        END
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'No se puede eliminar: existen vehículos asociados a esta marca'
            RETURN -1
        END
        DELETE FROM Marca WHERE IdMarca = @IdMarca
        PRINT 'Marca eliminada exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar la marca'
        RETURN -1
    END CATCH
END;

EXEC EliminarMarca @IdMarca = 1;-- esto no se elminara, porque tiene lineas asociadas

EXEC EliminarMarca @IdMarca = 11 --este si, porque no tiene lineas asociadas
