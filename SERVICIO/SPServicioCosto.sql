
-- Buscar servicIo  por valor 
Create OR Alter Procedure BuscarServicioValor
@Tarifa int 
AS
Begin 
	Select IdServicio,Tarifa, Nombre 
	from Servicio
	Where  Tarifa = @Tarifa 

END;
GO
Exec BuscarServicioValor
@Tarifa = 75
SELECT * FROM Servicio 