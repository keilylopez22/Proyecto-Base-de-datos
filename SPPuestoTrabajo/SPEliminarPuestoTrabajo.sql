CREATE OR ALTER PROCEDURE EliminarPuestoTrabajo
@IdPuestoTrabajo INT
AS
BEGIN
DELETE PuestoTrabajo
WHERE IdPuestoTrabajo = @IdPuestoTrabajo;
END

EXEC EliminarPuestoTrabajo
@IdPuestoTrabajo = 10
