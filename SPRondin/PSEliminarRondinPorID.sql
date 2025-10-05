CREATE OR ALTER PROCEDURE EliminarRondinPorID
@IdRondin INT
AS
BEGIN
DELETE FROM Rondin
WHERE IdRondin = @IdRondin;
END;

EXEC EliminarRondinPorID
@IdRondin = 1;