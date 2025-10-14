CREATE  OR ALTER PROCEDURE SPBuscarMiembroJDPK
@IdJuntaDirectiva INT,
@IdPropietario INT,
@IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        MJD.IdJuntaDirectiva,
        MJD.IdPropietario,
        MJD.IdPuesto
    FROM MiembroJuntaDirectiva MJD
    WHERE
        MJD.IdJuntaDirectiva = @IdJuntaDirectiva
        AND MJD.IdPropietario = @IdPropietario
        AND MJD.IdPuesto = @IdPuestoJuntaDirectiva;
END;


EXEC SPBuscarMiembroJDPK
@IdJuntaDirectiva = 1,
@IdPropietario = 2,
@IdPuestoJuntaDirectiva = 3