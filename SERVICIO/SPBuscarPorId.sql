
-- Buscar servico  por id 
Create OR Alter Procedure BuscarServicioId
@IdServicio int 
AS

Begin 
	Select IdServicio,Nombre, Tarifa
	from Servicio
	Where  IdServicio = @IdServicio 

END;
Exec BuscarServicioId
@IdServicio = 2
