CREATE OR ALTER PROCEDURE ObtenerTurnoPorId
@IdTurno INT
AS
BEGIN
SELECT IdTurno, Descripcion, HoraInicio, HoraFin, IdPuestoTrabajo 
FROM Turno
WHERE IdTurno = @IdTurno;
END 

EXEC ObtenerTurnoPorId
@IdTurno = 1