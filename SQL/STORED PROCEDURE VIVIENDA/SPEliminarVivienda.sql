Create Or Alter Procedure PSEliminarVivienda
@NumeroVivienda INT, 
@IdCluster INT 

AS
Begin

	IF EXISTS(
	SELECT *
	FROM Residente
	WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
	) 
	BEGIN
		RAISERROR('No se puede eliminar la vivienda porque hay residentes asociados',16,1)
		RETURN 0;
	END;
	
	Delete Vivienda
	Where NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster;
End;


Exec PSEliminarVivienda
@NumeroVivienda =405,
@IdCluster =4

SELECT * FROM Vivienda