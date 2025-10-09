-- Buscar recibos por fecha 
Create OR Alter Procedure BuscarReciboPorFecha
@Fecha date 
AS
Begin 
	Select IdRecibo, @Fecha AS Fecha, ValorTotal,IdTipoPago, NumeroVivienda,IdCluster
	from Recibo
	Where  Fecha = @Fecha 

END;
GO
Exec BuscarReciboPorFecha
@Fecha = '2025-10-05'
select * from Recibo
