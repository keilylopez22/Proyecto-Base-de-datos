CREATE OR ALTER PROCEDURE SPBuscarJuntaDirectivaPK
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster
       
    FROM JuntaDirectiva AS JD
    WHERE JD.IdJuntaDirectiva = @IdJuntaDirectiva;

END;

EXEC SPBuscarJuntaDirectivaPK
@IdJuntaDirectiva = 1
