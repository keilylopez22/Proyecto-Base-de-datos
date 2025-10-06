CREATE PROCEDURE PSBuscarAsignacionTurnoPorFecha
@FechaAsignacion DATE
AS
BEGIN
SELECT st.FechaAsignacion, st.IdTurno, t.Descripcion FROM AsignacionTurno AS st
INNER JOIN Turno t ON st.IdTurno = t.IdTurno
WHERE FechaAsignacion = @FechaAsignacion
END

EXEC PSBuscarAsignacionTurnoPorFecha
@FechaAsignacion = '2025-10-01'