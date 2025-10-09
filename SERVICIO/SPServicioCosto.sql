
-- Buscar servicIo  por valor 
Create OR Alter Procedure BuscarServicioValor
@Valor int 
AS
Begin 
	Select @Valor AS Costo, Descripcion 
	from Servicio
	Where  Valor = @Valor 

END;
GO
Exec BuscarServicioValor
@Valor = 75