CREATE OR ALTER PROCEDURE SPBuscarPersona
@IdPersona INT
AS
BEGIN
	SELECT *
	FROM Persona
	WHERE IdPersona= @IdPersona
END;

EXEC SPBuscarPersona
@IdPersona = 4