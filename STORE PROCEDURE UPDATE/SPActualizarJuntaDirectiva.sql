
CREATE OR ALTER  PROCEDURE SPActualizarJuntaDirectiva
    @IdJuntaDirectiva INT,
    @IdCluster INT,
    @FechaInicio DATE,
    @FechaFin DATE,
    @Estado VARCHAR(100)
AS
BEGIN
    UPDATE JuntaDirectiva
    SET
        IdCluster = @IdCluster,
        FechaInicio = @FechaInicio,
        FechaFin = @FechaFin,
        Estado = @Estado
    WHERE
        IdJuntaDirectiva = @IdJuntaDirectiva;
        
    
END
