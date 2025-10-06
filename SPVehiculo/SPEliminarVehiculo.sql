-- 2. Eliminar Vehiculo
CREATE OR ALTER PROCEDURE EliminarVehiculo
    @IdVehiculo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroVehiculos WHERE IdVehiculo = @IdVehiculo)
        BEGIN
            PRINT 'No se puede eliminar: existen registros de vehículos asociados'
            RETURN -1
        END
        IF EXISTS (SELECT 1 FROM ListaNegra WHERE IdVehiculo = @IdVehiculo)
        BEGIN
            PRINT 'No se puede eliminar: el vehículo está en lista negra'
            RETURN -1
        END
        DELETE FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
        PRINT 'Vehículo eliminado exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar el vehículo'
        RETURN -1
    END CATCH
END;

EXEC EliminarVehiculo @IdVehiculo = 2;
--Si ejecutan este primero, antes de elminar las dependencias,
--Les dará error y les mostrará el mensaje que dice arriba,
--Si eliminan las dependencias primero, se elimanará con exito.