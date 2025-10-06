-- 3. Actualizar Vehiculo
CREATE OR ALTER PROCEDURE ActualizarVehiculo
    @IdVehiculo INT,
    @Placa VARCHAR(10),
    @Modelo VARCHAR(30),
    @IdLinea INT,
    @IdMarca INT,
    @IdResidente INT,
    @IdVisitante INT
AS
BEGIN
    UPDATE Vehiculo 
    SET Placa = @Placa,
        Modelo = @Modelo,
        IdLinea = @IdLinea,
        IdMarca = @IdMarca,
        IdResidente = @IdResidente,
        IdVisitante = @IdVisitante
    WHERE IdVehiculo = @IdVehiculo
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarVehiculo
    @IdVehiculo = 1,
    @Placa = 'P123XYZ',
    @Modelo = '2023',
    @IdLinea = 1,
    @IdMarca = 1,
    @IdResidente = 1,
    @IdVisitante = 1;