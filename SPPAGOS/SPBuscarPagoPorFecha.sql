-- Buscar pagos por fecha 
Create OR Alter Procedure BuscarPagoPorFecha
@FechaPago date 
AS
Begin 
	Select FechaPago, MontoTotal,IdTipoPago, Referencia
	from Pago
	Where  FechaPago = @FechaPago 

END;
GO
Exec BuscarPagoPorFecha
@FechaPago = '2024-08-20'
select * from Pago