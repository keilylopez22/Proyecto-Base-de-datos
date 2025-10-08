CREATE OR ALTER PROCEDURE SPEliminarPersona
@IdPersona INT
AS
BEGIN
	DELETE Persona 
	WHERE IdPersona = @IdPersona
	SELECT @IdPersona 

END;
EXEC SPEliminarPersona
@IdPersona = 38