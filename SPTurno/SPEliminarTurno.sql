CREATE OR ALTER PROCEDURE EliminarTurno
@IdTurno INT
AS
BEGIN
DELETE FROM Turno
WHERE IdTurno = @IdTurno
END

EXEC EliminarTurno
@IdTurno = 3	