CREATE  OR ALTER PROCEDURE SPBuscarMiembroJDPK
@IdMiembro INT
AS
BEGIN
    
    SELECT
        P.IdPersona,CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, '')) AS Miembro, 
        MJD.IdJuntaDirectiva,
        MJD.IdPropietario,
        MJD.idPuesto,
        PJD.Nombre AS Puesto,
        MJD.FechaInicio,
        MJD.FechaFin
    FROM MiembroJuntaDirectiva MJD
    INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
    INNER JOIN Persona AS P ON PR.IdPersona = P.IdPersona
    INNER JOIN PuestoJuntaDirectiva AS PJD ON MJD.idPuesto = PJD.idPuesto
    
    WHERE
       MJD.IdMiembro = @IdMiembro
       
END;

EXEC SPBuscarMiembroJDPK
@IdMiembro = 2

SELECT  * FROM MiembroJuntaDirectiva
