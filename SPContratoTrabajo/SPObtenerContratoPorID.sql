CREATE OR ALTER PROCEDURE ObtenerContratoPorID
@IdNumeroContrato INT
AS
BEGIN
SELECT IdNumeroCOntrato, FechaEmisionContrato, Estado, IdEmpleado, IdPuestoTrabajo
FROM ContratoTrabajo
WHERE IdNumeroContrato = @IdNumeroContrato;
END

EXEC ObtenerContratoPorID
@IdNumeroContrato = 1