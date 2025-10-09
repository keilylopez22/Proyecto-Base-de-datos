
-- Buscar servico  por id 
Create OR Alter Procedure BuscarServicioId
@IdServicio int 
AS

Begin 
	Select @IdServicio AS NumeroServicio, Descripcion, Valor
	from Servicio
	Where  IdServicio = @IdServicio 

END;
Exec BuscarServicioId
@IdServicio = 2