CREATE OR ALTER PROCEDURE PSActualizarCluster
@IdCluster INT,
@Descripcion VARCHAR (30)
AS
BEGIN
	UPDATE Cluster
	SET Descripcion=@Descripcion 
	WHERE IdCluster=@IdCluster
	SELECT SCOPE_IDENTITY() AS IdCluster
	
END;
EXEC PSActualizarCluster
@IdCluster = 5,
@Descripcion = 'Cluster E'

SELECT * FROM Cluster 