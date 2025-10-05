CREATE OR ALTER PROCEDURE ObtenerAsignacionTurnoPoID
@IdAsignacioTurno INT
AS
BEGIN
SELECT IdAsignacionTurno, FechaAsignacion, IdEmpleado, IdTurno
FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacioTurno
END

EXEC ObtenerAsignacionTurnoPoID
@IdAsignacioTurno = 2