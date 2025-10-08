
Create OR Alter Procedure EliminarVivienda
@NumeroVivienda INT, 
@IdCluster INT 

AS
Begin
	Delete Vivienda
	Where NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster;
End;


Exec EliminarVivienda
@NumeroVivienda =12,
@IdCluster =1