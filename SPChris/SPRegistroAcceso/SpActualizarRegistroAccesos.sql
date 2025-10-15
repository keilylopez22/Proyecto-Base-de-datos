CREATE OR ALTER PROCEDURE ActualizarRegistroAccesos
    @IdRegistroAcceso INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    UPDATE RegistroAccesos 
    SET FechaIngreso = @FechaIngreso,
        FechaSalida = @FechaSalida,
        IdVehiculo = @IdVehiculo,
        IdGarita = @IdGarita,
        IdVisitante = @IdVisitante,
        IdResidente = @IdResidente,
        IdEmpleado = @IdEmpleado
    WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarRegistroAccesos
    @IdRegistroAcceso = 1,
    @FechaIngreso = '2024-10-09 07:00:00',
    @FechaSalida = '2024-10-09 17:30:00',
    @IdVehiculo = 1,
    @IdGarita = 1,
    @IdVisitante = NULL,
    @IdResidente = 1,
    @IdEmpleado = 1;