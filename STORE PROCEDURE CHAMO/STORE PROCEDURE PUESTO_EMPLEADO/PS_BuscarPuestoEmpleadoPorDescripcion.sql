CREATE OR ALTER PROCEDURE PS_BuscarPuestoEmpleadoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN
   SELECT IdPuestoEmpleado, Nombre, Descripcion
   FROM PuestoEmpleado
   WHERE Descripcion = @Descripcion
END

EXEC PS_BuscarPuestoEmpleadoPorDescripcion
@Descripcion = 'Personal encargado del jardín y áreas comunes'
