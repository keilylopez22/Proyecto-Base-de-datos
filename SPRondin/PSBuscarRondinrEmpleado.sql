CREATE PROCEDURE SPBuscarRondinrEmpleado
@IdEmpleado INT 
AS
BEGIN
SELECT r.IdRondin, FechaInico, r.FechaFin,  p.PrimerNombre + ' ' + p.PrimerApellido AS 'Nombre Empleado' FROM Rondin AS r
INNER JOIN Empleado e ON r.IdEmpleado = e.IdEmpleado
INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado
END

EXEC SPBuscarRondinrEmpleado
@IdEmpleado = 3