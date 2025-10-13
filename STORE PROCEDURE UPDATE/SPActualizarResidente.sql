CREATE PROCEDURE SPActualizarResidente
    @IdResidente INT,
    @IdPersona INT,
    @NumeroVivienda INT,
    @IdCluster INT,
    @EsInquilino BIT ,
    @Estado VARCHAR(10)
   
AS
BEGIN
    
        UPDATE Residente
        SET 
            IdPersona = @IdPersona,
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster,
            EsInquilino = @EsInquilino,
            Estado = @Estado
            
        WHERE IdResidente = @IdResidente;
        SELECT @IdResidente
END;
EXEC SPActualizarResidente
@IdResidente =7,
@IdPersona = 7,
@NumeroVivienda =405,
@IdCluster =5,
@EsInquilino= 0,
@Estado= 'Activo'

SELECT * FROM Residente