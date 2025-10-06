-- 2. Eliminar de Linea
CREATE OR ALTER PROCEDURE EliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
            PRINT 'No se puede eliminar: existen vehículos asociados a esta línea'
            RETURN -1
        END
        DELETE FROM Linea WHERE IdLinea = @IdLinea
        PRINT 'Línea eliminada exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar la línea'
        RETURN -1
    END CATCH
END;

EXEC EliminarLinea @IdLinea = 1;