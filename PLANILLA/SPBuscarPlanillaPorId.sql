
-- =Buscar panilla por id 
Create OR Alter Procedure BuscarPlanillaID
@IdPlanilla int 
AS

Begin 
	Select @IdPlanilla AS NumeroDePlanila, Descripcion, Fecha, IdRecibo
	from Planilla
	Where  IdPlanilla = @IdPlanilla 

END;
Exec BuscarPlanillaID
@IdPlanilla = 2