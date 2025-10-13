CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorId
@IdVehiculoProhibido INT
AS
BEGIN
SELECT * FROM VehiculoProhibido 
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

EXEC SP_BuscarVehiculoProhiubidoPorId
@IdVehiculoProhibido = 1
