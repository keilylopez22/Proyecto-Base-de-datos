-- =Buscar pago por ID
Create OR Alter Procedure BuscarPagoPorID
@IdPago int 
AS

Begin 
	Select IdPago, FechaPago, MontoTotal, idTipoPago, Referencia
	from Pago
	Where  IdPago = @IdPago 

END;
Go
Exec BuscarPagoPorID
@IdPago = 3
