CREATE OR ALTER PROCEDURE ConsultarPorVehiculoRegistroAccesos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo
END;

EXEC ConsultarPorVehiculoRegistroAccesos @IdVehiculo = 1