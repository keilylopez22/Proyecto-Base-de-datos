--Consultar por llave Primaria
CREATE OR ALTER PROCEDURE ConsultarPorIdVehiculo
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
END;

EXEC ConsultarPorIdVehiculo @IdVehiculo = 1;