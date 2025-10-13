CREATE OR ALTER PROCEDURE SP_EliminarAsignacionTurno
@IdAsignacionTurno INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdAsignacionTurno = @IdAsignacionTurno)
BEGIN
RAISERROR('No se encontro la asiganacion',16,1)
RETURN
END

DELETE FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno
END 

EXEC SP_EliminarAsignacionTurno
@IdAsignacionTurno = 12

