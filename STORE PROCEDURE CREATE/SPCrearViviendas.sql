--
Create  OR ALTER Procedure CrearVivienda
--Parametros de entrada
@NumeroVivienda INT, 
@IdCluster INT, 
@IdPropietario INT, 
@IdTipoVivienda INT
As
Begin 
	Insert Into Vivienda(NumeroVivienda, IdCluster, IdPropietario, IdTipoVivienda)
	Values (@NumeroVivienda, @IdCluster, @IdPropietario, @IdTipoVivienda);
	Select @NumeroVivienda ;
End;
--ejemplo para ejecutar sp
Exec CrearVivienda
@NumeroVivienda = 1,
@IdCluster =1, 
@IdPropietario =8, 
@IdTipoVivienda =1
