
Create OR Alter Procedure PSEliminarVivienda
@NumeroVivienda INT, 
@IdCluster INT 

AS
Begin
	Delete Vivienda
	Where NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster;
End;


Exec PSEliminarVivienda
@NumeroVivienda =405,
@IdCluster =4

SELECT * FROM Vivienda