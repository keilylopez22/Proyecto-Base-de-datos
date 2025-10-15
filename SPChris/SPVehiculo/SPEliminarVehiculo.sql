CREATE OR ALTER PROCEDURE EliminarVehiculo
    @IdVehiculo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo)
        BEGIN
			PRINT 'Error: No se puede eliminar el vehículo ID ' + CAST(@IdVehiculo AS VARCHAR) + ' existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Vehiculo WHERE IdVehiculo = @IdVehiculo

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró el vehículo con ID ' + CAST(@IdVehiculo AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Vehículo eliminado correctamente. ID: ' + CAST(@IdVehiculo AS VARCHAR)
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar vehículo: ' + ERROR_MESSAGE()
			RETURN -1
    END CATCH
END;

select * from Vehiculo

EXEC EliminarVehiculo @IdVehiculo = 1
-- Primero se debe verificar que el IdVehiculo no esté en RegistroAccesos