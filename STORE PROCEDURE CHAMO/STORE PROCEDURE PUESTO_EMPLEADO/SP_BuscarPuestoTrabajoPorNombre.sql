CREATE OR ALTER PROCEDURE SP_BuscarPuestoTrabajoPorNombre
@Nombre VARCHAR(50)
AS
BEGIN
SELECT * FROM PuestoEmpleado
WHERE Nombre = @Nombre
END

EXEC SP_BuscarPuestoTrabajoPorNombre
@Nombre = ''
