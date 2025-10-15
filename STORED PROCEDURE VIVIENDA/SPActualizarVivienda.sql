Create Or Alter Procedure SPActualizarVivivenda
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


EXEC SPActualizarVivivenda
@NumeroVivienda =1, 
@IdCluster =1, 
@IdPropietario =7, 
@IdTipoVivienda =1

SELECT * FROM Vivienda