--busca el detalle de la planila por el numero de vivienda 
Create OR Alter Procedure BuscarDetallePlanillaPorNumeroVivienda
@NumeroVivienda int
AS

Begin 
	Select @NumeroVivienda AS NumeroVivienda , IdCluster
	from DetallePlanilla
	Where  NumeroVivienda = @NumeroVivienda 

END;
GO
Exec BuscarDetallePlanillaPorNumeroVivienda
@NumeroVivienda = 311

select * from DetallePlanilla