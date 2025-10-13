CREATE OR ALTER PROCEDURE SP_EliminarPersonaNoGrata
@IdPersonaNoGrata INT
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPersonaNograta)
BEGIN
RAISERROR('Esta persona no se encuentra en el registro de no gratos',16,1)
RETURN
END

DELETE FROM PersonaNoGrata 
WHERE IdPersonaNoGrata = @IdPersonaNoGrata 
PRINT 'Persona eliminada correctamente de no gratos'
END

EXEC SP_EliminarPersonaNoGrata
@IdPersonaNoGrata = 4