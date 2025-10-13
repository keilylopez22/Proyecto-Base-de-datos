CREATE OR ALTER PROCEDURE SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado INT,
@Nombre VARCHAR(50),
@Descripcion VARCHAR(50)
AS 
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se encontro el puesto de empleado',16,1)
RETURN
END

UPDATE PuestoEmpleado
SET Nombre = @Nombre,
Descripcion = @Descripcion
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

EXEC SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado = 1,
@Nombre = '',
@Descripcion = ''
