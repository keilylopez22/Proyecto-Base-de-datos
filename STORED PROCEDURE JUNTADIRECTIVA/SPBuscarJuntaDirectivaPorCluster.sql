CREATE  OR ALTER PROCEDURE SPBuscarJuntaDirectivaPorCluster
    @IdCluster INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster,
      
    FROM JuntaDirectiva JD
    WHERE JD.IdCluster = @IdCluster
    
END