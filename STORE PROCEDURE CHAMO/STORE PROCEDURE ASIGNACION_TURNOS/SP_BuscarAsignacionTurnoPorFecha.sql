CREATE OR ALTER PROCEDURE SP_BuscarAsignacionTurnoPorFecha
@FechaAsignacion DATE
AS
BEGIN
SELECT st.IdAsignacionTurno, st.FechaAsignacion, t.Descripcion AS Turno
FROM AsignacionTurno st
INNER JOIN Turno t ON st.IdTurno = t.IdTurno
WHERE st.FechaAsignacion = @FechaAsignacion
END

EXEC SP_BuscarAsignacionTurnoPorFecha
@FechaAsignacion = ''