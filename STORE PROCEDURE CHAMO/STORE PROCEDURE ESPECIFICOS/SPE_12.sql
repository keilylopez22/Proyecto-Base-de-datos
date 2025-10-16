-- 12) Determine cuál es la vivienda más atrasada en los pagos de mantenimiento.

SELECT TOP 1 v.NumeroVivienda, COUNT(*) PagosAusentes, MAX(csv.FechaCobro) AS UltimoCobro, MAX(DATEDIFF(DAY, csv.FechaCobro, GETDATE())) AS CantidadDiasAtrasado FROM Vivienda AS v
INNER JOIN CobroServicioVivienda csv ON v.NumeroVivienda = csv.NumeroVivienda
WHERE csv.EstadoPago = 'PENDIENTE'
GROUP BY  v.NumeroVivienda
ORDER BY CantidadDiasAtrasado DESC


SELECT * FROM CobroServicioVivienda


