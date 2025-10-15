CREATE OR ALTER PROCEDURE SPBuscarJuntaDirectivaPorEstado
    @Estado VARCHAR(100)
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster,
        JD.FechaInicio,
        JD.FechaFin,
        JD.Estado
    FROM JuntaDirectiva JD
    WHERE JD.Estado = @Estado
    ORDER BY JD.IdCluster, JD.FechaInicio DESC;
END
GO