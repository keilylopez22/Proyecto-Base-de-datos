-- =Buscar tipo de pago por ID
Create OR Alter Procedure BuscarTipoPagoPorID
@idTipoPago int 
AS

Begin 
	Select idTipoPago, Nombre, Descripcion
	from TipoPago
	Where  idTipoPago = @idTipoPago 

END;
Exec BuscarTipoPagoPorId
@idTipoPago = 1

