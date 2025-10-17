CREATE OR ALTER PROCEDURE SPInsertarCluster
@Descripcion VARCHAR(30),
@IdResidencial INT
AS
BEGIN
	INSERT INTO Cluster(Descripcion, IdResidencial)
	VALUES(@Descripcion, @IdResidencial)
	SELECT SCOPE_IDENTITY() AS IdCluster
END;

EXEC SPInsertarCluster
@Descripcion = 'ClusterPrueba',
@IdResidencial = 1

SELECT * FROM Cluster