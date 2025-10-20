CREATE OR ALTER PROCEDURE CrearAsignacionTurno
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN
INSERT INTO AsignacionTurno(FechaAsignacion, IdEmpleado, IdTurno)
VALUES(@FechaAsignacion,@IdEmpleado, @IdTurno);
END

EXEC CrearAsignacionTurno
@FechaAsignacion = '2025-10-02',
@IdEmpleado = 6,
@IdTurno = 1;
