CREATE PROCEDURE SP_BuscaAsignacionTurnoPorFecha
@FechaAsignacion DATE
AS
BEGIN
SELECT st.FechaAsignacion, st.IdTurno, t.Descripcion AS Turno FROM AsignacionTurno AS st
INNER JOIN Turno t ON st.IdTurno = t.IdTurno
WHERE FechaAsignacion = @FechaAsignacion
END

EXEC SP_BuscaAsignacionTurnoPorFecha
@FechaAsignacion = '2025-10-01'