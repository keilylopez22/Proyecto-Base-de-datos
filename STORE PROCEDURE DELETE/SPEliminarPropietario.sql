CREATE OR ALTER PROCEDURE PSEliminarPropietario
@IdPropietario INT
AS 
BEGIN
	DELETE Propietario
	WHERE IdPropietario = @IdPropietario
	SELECT @IdPropietario
END;

EXEC PSEliminarPropietario
@IdPropietario = 11


SELECT * FROM Propietario