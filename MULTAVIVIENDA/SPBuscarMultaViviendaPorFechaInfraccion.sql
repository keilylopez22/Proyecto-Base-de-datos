--busca multa de vivienda por fecha de la infraccion 
CREATE OR ALTER PROCEDURE BuscarMultaViviendaPorFechaInfraccion 
@FechaInfraccion DATE
AS
BEGIN
	SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster
	FROM MultaVivienda
	WHERE FechaInfraccion = @FechaInfraccion
END;
GO
EXEC BuscarMultaViviendaPorFechaInfraccion
@FechaInfraccion = '2024-09-05' 

select * from MultaVivienda