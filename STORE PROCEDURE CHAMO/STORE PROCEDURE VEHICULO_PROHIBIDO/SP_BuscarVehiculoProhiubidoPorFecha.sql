CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorFecha
@Fecha DATE
AS
BEGIN
SELECT vp.IdVehiculoProhibido, vp.Fecha, vp.Motivo, v.IdVehiculo, v.Placa, m.Descripcion AS Marca FROM VehiculoProhibido AS vp
INNER JOIN Vehiculo v ON vp.IdVehiculo = v.IdVehiculo
INNER JOIN Marca m ON v.IdMarca = M.IdMarca
WHERE vp.Fecha = @Fecha
END

EXEC SP_BuscarVehiculoProhiubidoPorFecha
@Fecha = '2025-10-10'