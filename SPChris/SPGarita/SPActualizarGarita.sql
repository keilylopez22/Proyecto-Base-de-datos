CREATE OR ALTER PROCEDURE ActualizarGarita
    @IdGarita INT,
    @IdCluster INT
AS
BEGIN
    UPDATE Garita 
    SET IdCluster = @IdCluster
    WHERE IdGarita = @IdGarita
    
    RETURN @@ROWCOUNT
END;

EXEC  ActualizarGarita @IdGarita = 1, @IdCluster = 2