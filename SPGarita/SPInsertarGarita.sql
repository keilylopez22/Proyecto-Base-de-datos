-- 1. Insertar en Garita
CREATE OR ALTER PROCEDURE InsertarGarita
    @NombreGarita VARCHAR(50),
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (NombreGarita, IdCluster)
    VALUES (@NombreGarita, @IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarGarita @NombreGarita = 'Garita Emergencia', @IdCluster = 1