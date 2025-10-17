--22. Cuales son las casas pendientes de pagar multas.
CREATE OR ALTER PROCEDURE CasasPendientesPagoMultas
AS
BEGIN
	SELECT 
		mv.NumeroVivienda,
		mv.IdCluster,
		tm.Nombre AS ConceptoMulta,
		mv.Monto,
		mv.FechaInfraccion,
		mv.FechaRegistro,
		DATEDIFF(DAY, mv.FechaRegistro, GETDATE()) AS DiasPendiente,
		p.PrimerNombre + ' ' + p.PrimerApellido AS Propietario,
		p.Telefono
	FROM MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
	INNER JOIN Vivienda AS v On mv.NumeroVivienda = v.NumeroVivienda 
	AND mv.IdCluster = v.IdCluster
	INNER JOIN Propietario AS pr ON v.IdPropietario = pr.IdPropietario
	INNER JOIN Persona AS p ON pr.IdPersona = p.IdPersona
	WHERE
		mv.EstadoPago = 'PENDIENTE'
	ORDER BY DiasPendiente DESC, mv.Monto DESC
END;


EXEC CasasPendientesPagoMultas