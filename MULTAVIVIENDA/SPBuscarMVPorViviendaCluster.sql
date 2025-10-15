--busca multa de vivienda por numero de vivienda y cluster 
CREATE OR ALTER PROCEDURE	BuscarMVPorViviendaCluster
@NumeroVivienda int,
@IdCluster int 
AS
BEGIN 
		SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, NumeroVivienda, IdCluster
		FROM MultaVivienda
		WHERE NumeroVivienda = @NumeroVivienda AND IdCluster= @IdCluster

END;
GO
EXEC BuscarMVPorViviendaCluster
@NumeroVivienda = 101,
@IdCluster =1 
select * from MultaVivienda