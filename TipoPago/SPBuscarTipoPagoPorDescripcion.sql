
--Buscar tipo de pago
Create OR Alter Procedure BuscarTipoPagoPorDescripcion 
@Descripcion VARCHAR (75)
AS

Begin 
	Select Descripcion--,IdTipoPago
	from TipoPago
	Where  Descripcion = @Descripcion 

END;
Exec BuscarTipoPagoPorDescripcion
@Descripcion = Efectivo