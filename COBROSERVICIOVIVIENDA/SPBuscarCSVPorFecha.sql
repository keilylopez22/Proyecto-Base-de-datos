--Buscar cobro servicio vivienda  por fecha 
CREATE OR ALTER PROCEDURE BuscarCSVPorFecha
@FechaCobro date 
AS
BEGIN
	Select  FechaCobro,Monto, MontoAplicado,EstadoPago, IdServicio,NumeroVivienda, IdCluster
    FROM CobroServicioVivienda
    WHERE FechaCobro = @FechaCobro
    ORDER BY FechaCobro;
END;
GO
EXEC BuscarCSVPorFecha
@FechaCobro = '2024-09-01'


Select * from  CobroServicioVivienda