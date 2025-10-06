-- 1. Insertar en Vehiculo
CREATE OR ALTER PROCEDURE InsertarVehiculo
    @Placa VARCHAR(10),
    @Modelo VARCHAR(30),
    @IdLinea INT,
    @IdMarca INT,
    @IdResidente INT,
    @IdVisitante INT
AS
BEGIN
    INSERT INTO Vehiculo (Placa, Modelo, IdLinea, IdMarca, IdResidente, IdVisitante)
    VALUES (@Placa, @Modelo, @IdLinea, @IdMarca, @IdResidente, @IdVisitante)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarVehiculo
    @Placa = 'TEST001',
    @Modelo = '2024',
    @IdLinea = 1,
    @IdMarca = 1,
    @IdResidente = 11,
    @IdVisitante = 11;
