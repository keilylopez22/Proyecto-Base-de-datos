CREATE OR ALTER PROCEDURE SP_CrearPuestoEmpleado
@Nombre VARCHAR(50),
@Descripcion varchar(50)
AS
BEGIN

SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM PuestoEmpleado WHERE Nombre = @Nombre)
BEGIN
RAISERROR('Ya hay un puesto con ese nombre',16,1)
RETURN
END

INSERT INTO PuestoEmpleado(Nombre, Descripcion)
VALUES (@Nombre, @Descripcion)
END

EXEC SP_CrearPuestoEmpleado
@Nombre = 'Guardia',
@Descripcion = 'Encargado de patrullar los clusters'
