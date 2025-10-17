--Construya una consulta que muestre cuántos vehículos ingresan de visitante por hora. El
--procedimiento almacenado debe recibir como parámetro un rango de fechas (del, al) para
--construir el reporte para ese periodo de tiempo en específico

CREATE OR ALTER PROCEDURE VehiculosPorHora
@FechaInicio DATE ,
@FechaFin DATE
AS 
BEGIN
	SELECT DATEPART(HOUR, ra.FechaIngreso) AS Hora, COUNT(*) AS CantdadVehiculos, v.NombreCompleto
	FROM RegistroAccesos AS ra
	INNER JOIN Visitante AS v ON ra.IdVisitante = v.IdVisitante
	WHERE ra.FechaIngreso BETWEEN @FechaInicio and @FechaFin AND ra.IdVehiculo IS NOT NULL
	GROUP BY DATEPART(HOUR, ra.FechaIngreso), v.NombreCompleto

END;
EXEC VehiculosPorHora
@FechaInicio = '2024-01-01',
@FechaFin = '2024-10-14'