CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaFin
@FechaFin DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaFin IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.FechaFin = @FechaFin
END

EXEC SP_BuscarPersonaNoGrataPorFechaFin
@FechaFin = '2025-05-01'


