CREATE OR ALTER  PROCEDURE SPActualizarJuntaDirectiva
@IdJuntaDirectiva INT,
@IdCluster INT
  
AS
BEGIN
    UPDATE JuntaDirectiva
    SET
        IdCluster = @IdCluster
        
    WHERE
        IdJuntaDirectiva = @IdJuntaDirectiva;

    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva
        
    
END;

EXEC SPActualizarJuntaDirectiva
@IdJuntaDirectiva = 3,  
@IdCluster = 2  




SELECT * FROM JuntaDirectiva 

