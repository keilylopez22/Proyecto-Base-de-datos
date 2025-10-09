-- buscar Detalle servico por recibo

Create OR Alter Procedure BuscarDSPorRecibo
@IdRecibo int 
AS

Begin 
	Select @IdRecibo as NumeroRecibo,valor , Valor, IdRequerimientoC
	from DetalleServicio
	Where  IdRecibo = @IdRecibo 

END;
GO
Exec BuscarDSPorRecibo
@IdRecibo = 5

select * from DetalleServicio