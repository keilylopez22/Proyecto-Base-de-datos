-- Buscar servicIo  por valor 
Create OR Alter Procedure BuscarPagoPorMonto
@MontoTotal decimal 
AS
Begin 
	Select IdPago, FechaPago,  MontoTotal, referencia
	from Pago
	Where  MontoTotal >= @MontoTotal 

END;
GO
Exec BuscarPagoPorMonto
@MontoTotal = 200
select * from  Pago