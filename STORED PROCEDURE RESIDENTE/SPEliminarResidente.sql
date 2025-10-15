CREATE OR ALTER PROCEDURE PSEliminarResidente
@IdResidente INT
AS
BEGIN
	DELETE Residente
	WHERE IdResidente = @IdResidente
	SELECT @IdResidente
END;

EXEC PSEliminarResidente
@IdResidente = 20

SELECT * FROM Residente