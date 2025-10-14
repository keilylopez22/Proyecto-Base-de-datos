CREATE OR ALTER PROCEDURE SPEliminarJuntaDirectiva
    @IdJuntaDirectiva INT
AS
BEGIN
   
    
   
    IF EXISTS (SELECT * 
    FROM MiembroJuntaDirectiva 
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva)
    BEGIN
        
        RAISERROR('No se puede eliminar la Junta Directiva porque tiene miembros registrados. Debe eliminar primero los miembros.', 16, 1);
        RETURN 0;
    END
    
    
    
END;

EXEC SPEliminarJuntaDirectiva
@IdJuntaDirectiva = 5


SELECT * FROM JuntaDirectiva
