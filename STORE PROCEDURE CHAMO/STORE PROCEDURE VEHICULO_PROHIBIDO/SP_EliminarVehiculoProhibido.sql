CREATE OR ALTER PROCEDURE SP_EliminarVehiculoProhibido
@IdVehiculoProhibido INT
AS
BEGIN
DELETE FROM VehiculoProhibido
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

EXEC SP_EliminarVehiculoProhibido
@IdVehiculoProhibido = 1;