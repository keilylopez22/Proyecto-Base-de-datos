--Consulta por llave primaria
CREATE OR ALTER PROCEDURE ConsultarPorIdRegistroVehiculos
    @IdRegistroVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroVehiculos WHERE IdRegistroVehiculo = @IdRegistroVehiculo
END;

EXEC ConsultarPorIdRegistroVehiculos @IdRegistroVehiculo = 1;