CREATE  OR ALTER PROCEDURE SPBuscarMiembroJDPK
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        MJD.IdJuntaDirectiva,
        MJD.IdPropietario,
        MJD.IdPuestoJuntaDirectiva
    FROM MiembroJuntaDirectiva MJD
    WHERE
        MJD.IdJuntaDirectiva = @IdJuntaDirectiva
        AND MJD.IdPropietario = @IdPropietario
        AND MJD.IdPuestoJuntaDirectiva = @IdPuestoJuntaDirectiva;
END;
