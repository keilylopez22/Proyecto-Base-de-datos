CREATE  OR ALTER PROCEDURE SPEliminarMiembroJD
    
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    DELETE FROM MiembroJuntaDirectiva
    WHERE
        IdJuntaDirectiva = @IdJuntaDirectiva
        AND IdPropietario = @IdPropietario
        AND IdPuesto = @IdPuestoJuntaDirectiva;
        
   
END;

EXEC SPEliminarMiembroJD
@IdJuntaDirectiva = 1,
@IdPropietario = 1,
@IdPuestoJuntaDirectiva = 1

SELECT * FROM MiembroJuntaDirectiva

