
-- Buscar servicIo  por valor 
Create OR Alter Procedure BuscarDSPorValor
@Valor decimal (18,2) 
AS
Begin 
	Select Valor,IdRequerimientoC, IdRecibo
	from DetalleServicio
	Where  Valor >= @Valor 

END;
GO
Exec BuscarDSPorValor
@Valor = 115
select * from  DetalleServicio 