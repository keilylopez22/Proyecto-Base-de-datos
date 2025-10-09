
-- =Buscar planilla por descripcion 
Create OR Alter Procedure BuscarPlanillaDescripcion 
@Descripcion  varchar(100) 
AS

Begin 
	 SELECT P.Descripcion,
	        P.IdPlanilla,
            P.Fecha,
            P.IdRecibo
    FROM Planilla P
	Where  Descripcion = @Descripcion 

END;
GO
Exec BuscarPlanillaDescripcion
@Descripcion = 'Planilla mensual de octubre '