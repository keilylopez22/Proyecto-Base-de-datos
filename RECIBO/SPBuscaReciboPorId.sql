
-- buscar recibos por id

Create OR Alter Procedure BuscarReciboPorId
@IdRecibo int 
AS

Begin 
	Select IdRecibo, FechaEmision, IdPago
	from Recibo
	Where  IdRecibo = @IdRecibo 

END;
GO
Exec BuscarReciboPorId
@IdRecibo = 5
