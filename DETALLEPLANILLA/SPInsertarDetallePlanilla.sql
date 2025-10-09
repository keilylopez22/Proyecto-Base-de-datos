
CREATE OR ALTER PROCEDURE InsertarDetallePlanilla
@IdPlanilla int,
@NumeroVivienda int,
@IdCluster int

AS
BEGIN
	SET NOCOUNT ON;
	insert DetallePlanilla (IdPlanilla, NumeroVivienda, IdCluster )
	VALUES (@IdPlanilla, @NumeroVivienda, @IdCluster)
	SELECT SCOPE_IDENTITY() AS IdDetallePlanilla

END
GO
exec InsertarDetallePlanilla
@IdPlanilla = 8,
@NumeroVivienda = 524,
@IdCluster = 5

select *from planilla
select *from DetallePlanilla
select *from Vivienda
select *from Cluster