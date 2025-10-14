CREATE OR ALTER PROCEDURE SPEliminarPuestoJD
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    IF EXISTS (SELECT * 
    FROM MiembroJuntaDirectiva 
    WHERE IdPuesto = @IdPuestoJuntaDirectiva)
    BEGIN
     
        RAISERROR('No se puede eliminar el Puesto porque esta siendo usado en MiembroJuntaDirectiva.',16,1);
        RETURN 0;
    END
    
    
    DELETE FROM PuestoJuntaDirectiva
    WHERE IdPuesto = @IdPuestoJuntaDirectiva;
       
END;

EXEC SPEliminarPuestoJD
@IdPuestoJuntaDirectiva = 1

SELECT * FROM PuestoJuntaDirectiva
