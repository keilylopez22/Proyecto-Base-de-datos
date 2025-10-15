
--Buscar tipo de pago
Create OR Alter Procedure BuscarTipoPagoPorNombre 
@Nombre VARCHAR (50)
AS

Begin 
	Select Nombre, Descripcion
	from TipoPago
	Where  Nombre = @Nombre 

END;
Exec BuscarTipoPagoPorNombre
@Nombre = 'Efectivo'
select * from TipoPago
