CREATE OR ALTER PROCEDURE ObtenerRondinPorID
@IdRondin INT
AS
BEGIN
SELECT IdRondin, FechaInico, FechaFin, IdEmpleado
FROM Rondin
WHERE IdRondin = @IdRondin;
END;

EXEC ObtenerRondinPorId
@IdRondin = 3;

