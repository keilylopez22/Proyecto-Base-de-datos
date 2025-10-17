CREATE OR ALTER PROCEDURE InsertarPropietario
@Estado VARCHAR(10) ,
@IdPersona INT
AS
BEGIN
	INSERT INTO Propietario(Estado,IdPersona)
	VALUES(@Estado, @IdPersona)
	SELECT SCOPE_IDENTITY() AS IdPropietario;
END;

EXEC InsertarPropietario
@Estado ='ACTIVO',
@IdPersona =9;

SELECT * FROM Propietario

