CREATE OR ALTER PROCEDURE SPBuscarCluster
@IdCluster INT
AS
BEGIN
	SELECT *
	FROM Cluster
	WHERE IdCluster = @IdCluster
END;

EXEC SPBuscarCluster
@IdCluster = 1