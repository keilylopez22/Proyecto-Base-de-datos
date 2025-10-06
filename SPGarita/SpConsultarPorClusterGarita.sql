--Consultar la Garita por el IdCluster
CREATE PROCEDURE ConsultarPorClusterGarita
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdCluster = @IdCluster
END;

EXEC ConsultarPorClusterGarita @IdCluster = 1