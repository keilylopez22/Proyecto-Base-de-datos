CREATE OR ALTER PROCEDURE InsertarRegistroAccesos
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado)
    VALUES (@FechaIngreso, @FechaSalida, @IdVehiculo, @IdGarita, @IdVisitante, @IdResidente, @IdEmpleado)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarRegistroAccesos
    @FechaIngreso = '2024-10-11 14:00:00',
    @FechaSalida = '2024-10-11 16:00:00',
    @IdVehiculo = 1,
    @IdGarita = 1,
    @IdVisitante = NULL,
    @IdResidente = 1,
    @IdEmpleado = 1;