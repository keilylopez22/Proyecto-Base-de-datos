CREATE OR ALTER PROCEDURE CrearDetalleRondin
@Hora DATE,
@Lugar VARCHAR(50),
@IdRondin INT
AS
BEGIN
INSERT INTO DetalleDelRondin (Hora, Lugar, IdRondin)
VALUES (@Hora, @Lugar, @IdRondin);
END;

EXEC CrearDetalleRondin
@Hora = '2025-10-02',
@Lugar = 'Entrada Principal',
@IdRondin = 3;