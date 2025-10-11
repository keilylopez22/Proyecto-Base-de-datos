CREATE OR ALTER PROCEDURE SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado INT,
@Nombre VARCHAR(50),
@Descripcion VARCHAR(50)
AS
BEGIN UPDATE PuestoEmpleado
SET Nombre = @Nombre,
Descripcion = @Descripcion
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END
GO

EXEC SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado = 1,
@Nombre = '',
@Descripcion = ''
