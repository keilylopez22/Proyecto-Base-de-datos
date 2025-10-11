CREATE OR ALTER PROCEDURE SP_CrearAsignacionTurno
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN
INSERT INTO AsignacionTurno(FechaAsignacion, IdEmpleado, IdTurno)
VALUES(@FechaAsignacion,@IdEmpleado, @IdTurno)
END

EXEC SP_CrearAsignacionTurno
@FechaAsignacion = '2025-10-02',
@IdEmpleado = 6,
@IdTurno = 1
