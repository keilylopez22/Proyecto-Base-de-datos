CREATE  OR ALTER PROCEDURE SPInsertarMiembroJD
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    INSERT INTO MiembroJuntaDirectiva (IdJuntaDirectiva, IdPropietario, IdPuestoJuntaDirectiva)
    VALUES (@IdJuntaDirectiva, @IdPropietario, @IdPuestoJuntaDirectiva);
    
    
END;


