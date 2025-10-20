CREATE OR ALTER PROCEDURE PS_ObtenerEmpleadosPorPuesto
@IdPuestoEmpleado INT
AS
BEGIN
   SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreEmpleado, pe.Nombre AS Puesto FROM Persona AS p
   INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
   INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
   WHERE e.IdPuestoEmpleado = @IdPuestoEmpleado
END

EXEC PS_ObtenerEmpleadosPorPuesto
@IdPuestoEmpleado = 1