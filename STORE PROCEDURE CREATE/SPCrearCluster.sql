CREATE OR ALTER PROCEDURE SPsertarCluster
@Descripcion VARCHAR(30)
AS
BEGIN
	INSERT INTO Cluster(Descripcion)
	VALUES(@Descripcion)
	SELECT SCOPE_IDENTITY() AS IdCluster
END;

EXEC SPsertarCluster
@Descripcion = 'ClusterPrueba'