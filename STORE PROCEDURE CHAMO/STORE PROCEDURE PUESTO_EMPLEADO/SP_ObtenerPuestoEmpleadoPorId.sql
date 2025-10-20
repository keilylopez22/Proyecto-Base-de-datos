CREATE OR ALTER PROCEDURE SP_ObtenerPuestoEmpleadoPorId
@IdPuestoEmpleado INT
AS
BEGIN
SELECT * FROM PuestoEmpleado AS pe
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

EXEC SP_ObtenerPuestoEmpleadoPorId
@IdPuestoEmpleado = 1
