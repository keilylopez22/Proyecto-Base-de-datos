CREATE OR ALTER PROCEDURE InsertarGarita
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (IdCluster)
    VALUES (@IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

EXEC InsertarGarita @IdCluster = 1;

select * from Garita
