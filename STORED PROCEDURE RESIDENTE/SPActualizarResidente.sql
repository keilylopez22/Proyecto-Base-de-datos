CREATE OR ALTER PROCEDURE SPActualizarResidente
    @IdResidente INT,
    @NumeroVivienda INT,
    @IdCluster INT,
    @EsInquilino BIT ,
    @Estado VARCHAR(10)
   
AS
BEGIN
    
        UPDATE Residente
        SET 
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster,
            EsInquilino = @EsInquilino,
            Estado = @Estado
            
        WHERE IdResidente = @IdResidente;
        SELECT @IdResidente
END;

EXEC SPActualizarResidente
@IdResidente =11,
@NumeroVivienda =405,
@IdCluster =4,
@EsInquilino= 0,
@Estado= 'Activo'


SELECT * FROM Residente

SELECT * FROM VIVIENDA