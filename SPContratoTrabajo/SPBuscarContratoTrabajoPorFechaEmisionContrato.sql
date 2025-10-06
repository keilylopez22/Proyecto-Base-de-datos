CREATE PROCEDURE SPBuscarContratoTrabajoPorFechaEmisionContrato
@FechaEmisionContrato DATE
AS
BEGIN 
SELECT ct.IdNumeroContrato, ct.FechaEmisionContrato FROM ContratoTrabajo AS ct
WHERE FechaEmisionContrato = @FechaEmisionContrato
END

EXEC SPBuscarContratoTrabajoPorFechaEmisionContrato
@FechaEmisionContrato = '2025-12-01'