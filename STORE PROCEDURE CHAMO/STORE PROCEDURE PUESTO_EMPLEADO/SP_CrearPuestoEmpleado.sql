CREATE OR ALTER PROCEDURE SP_CrearPuestoEmpleado
@Nombre VARCHAR(50),
@Descripcion varchar(50)
AS
BEGIN
INSERT INTO PuestoEmpleado(Nombre, Descripcion)
VALUES (@Nombre, @Descripcion)
END

EXEC SP_CrearPuestoEmpleado
@Nombre = '',
@Descripcion = ''