CREATE PROCEDURE PSBuscarAsignacionTurnoPorEmpleado
@IdEmpleado INT 
AS
BEGIN
SELECT st.FechaAsignacion, st.IdTurno, t.Descripcion, p.PrimerNombre + ' ' + p.PrimerApellido AS 'Nombre Empleado' FROM AsignacionTurno AS st
INNER JOIN Turno t ON st.IdTurno = t.IdTurno
INNER JOIN Empleado e ON st.IdEmpleado = e.IdEmpleado
INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado
END

EXEC PSBuscarAsignacionTurnoPorEmpleado
@IdEmpleado = 3


