CREATE OR ALTER  PROCEDURE SPInsertarJuntaDirectiva
    @IdCluster INT,
    @FechaInicio DATE,
    @FechaFin DATE,
    @Estado VARCHAR(100)
AS
BEGIN
    INSERT INTO JuntaDirectiva (IdCluster, FechaInicio, FechaFin, Estado)
    VALUES (@IdCluster, @FechaInicio, @FechaFin, @Estado);
    
    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva;
END