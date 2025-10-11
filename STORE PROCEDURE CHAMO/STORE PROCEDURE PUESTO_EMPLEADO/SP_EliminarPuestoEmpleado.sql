CREATE OR ALTER PROCEDURE SP_EliminarPuestoEmpleado
@IdPuestoEmpleado INT
AS
BEGIN
DELETE FROM PuestoEmpleado
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

EXEC SP_EliminarPuestoEmpleado
@IdPuestoEmpleado = 1
