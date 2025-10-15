CREATE OR ALTER PROCEDURE ConsultarPorViviendaVehiculo
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Vehiculo 
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
END;

EXEC ConsultarPorViviendaVehiculo @NumeroVivienda = 101, @IdCluster = 1