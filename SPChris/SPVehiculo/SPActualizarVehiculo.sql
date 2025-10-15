CREATE OR ALTER PROCEDURE ActualizarVehiculo
    @IdVehiculo INT,
    @A�o INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    UPDATE Vehiculo 
    SET A�o = @A�o,
        Placa = @Placa,
        NumeroVivienda = @NumeroVivienda,
        IdCluster = @IdCluster,
        IdLinea = @IdLinea,
        IdMarca = @IdMarca
    WHERE IdVehiculo = @IdVehiculo
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarVehiculo
    @IdVehiculo = 1,
    @A�o = 2021,
    @Placa = 'P123ABC',
    @NumeroVivienda = 101,
    @IdCluster = 1,
    @IdLinea = 1,
    @IdMarca = 1;