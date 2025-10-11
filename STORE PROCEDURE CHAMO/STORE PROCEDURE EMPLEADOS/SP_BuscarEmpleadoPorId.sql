CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorId
@IdEmpleado INT
AS
BEGIN
SELECT e.IdEmpleado, e.IdPersona 
FROM Empleado AS e
WHERE e.IdEmpleado = @IdEmpleado;
END

EXEC SP_BuscarEmpleadoPorId
@IdEmpleado = 1