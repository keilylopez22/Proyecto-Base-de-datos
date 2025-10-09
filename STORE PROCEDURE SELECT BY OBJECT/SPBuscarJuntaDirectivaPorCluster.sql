CREATE  OR ALTER PROCEDURE SPBuscarJuntaDirectivaPorCluster
    @IdCluster INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster,
        JD.FechaInicio,
        JD.FechaFin,
        JD.Estado
    FROM JuntaDirectiva JD
    WHERE JD.IdCluster = @IdCluster
    ORDER BY JD.FechaInicio DESC;
END