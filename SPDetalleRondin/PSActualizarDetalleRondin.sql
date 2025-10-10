CREATE OR ALTER PROCEDURE ActualizarDetalleRondin
@IdDetalleDelRondin INT,
@Hora DATE,
@Lugar VARCHAR(50),
@IdRondin INT
AS
BEGIN
UPDATE DetalleDelRondin
SET Hora = @Hora,
Lugar = @Lugar,
IdRondin = @IdRondin
WHERE IdDetalleDelRondin = @IdDetalleDelRondin;
END;

EXEC ActualizarDetalleRondin
@IdDetalleDelRondin = 5,
@Hora = '2025-10-03',
@Lugar = 'Patio Trasero',
@IdRondin = 3;

