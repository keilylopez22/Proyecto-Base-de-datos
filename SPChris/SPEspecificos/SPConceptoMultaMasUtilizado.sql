-- 21. Cual es el concepto de multa mas utilizado en un periodo de tiempo dado. 
CREATE OR ALTER PROCEDURE ConceptoMultaMasUtilizado
	@FechaInicio DATE,
	@FechaFin DATE
AS 
BEGIN
	SELECT TOP 1
		tm. IdTipoMulta,
		tm.Nombre AS ConceptoMulta,
		COUNT(mv.IdMultaVivienda) AS CantidadMultas,
		tm.Monto AS MontoPorMulta,
		COUNT(mv.IdMultaVivienda) * tm.Monto AS TotalRecaudado
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
	WHERE
		mv.FechaInfraccion BETWEEN @FechaInicio AND @FechaFin
	GROUP BY tm.IdTipoMulta, tm.Nombre, tm.Monto
	ORDER BY CantidadMultas DESC
END;

SELECT * FROM MultaVivienda

SELECT * FROM TipoMulta

EXEC ConceptoMultaMasUtilizado
	@FechaInicio = '2024-09-01',
	@FechaFin = '2024-09-30';