CREATE OR ALTER PROCEDURE SPBuscarTipoDeViviendaSINEstacionamiento
AS
BEGIN
	SELECT TV.IdTipoVivienda,TV.Descripcion AS TipoVivienda,TV.Estacionamiento, V.NumeroVivienda, V.IdCluster
	FROM TipoVivienda AS TV
	Left JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
	WHERE TV.Estacionamiento = 0
END;

EXEC SPBuscarTipoDeViviendaSinEstacionamiento