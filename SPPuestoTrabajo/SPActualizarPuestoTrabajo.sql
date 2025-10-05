CREATE OR ALTER PROCEDURE ActualizarPuestoTrabajo
@IdPuestoTrabajo INT,
@Descripcion VARCHAR(50)
AS
BEGIN
UPDATE PuestoTrabajo
SET Descripcion = @Descripcion
WHERE IdPuestoTrabajo = @IdPuestoTrabajo;
END

EXEC ActualizarPuestoTrabajo
@IdPuestoTrabajo = 2,
@Descripcion = 'Supervisor de Seguridad'

SELECT * FROM PuestoTrabajo