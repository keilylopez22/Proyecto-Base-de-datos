CREATE OR ALTER PROCEDURE ObtenerDetalleRondinPorID
@IdDetalleDelRondin INT
AS
BEGIN
SELECT IdDetalleDelRondin, Hora, Lugar, IdRondin
FROM DetalleDelRondin
WHERE IdDetalleDelRondin = @IdDetalleDelRondin;
END;

EXEC ObtenerDetalleRondinPorID
@IdDetalleDelRondin = 5;

