CREATE OR ALTER  PROCEDURE SPInsertarJuntaDirectiva
@IdCluster INT,
    
AS
BEGIN
    INSERT INTO JuntaDirectiva (IdCluster)
    VALUES (@IdCluster);
    
    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva;
END;

EXEC SPInsertarJuntaDirectiva
@IdCluster = 1;

SELECT * FROM JuntaDirectiva;