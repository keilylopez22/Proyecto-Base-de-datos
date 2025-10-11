CREATE OR ALTER PROCEDURE SP_ObtenerAsignacionTurnoPorId
@IdAsignacionTurno INT
AS
BEGIN
SELECT *
FROM AsignacionTurno AS st
WHERE st.IdAsignacionTurno = @IdAsignacionTurno
END

EXEC SP_ObtenerAsignacionTurnoPorId
@IdAsignacionTurno = 1
