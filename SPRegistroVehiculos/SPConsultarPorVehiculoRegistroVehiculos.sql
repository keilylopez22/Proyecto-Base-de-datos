--Consulta por vehículo
CREATE OR ALTER PROCEDURE ConsultarPorVehiculoRegistroVehiculos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroVehiculos WHERE IdVehiculo = @IdVehiculo
END;

EXEC ConsultarPorVehiculoRegistroVehiculos @IdVehiculo = 1;