--Construya un procedimiento almacenado que reciba un periodo de tiempo y determine quién es
--el vecino que más ha pagado en ese período de tiempo
CREATE OR ALTER PROCEDURE VecinoPagoTiempo
@FechaInicio DATE,
@FechaFin DATE
AS
BEGIN
	SELECT TOP 1 CONCAT(per.PrimerNombre,' ', per.SegundoNombre,' ',per.PrimerApellido, ' ', per.SegundoApellido) AS Vecino, sum(p.MontoTotal) AS TotalPagado
	FROM Pago AS  p 
	INNER JOIN Recibo AS  r
	ON p.IdPago = r.IdPago
	INNER JOIN DetalleRecibo AS dr 
	ON dr.IdRecibo = r.IdRecibo
	INNER  JOIN CobroServicioVivienda AS csv
	ON dr.idCobroServicio = csv.idCobroServicio
	INNER JOIN Vivienda AS v
	ON csv.NumeroVivienda = v.NumeroVivienda
	AND csv.IdCluster = v.IdCluster
	INNER JOIN Propietario AS pro
	ON v.IdPropietario = PRO.IdPropietario
	INNER JOIN Persona AS per
	ON pro.IdPersona = per.IdPersona
	WHERE p.FechaPago BETWEEN @FechaInicio AND @FechaFin
	GROUP BY  per.PrimerNombre, per.SegundoNombre, per.PrimerApellido, per.SegundoApellido
	ORDER BY TotalPagado DESC
	 
END;
GO 
EXEC VecinoPagoTiempo
@FechaInicio = '2025-10-12',
@FechaFin = '2025-10-13'; 