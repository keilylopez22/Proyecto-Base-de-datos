CREATE OR ALTER PROCEDURE SPEliminarPuestoJD
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    IF EXISTS (SELECT * 
    FROM MiembroJuntaDirectiva 
    WHERE IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva)
    BEGIN
     
        RAISERROR('No se puede eliminar el Puesto porque está siendo usado en MiembroJuntaDirectiva.',16,1);
        RETURN 0;
    END
    
    
    DELETE FROM PuestoJuntaDirectiva
    WHERE IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva;
       
END;