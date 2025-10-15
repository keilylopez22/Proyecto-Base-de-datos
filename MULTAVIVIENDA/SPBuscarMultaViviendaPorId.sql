--busca multa de las viviendad por id 
CREATE OR ALTER PROCEDURE BuscarMultaViviendaPorId 
@IdMultaVivienda int
AS
BEGIN
	SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster
	FROM MultaVivienda
	WHERE IdMultaVivienda = @IdMultaVivienda
END;
GO
EXEC BuscarMultaViviendaPorId
@IdMultaVivienda = 5
select * from MultaVivienda