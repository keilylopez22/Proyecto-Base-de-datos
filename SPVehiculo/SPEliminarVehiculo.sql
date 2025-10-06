-- 2. Eliminar Vehiculo
CREATE OR ALTER PROCEDURE EliminarVehiculo
    @IdVehiculo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroVehiculos WHERE IdVehiculo = @IdVehiculo)
        BEGIN
            PRINT 'No se puede eliminar: existen registros de veh�culos asociados'
            RETURN -1
        END
        IF EXISTS (SELECT 1 FROM ListaNegra WHERE IdVehiculo = @IdVehiculo)
        BEGIN
            PRINT 'No se puede eliminar: el veh�culo est� en lista negra'
            RETURN -1
        END
        DELETE FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
        PRINT 'Veh�culo eliminado exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar el veh�culo'
        RETURN -1
    END CATCH
END;

EXEC EliminarVehiculo @IdVehiculo = 2;
--Si ejecutan este primero, antes de elminar las dependencias,
--Les dar� error y les mostrar� el mensaje que dice arriba,
--Si eliminan las dependencias primero, se elimanar� con exito.