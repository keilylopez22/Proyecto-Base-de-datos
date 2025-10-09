

-- =Buscar tipo de pago por ID
Create OR Alter Procedure BuscarTipoPagoPorID
@IdTipoPago int 
AS

Begin 
	Select IdTipoPago, Descripcion
	from TipoPago
	Where  IdTipoPago = @IdTipoPago 

END;
Exec BuscarTipoPagoPorId
@IdTipoPago = 2

