CREATE PROCEDURE SPBuscarRondinrPorFecha
@FechaInicio DATE,
@FechaFin DATE
AS
BEGIN
SELECT r.IdRondin, r.FechaInico, r.FechaFin,  p.PrimerNombre + ' ' + p.PrimerApellido AS 'Nombre Empleado' FROM Rondin AS r
INNER JOIN Empleado e ON r.IdEmpleado = e.IdEmpleado
INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
WHERE FechaInico = @FechaInicio AND FechaFin = @FechaFin
END

EXEC SPBuscarRondinrPorFecha
@FechaInicio = '2025-10-01',
@FechaFin = '2025-10-01'
