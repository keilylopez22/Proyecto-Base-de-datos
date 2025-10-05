CREATE OR ALTER PROCEDURE ObtenerPuestoTrabajoPorID
@IdPuestoTrabajo INT
AS
BEGIN
SELECT @IdPuestoTrabajo, Descripcion
FROM PuestoTrabajo
WHERE IdPuestoTrabajo = @IdPuestoTrabajo;
END

EXEC ObtenerPuestoTrabajoPorId 
@IdPuestoTrabajo = 3;
