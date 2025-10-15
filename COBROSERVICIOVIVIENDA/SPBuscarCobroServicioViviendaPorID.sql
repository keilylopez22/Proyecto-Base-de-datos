--buscar requerimiento de cobro por id 
Create OR Alter Procedure BuscarRCPorId
@IdRequerimientoC int
AS

Begin 
	Select @IdRequerimientoC AS IdRequerimientoC ,Fecha, IdServicio,NumeroVivienda, IdCluster
	from RequerimientoCobro
	Where  IdRequerimientoC = @IdRequerimientoC 

END;
GO
Exec BuscarRCPorId
@IdRequerimientoC = 5

select * from  RequerimientoCobro 