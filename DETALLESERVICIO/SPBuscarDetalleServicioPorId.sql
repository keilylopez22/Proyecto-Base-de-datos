--buscar Detalle servicio por id 
Create OR Alter Procedure BuscarDetalleServicioPorId
@IdDetalleServicio int
AS

Begin 
	Select @IdDetalleServicio AS IdDetalleServicio , Valor,IdRequerimientoC, IdRecibo
	from DetalleServicio
	Where  IdDetalleServicio = @IdDetalleServicio 

END;
GO
Exec BuscarDetalleServicioPorId
@IdDetalleServicio = 5

select * from  DetalleServicio 

