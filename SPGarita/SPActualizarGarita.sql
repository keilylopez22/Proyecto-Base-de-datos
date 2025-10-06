-- 3. Actualizar Garita
CREATE PROCEDURE ActualizarGarita
    @IdGarita INT,
    @NombreGarita VARCHAR(50),
    @IdCluster INT
AS
BEGIN
    UPDATE Garita 
    SET NombreGarita = @NombreGarita,
        IdCluster = @IdCluster
    WHERE IdGarita = @IdGarita
    
    RETURN @@ROWCOUNT
END;

EXEC ActualizarGarita @IdGarita = 1, @NombreGarita = 'Principal Norte Actualizada', @IdCluster = 1