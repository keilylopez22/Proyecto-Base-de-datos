CREATE OR ALTER PROCEDURE SP_InsertarVehiculoProhibido
@Fecha DATE,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
INSERT INTO VehiculoProhibido(Fecha, Motivo, IdVehiculo)
VALUES(@Fecha, @Motivo, @IdVehiculo)
END

EXEC SP_InsertarVehiculoProhibido
@Fecha = '2025-10-10',
@Motivo = 'Exceso de velocidad en area comunitaria',
@IdVehiculo = 1

