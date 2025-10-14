CREATE OR ALTER PROCEDURE SP_InsertarVehiculoProhibido
@Fecha DATE = NULL,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Vehiculo WHERE IdVehiculo = @IdVehiculo)
BEGIN 
RAISERROR('El vehicuilo que intenta ingresar en la lista de prohibidos no exsite',16,1)
RETURN 
END

IF EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculo = @IdVehiculo AND (Fecha IS NULL OR FECHA >= CAST(GETDATE() AS DATE)))
BEGIN
RAISERROR('El vehiculo ya se encuentra prohibido y no puede ser prohibido de nuevo  hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO VehiculoProhibido(Fecha, Motivo, IdVehiculo)
VALUES(@Fecha, @Motivo, @IdVehiculo)
PRINT 'Vehiculo ingresado correctamente en la lista de vehiculos prohibidos'
END

EXEC SP_InsertarVehiculoProhibido
@Fecha = '2025-10-10',
@Motivo = 'Exceso de velocidad en area comunitaria',
@IdVehiculo = 1


