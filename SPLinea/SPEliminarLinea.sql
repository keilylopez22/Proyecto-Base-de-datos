-- 2. Eliminar de Linea
CREATE OR ALTER PROCEDURE EliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
            PRINT 'No se puede eliminar: existen veh�culos asociados a esta l�nea'
            RETURN -1
        END
        DELETE FROM Linea WHERE IdLinea = @IdLinea
        PRINT 'L�nea eliminada exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar la l�nea'
        RETURN -1
    END CATCH
END;

EXEC EliminarLinea @IdLinea = 1;