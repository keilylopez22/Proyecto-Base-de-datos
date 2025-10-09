CREATE OR ALTER PROCEDURE SPBuscarClusterPorDescripcion
@NombreCluster VARCHAR(30)
AS
BEGIN 
	SELECT IdCluster, Descripcion AS 'Nombre Cluster'
	FROM Cluster
	WHERE Descripcion =  @NombreCluster
END;
EXEC SPBuscarClusterPorDescripcion
@NombreCluster = 'Sector E -Fases Nuevas'

