--Insertar en RegistroVehiculos
CREATE OR ALTER PROCEDURE InsertarRegistroVehiculos
    @FechaHoraEntrada DATE,
    @FechaHoraSalida DATE,
    @Observaciones VARCHAR(50),
    @IdGarita INT,
    @IdVehiculo INT,
    @IdVisitante INT,
    @IdResidente INT
AS
BEGIN
    INSERT INTO RegistroVehiculos (FechaHoraEntrada, FechaHoraSalida, Observaciones, IdGarita, IdVehiculo, IdVisitante, IdResidente)
    VALUES (@FechaHoraEntrada, @FechaHoraSalida, @Observaciones, @IdGarita, @IdVehiculo, @IdVisitante, @IdResidente)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarRegistroVehiculos
    @FechaHoraEntrada = '2025-10-11 08:00:00',
    @FechaHoraSalida = '2025-10-11 10:00:00',
    @Observaciones = 'Nueva visita de prueba',
    @IdGarita = 1,
    @IdVehiculo = 1,
    @IdVisitante = 1,
    @IdResidente = 1;