CREATE OR ALTER PROCEDURE SP_EliminarAsignacionTurno
@IdAsignacionTurno INT
AS
BEGIN
DELETE FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno
END

EXEC SP_EliminarAsignacionTurno
@IdAsignacionTurno = 1
