CREATE OR ALTER PROCEDURE InsertarPropietario
@IdPersona INT
AS
BEGIN
	INSERT INTO Propietario(IdPersona)
	VALUES(@IdPersona)
	SELECT SCOPE_IDENTITY() AS IdPropietario;
END;

EXEC InsertarPropietario
@IdPersona =9;

