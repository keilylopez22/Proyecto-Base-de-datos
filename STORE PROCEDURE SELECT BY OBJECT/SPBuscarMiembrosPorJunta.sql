CREATE OR ALTER PROCEDURE SPBuscarMiembrosPorJunta
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        MJD.IdPropietario,
        CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario',
        PJD.Nombre AS Puesto
    FROM MiembroJuntaDirectiva AS MJD
    INNER JOIN Propietario P ON MJD.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
    INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuestoJuntaDirectiva = PJD.IdPuestoJuntaDirectiva
    WHERE MJD.IdJuntaDirectiva = @IdJuntaDirectiva
    ORDER BY PJD.IdPuestoJuntaDirectiva;
END;
