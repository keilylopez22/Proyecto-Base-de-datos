CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorId
@IdEmpleado INT
AS
BEGIN
SELECT e.IdEmpleado, e.IdPersona, p.PrimerNombre, p.PrimerApellido
FROM Empleado AS e
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado;
END

EXEC SP_BuscarEmpleadoPorId
@IdEmpleado = 1