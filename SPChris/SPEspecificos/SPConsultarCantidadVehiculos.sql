--19. Prepare una consulta que muestre si una persona debe pagar 150 
--por sobrepasar la cantidad de carros permitida por vivienda. 
CREATE OR ALTER PROCEDURE ConsultarCantidadVehiculos
	@NumeroVivienda INT = NULL,
	@IdCluster INT = NULL
AS 
BEGIN
	SELECT
		v.NumeroVIVienda,
		v.IdCluster,
		COUNT(ve.IdVehiculo) AS CantidadVehiculos,
		CASE
			WHEN COUNT(ve.IdVehiculo) > 4 THEN 'Debe pagar la multa de 150 por sobrepasar el limite de vehiculos permitidos'
			ELSE 'No rebasa el limite de vehiculos permitidos'
		END AS EstadoPago,
		CASE
			WHEN COUNT(ve.IdVehiculo) > 4 THEN 150.00
			ELSE 0.00
		END AS MontoMulta
	FROM Vivienda AS v
	LEFT JOIN Vehiculo ve ON v.NumeroVivienda = ve.NumeroVivienda 
	AND v.IdCluster = ve.IdCluster
	WHERE 
		(@NumeroVivienda IS NULL OR v.NumeroVivienda = @NumeroVivienda)
		AND (@IdCluster IS NULL OR v.IdCluster = @IdCluster)
	GROUP BY v.NumeroVivienda, v.IdCluster
	HAVING COUNT(ve.IdVehiculo) > 4 OR @NumeroVivienda IS NOT NULL
	ORDER BY CantidadVehiculos DESC
END;

Select * from Vivienda

EXEC ConsultarCantidadVehiculos

EXEC ConsultarCantidadVehiculos @NumeroVivienda = 405, @IdCluster = 4