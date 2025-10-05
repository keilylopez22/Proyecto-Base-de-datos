CREATE OR ALTER PROCEDURE EliminarDetalleRondin
@IdDetalleDelRondin INT
AS
BEGIN
DELETE FROM DetalleDelRondin
WHERE IdDetalleDelRondin = @IdDetalleDelRondin;
END;

EXEC EliminarDetalleRondin
@IdDetalleDelRondin = 4;