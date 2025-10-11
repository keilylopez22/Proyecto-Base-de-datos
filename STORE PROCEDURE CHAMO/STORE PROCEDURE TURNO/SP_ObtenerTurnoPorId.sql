CREATE OR ALTER PROCEDURE SP_ObtenerTurnoPorId
@IdTurno INT
AS
BEGIN
SELECT IdTurno, Descripcion, HoraInicio, HoraFin 
FROM Turno
WHERE IdTurno = @IdTurno;
END 

EXEC SP_ObtenerTurnoPorId
@IdTurno = 1