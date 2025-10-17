-- 23. Cual es el mes del año donde han ocurrido mas multas por concepto de desorden. 
CREATE OR ALTER PROCEDURE MesMultasDesorden
	@Año INT = NULL
AS
BEGIN
	SELECT TOP 1
		MONTH(mv.FechaInfraccion) AS Mes,
		DATENAME(MONTH, mv.FechaInfraccion) AS NombreMes,
		COUNT(*) AS CantidadMulta,
		'Ruido excesivo' AS ConceptoMulta,
		MAX(tm.Monto) AS MontoPorMulta,
		SUM(tm.Monto) AS TotalRecaudado
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm 
	ON mv.IdTipoMulta = tm.IdTipoMulta
	WHERE
		(@Año IS NULL OR YEAR(mv.FechaInfraccion) = @Año)
		AND tm.Nombre = 'Ruido excesivo'
	GROUP BY
		MONTH(mv.FechaInfraccion),
		DATENAME(MONTH, mv.FechaInfraccion)
	ORDER BY CantidadMulta DESC
END;

EXEC MesMultasDesorden;