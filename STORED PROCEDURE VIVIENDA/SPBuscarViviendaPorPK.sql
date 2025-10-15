Create OR Alter Procedure BuscarVivienda
@NumeroVivienda INT,
@IdCluster INT

AS

Begin 
	Select * 
	from Vivienda
	Where  NumeroVivienda = @NumeroVivienda  and IdCluster = @IdCluster;
End;


Exec BuscarVivienda
@NumeroVivienda = 1,
@IdCluster = 1