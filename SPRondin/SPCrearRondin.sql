CREATE OR ALTER PROCEDURE CrearRondin
@FechaInicio DATE,
@FechaFin DATE,
@IdEmpleado INT
AS
BEGIN
INSERT INTO Rondin (FechaInico, FechaFin, IdEmpleado)
VALUES (@FechaInicio, @FechaFin, @IdEmpleado);
END;

EXEC CrearRondin
@FechaInicio = '2025-10-10',
@FechaFin = '2025-10-10',
@IdEmpleado = 5;

