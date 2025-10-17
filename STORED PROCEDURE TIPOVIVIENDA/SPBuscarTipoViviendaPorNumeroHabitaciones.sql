CREATE OR ALTER PROCEDURE PSBuscarTipoViviendaPorNumeroHabitaciones
@NumeroHabitaciones INT
AS
BEGIN
	SELECT TV.IdTipoVivienda, TV.Descripcion AS TipoVivienda,TV.NumeroHabitaciones, V.NumeroVivienda, V.IdCluster
	FROM TipoVivienda  AS TV
	INNER JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
	WHERE TV.NumeroHabitaciones = @NumeroHabitaciones
END;

EXEC PSBuscarTipoViviendaPorNumeroHabitaciones
@NumeroHabitaciones = 3
