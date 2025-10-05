CREATE OR ALTER PROCEDURE EliminarContratoPorID
@IdNumeroContrato INT
AS
BEGIN
DELETE FROM ContratoTrabajo
WHERE IdNumeroContrato = @IdNumeroContrato;
END

EXEC EliminarContratoPorID
@IdNumeroContrato = 2