CREATE OR ALTER PROCEDURE PSBuscarPuestoTrabajoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN
SELECT * FROM PuestoTrabajo
WHERE Descripcion = @Descripcion
END

EXEC PSBuscarPuestoTrabajoPorDescripcion
@Descripcion = 'Guardia de Seguridad'

