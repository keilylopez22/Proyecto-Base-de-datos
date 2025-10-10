CREATE OR ALTER PROCEDURE EliminarAsignacioTurno
@IdAsignacionTurno INT
AS
BEGIN DELETE FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno;
END;

EXEC EliminarAsignacioTurno
@IdAsignacionTurno = 3