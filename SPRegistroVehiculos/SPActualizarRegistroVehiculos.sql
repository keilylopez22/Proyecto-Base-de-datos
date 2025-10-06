--Actualizar RegistroVehiculos
CREATE OR ALTER PROCEDURE ActualizarRegistroVehiculos
    @IdRegistroVehiculo INT,
    @FechaHoraEntrada DATE,
    @FechaHoraSalida DATE,
    @Observaciones VARCHAR(50),
    @IdGarita INT,
    @IdVehiculo INT,
    @IdVisitante INT,
    @IdResidente INT
AS
BEGIN
    UPDATE RegistroVehiculos 
    SET FechaHoraEntrada = @FechaHoraEntrada,
        FechaHoraSalida = @FechaHoraSalida,
        Observaciones = @Observaciones,
        IdGarita = @IdGarita,
        IdVehiculo = @IdVehiculo,
        IdVisitante = @IdVisitante,
        IdResidente = @IdResidente
    WHERE IdRegistroVehiculo = @IdRegistroVehiculo
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarRegistroVehiculos
    @IdRegistroVehiculo = 1,
    @FechaHoraEntrada = '2025-10-01 08:30:00',
    @FechaHoraSalida = '2025-10-01 10:00:00',
    @Observaciones = 'Visita a Lote 25 - ACTUALIZADO',
    @IdGarita = 1,
    @IdVehiculo = 1,
    @IdVisitante = 1,
    @IdResidente = 1;