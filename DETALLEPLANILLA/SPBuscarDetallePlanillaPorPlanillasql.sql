--busca el detalle de la planila por el numero de planilla
Create OR Alter Procedure BuscarDetallePlanillaPorPlanilla
@IdPlanilla int
AS

Begin 
	Select @IdPlanilla AS NumeroPlanilla , NumeroVivienda
	from DetallePlanilla
	Where  IdPlanilla = @IdPlanilla 

END;
GO
Exec BuscarDetallePlanillaPorPlanilla
@IdPlanilla = 8

select * from DetallePlanilla