--Consultar Vehiculo por placa
CREATE OR ALTER PROCEDURE ConsultarPorPlacaVehiculo
    @Placa VARCHAR(10)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Placa = @Placa
END;

EXEC ConsultarPorPlacaVehiculo @Placa = 'P123ABC';