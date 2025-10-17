-- 12) Determine cu�l es la vivienda m�s atrasada en los pagos de mantenimiento.

CREATE OR ALTER PROCEDURE SPE_12_ViviendaAtrasadaEnPagos
AS
BEGIN
SELECT TOP 1 v.NumeroVivienda, COUNT(*) PagosAusentes, MAX(csv.FechaCobro) AS UltimoCobro,MAX(DATEDIFF(DAY, csv.FechaCobro, GETDATE())) AS CantidadDiasAtrasado FROM Vivienda AS v
INNER JOIN CobroServicioVivienda csv ON v.NumeroVivienda = csv.NumeroVivienda
WHERE csv.EstadoPago = 'PENDIENTE'
GROUP BY  v.NumeroVivienda
ORDER BY CantidadDiasAtrasado DESC
END

EXEC SPE_12_ViviendaAtrasadaEnPagos


