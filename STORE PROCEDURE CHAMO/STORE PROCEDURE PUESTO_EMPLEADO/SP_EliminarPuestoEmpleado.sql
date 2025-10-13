CREATE OR ALTER PROCEDURE SP_EliminarPuestoEmpleado
@IdPuestoEmpleado INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN 
RAISERROR('No existe este puestp',16,1)
RETURN
END

IF EXISTS (SELECT 1 FROM Empleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se puede eliminar este puesto porque hay empleados asignados',16,1)
RETURN
END

DELETE FROM PuestoEmpleado
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

EXEC SP_EliminarPuestoEmpleado
@IdPuestoEmpleado = 1
