--buscar requerimiento de cobro por servicio y numero de viviendad 
Create OR Alter Procedure BuscarRCPorServicioYNumeroVivienda 
@IdServicio int,
@NumeroVivienda int 
AS

Begin 
	Select  @IdServicio AS IdServicio, @NumeroVivienda AS NumeroVivienda
	from RequerimientoCobro
	Where  IdServicio = @IdServicio and NumeroVivienda = @NumeroVivienda 

END;
GO
Exec BuscarRCPorServicioYNumeroVivienda
@IdServicio = 4,
@NumeroVivienda = 26

select * from  RequerimientoCobro 