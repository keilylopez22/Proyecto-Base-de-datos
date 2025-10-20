CREATE OR ALTER PROCEDURE SP_ActualizarVehiculoProhibido
@IdVehiculoProhibido INT,
@Fecha DATE,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN
RAISERROR('El vehiculo no existe en la lista de prohibidos',16,1)
RETURN
END

UPDATE VehiculoProhibido
SET Fecha = @Fecha,
Motivo = @Motivo,
IdVehiculo = @IdVehiculo
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'Vehiculo Prohibido actualizado exitosamente'
END

EXEC SP_ActualizarVehiculoProhibido
@IdVehiculoProhibido = 3,
@Fecha = '2025-10-13',
@Motivo = 'Estacionamiento indebido',
@IdVehiculo = 3;
