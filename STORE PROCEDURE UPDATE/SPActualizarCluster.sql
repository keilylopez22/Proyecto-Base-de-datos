CREATE OR ALTER PROCEDURE PSActualizarCluster
@IdCluster INT,
@Descripcion VARCHAR (30)
AS
BEGIN
	UPDATE Cluster
	SET Descripcion=@Descripcion 
	WHERE IdCluster=@IdCluster
	SELECT @IdCluster
	
END;
EXEC PSActualizarCluster
@IdCluster = 6,
@Descripcion = 'Sector F'

