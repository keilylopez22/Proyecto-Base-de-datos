--busca el detalle de la planila por el id 
Create OR Alter Procedure BuscarDetallePlanillaPorId
@IdDetallePlanilla int
AS

Begin 
	Select @IdDetallePlanilla AS IdDetallePlanilla ,NumeroVivienda, IdCluster,IdPlanilla
	from DetallePlanilla
	Where  IdDetallePlanilla = @IdDetallePlanilla 

END;
GO
Exec BuscarDetallePlanillaPorId
@IdDetallePlanilla = 5

select * from Vivienda