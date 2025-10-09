CREATE  OR ALTER PROCEDURE SPBuscarPuestosPorPropietario
    @IdPropietario INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.FechaInicio,
        JD.FechaFin,
        PJD.Nombre AS Puesto,
        JD.Estado
    FROM MiembroJuntaDirectiva MJD
    INNER JOIN JuntaDirectiva JD ON MJD.IdJuntaDirectiva = JD.IdJuntaDirectiva
    INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuestoJuntaDirectiva = PJD.IdPuestoJuntaDirectiva
    WHERE MJD.IdPropietario = @IdPropietario
    ORDER BY JD.FechaInicio DESC;
END;
