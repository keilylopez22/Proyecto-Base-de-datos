CREATE PROCEDURE SPActualizarResidente
    @IdResidente INT,
    @IdPersona INT,
    @NumeroVivienda INT,
    @Estado VARCHAR(10),
    @IdCluster INT
AS
BEGIN
    
        UPDATE Residente
        SET 
            IdPersona = @IdPersona,
            NumeroVivienda = @NumeroVivienda,
            Estado = @Estado,
            IdCluster = @IdCluster
        WHERE IdResidente = @IdResidente;
        SELECT @IdResidente
END;
EXEC SPActualizarResidente
@IdResidente =7,
@IdPersona = 7,
@NumeroVivienda =524,
@Estado= 'Activo',
@IdCluster =5
