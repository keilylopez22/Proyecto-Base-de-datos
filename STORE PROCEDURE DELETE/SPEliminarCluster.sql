CREATE OR ALTER PROCEDURE SPEliminarCluster
@IdCluster INT
AS
BEGIN 
	DELETE Cluster 
	Where IdCluster = @IdCluster
	Select @IdCluster
END;

EXEC SPEliminarCluster
@IdCluster = 6
