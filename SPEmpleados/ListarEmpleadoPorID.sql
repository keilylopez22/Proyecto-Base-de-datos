CREATE OR ALTER PROCEDURE BuscarEmpleadoPorID
@IdEmpleado INT
AS
BEGIN
SELECT e.IdEmpleado, e.IdPersona 
FROM Empleado AS e
WHERE e.IdEmpleado = @IdEmpleado;
END

EXEC BuscarEmpleadoPorID
@IdEmpleado = 6