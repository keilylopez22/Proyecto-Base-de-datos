-- 2. Eliminar de Visitante
CREATE OR ALTER PROCEDURE EliminarVisitante
 @IdVisitante INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'No se puede eliminar: existen vehículos asociados a este visitante'
            RETURN -1
        END
        IF EXISTS (SELECT 1 FROM RegistroVehiculos WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'No se puede eliminar: existen registros de vehículos asociados'
            RETURN -1
        END
        IF EXISTS (SELECT 1 FROM ListaNegra WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'No se puede eliminar: el visitante está en lista negra'
            RETURN -1
        END
        DELETE FROM Visitante WHERE IdVisitante = @IdVisitante
        PRINT 'Visitante eliminado exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar el visitante'
        RETURN -1
    END CATCH
END;

EXEC EliminarVisitante @IdVisitante = 8;