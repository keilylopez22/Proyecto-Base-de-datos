--Consulta por vehículo
CREATE PROCEDURE ConsultarPorVehiculoListaNegra
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM ListaNegra WHERE IdVehiculo = @IdVehiculo
END;

EXEC ConsultarPorVehiculoListaNegra @IdVehiculo = 2;