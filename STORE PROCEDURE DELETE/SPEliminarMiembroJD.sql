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
        AND IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva;
        
   
END;