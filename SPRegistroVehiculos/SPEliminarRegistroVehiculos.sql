-- Eliminar de RegistroVehiculos
CREATE OR ALTER PROCEDURE EliminarRegistroVehiculos
    @IdRegistroVehiculo INT
AS
BEGIN
    DELETE FROM RegistroVehiculos WHERE IdRegistroVehiculo = @IdRegistroVehiculo
    
    RETURN @@ROWCOUNT
END;

EXEC EliminarRegistroVehiculos @IdRegistroVehiculo = 2;
--Ejecutar este en segundo lugar, para poder eliminar un vehículo.