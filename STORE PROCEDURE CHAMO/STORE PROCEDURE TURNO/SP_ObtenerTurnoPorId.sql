CREATE OR ALTER PROCEDURE SP_ObtenerTurnoPorId
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN
RAISERROR('No existe este turno',16,1)
RETURN
END

SELECT IdTurno, Descripcion, HoraInicio, HoraFin 
FROM Turno
WHERE IdTurno = @IdTurno;
END 

EXEC SP_ObtenerTurnoPorId
@IdTurno = 1