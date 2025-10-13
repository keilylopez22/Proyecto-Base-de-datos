Create  OR ALTER Procedure SPCrearVivienda
@NumeroVivienda INT, 
@IdCluster INT,  
@IdTipoVivienda INT,
@IdPropietario INT
As
Begin 
	Insert Into Vivienda(NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) 
	Values (@NumeroVivienda, @IdCluster,  @IdTipoVivienda, @IdPropietario);
	Select @NumeroVivienda ;
End;

Exec SPCrearVivienda
@NumeroVivienda = 1,
@IdCluster =1,  
@IdTipoVivienda =1,
@IdPropietario =8
