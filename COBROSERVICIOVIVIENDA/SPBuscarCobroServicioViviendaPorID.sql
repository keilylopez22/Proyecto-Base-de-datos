--buscar cobro servicio vivienda por id 
Create OR Alter Procedure BuscarCobroServicioPorViviendaPorId
@idCobroServicio int
AS

Begin 
	Select  idCobroServicio, FechaCobro, Monto, MontoAplicado, EstadoPago, IdServicio, NumeroVivienda, IdCluster
	from CobroServicioVivienda
	Where  idCobroServicio = @idCobroServicio 

END;
GO
Exec BuscarCobroServicioPorViviendaPorId
@idCobroServicio = 5

select * from  CobroServicioVivienda 