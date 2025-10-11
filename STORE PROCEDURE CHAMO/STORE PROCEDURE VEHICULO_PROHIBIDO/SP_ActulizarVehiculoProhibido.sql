CREATE OR ALTER PROCEDURE SP_ActulizarVehiculoProhibido
@IdVehiculoProhibido INT,
@Fecha DATE,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
UPDATE VehiculoProhibido
SET Fecha = @Fecha,
Motivo = @Motivo,
IdVehiculo = @IdVehiculo
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

EXEC SP_ActulizarVehiculoProhibido
@IdVehiculoProhibido = 3,
@Fecha = '',
@Motivo = '',
@IdVehiculo = 3