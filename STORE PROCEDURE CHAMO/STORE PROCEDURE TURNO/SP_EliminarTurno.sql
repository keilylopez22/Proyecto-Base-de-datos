CREATE OR ALTER PROCEDURE SP_EliminarTurno
@IdTurno INT
AS
BEGIN
DELETE FROM Turno
WHERE IdTurno = @IdTurno
END

EXEC SP_EliminarTurno
@IdTurno = 1
