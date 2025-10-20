CREATE OR ALTER PROCEDURE ActualizarRondin
@IdRondin INT,
@FechaInicio DATE,
@FechaFin DATE,
@IdEmpleado INT 
AS
BEGIN
UPDATE Rondin
SET FechaInico = @FechaInicio,
FechaFin = @FechaFin,
IdEmpleado = @IdEmpleado
WHERE IdRondin = @IdRondin;
END;

EXEC ActualizarRondin
@IdRondin = 3,
@FechaInicio = '2025-10-03',
@FechaFin = '2025-10-06',
@IdEmpleado = 5;


