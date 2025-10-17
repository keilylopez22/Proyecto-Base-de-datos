--20. Cree un procedimiento almacenado que muestre cual es 
--la residencia que más visitas recibe en un periodo de tiempo dado. 
CREATE OR ALTER PROCEDURE ResidenciaMasVisitada
	@FechaInicio DATE,
	@FechaFin DATE
AS
BEGIN
	SELECT TOP 1
		r.NumeroVivienda,
		r.IdCluster,
		COUNT(ra.IdAcceso) AS TotalVisitas,
		P.PrimerNombre + ' ' + p.PrimerApellido AS ResidentePrincipal,
		c.Descripcion AS Cluster,
		(SELECT Descripcion FROM TipoVivienda WHERE IdTipoVivienda = v.IdTipoVivienda) AS TipoVivienda
	FROM RegistroAccesos AS ra
	INNER JOIN Residente AS r ON ra.IdResidente = r.IdResidente
	INNER JOIN Vivienda AS v ON r.NumeroVivienda = v.NumeroVivienda AND r.IdCluster = v.IdCluster
	INNER JOIN Persona AS p ON r.IdPersona = p.IdPersona
	INNER JOIN Cluster AS c ON r.IdCluster = c.IdCluster
	WHERE
		ra.FechaIngreso BETWEEN @FechaInicio AND @FechaFin
		AND ra.IdVisitante IS NOT NULL
	GROUP BY r.NumeroVivienda, r.IdCluster, p.PrimerNombre, p.PrimerApellido, c.Descripcion, v.IdTipoVivienda
	ORDER BY TotalVisitas DESC
END;

select * from RegistroAccesos

EXEC ResidenciaMasVisitada
	@FechaInicio = '2024-10-01',
	@FechaFIn = '2025-10-31'