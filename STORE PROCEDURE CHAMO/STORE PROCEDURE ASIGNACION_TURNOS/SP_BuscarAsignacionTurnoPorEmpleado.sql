CREATE PROCEDURE SP_BuscarAsignacionTurnoPorEmplead
@IdEmpleado INT 
AS
BEGIN 
SELECT st.FechaAsignacion, st.IdTurno, e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS 'Nombre Empleado' FROM AsignacionTurno AS st
INNER JOIN Empleado e ON st.IdEmpleado = e.IdEmpleado
INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado
END

EXEC SP_BuscarAsignacionTurnoPorEmplead
@IdEmpleado = 3


