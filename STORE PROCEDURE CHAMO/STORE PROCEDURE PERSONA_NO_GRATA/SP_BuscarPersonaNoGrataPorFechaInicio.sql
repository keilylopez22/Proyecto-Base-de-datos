CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaInicio
@IdPersonaNoGrata INT,
@FechaInicio DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaInicio IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata AND  pn.FechaInicio = @FechaInicio
END

EXEC SP_BuscarPersonaNoGrataPorFechaInicio
@IdPersonaNoGrata = 1,
@FechaInicio = '2024-05-01'

