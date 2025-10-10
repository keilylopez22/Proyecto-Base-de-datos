
Create Or Alter Procedure ActualizarVivivenda
@NumeroVivienda INT, 
@IdCluster INT, 
@IdPropietario INT, 
@IdTipoVivienda INT
AS

Begin
	Update	Vivienda 
	Set IdPropietario =@IdPropietario, 
		IdTipoVivienda =@IdTipoVivienda 
	Where NumeroVivienda = @NumeroVivienda and IdCluster= @IdCluster
End;


EXEC ActualizarVivivenda
@NumeroVivienda =11, 
@IdCluster =1, 
@IdPropietario =8, 
@IdTipoVivienda =1

