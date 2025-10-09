CREATE OR ALTER PROCEDURE SPBuscarJuntaDirectivaPK
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster,
        JD.FechaInicio,
        JD.FechaFin,
        JD.Estado
    FROM JuntaDirectiva AS JD
    WHERE JD.IdJuntaDirectiva = @IdJuntaDirectiva;
END