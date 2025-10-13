CREATE OR ALTER PROCEDURE SP_BuscarPeronaNoGrataPorId
@IdPersonaNoGrata INT 
AS
BEGIN
SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata
END

EXEC SP_BuscarPeronaNoGrataPorId
@IdPersonaNoGrata = 1