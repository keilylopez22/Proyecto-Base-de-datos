CREATE OR ALTER PROCEDURE ObtenerAsignacionTurno
@IdAsignacioTurno INT
AS
BEGIN
SELECT IdAsignacionTurno, FechaAsignacion, IdEmpleado, IdTurno
FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacioTurno
END

EXEC ObtenerAsignacionTurno
@IdAsignacioTurno = 2

SELECT * FROM AsignacionTurno