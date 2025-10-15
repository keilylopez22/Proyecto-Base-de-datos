-- Buscar recibos por fecha de emision 
Create OR Alter Procedure BuscarReciboPorFecha
@FechaEmision date 
AS
Begin 
	Select IdRecibo, FechaEmision
	from Recibo
	Where  FechaEmision = @FechaEmision 

END;
GO
Exec BuscarReciboPorFecha
@FechaEmision = '2025-10-12'
select * from Recibo
