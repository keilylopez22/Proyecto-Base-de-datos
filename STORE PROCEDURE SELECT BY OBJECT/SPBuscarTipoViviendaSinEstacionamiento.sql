CREATE OR ALTER PROCEDURE PSBuscarTipoDeViviendaSINEstacionamiento
@Estacionamiento BIT
AS
BEGIN
	SELECT TV.IdTipoVivienda,TV.Descripcion AS TipoVivienda,TV.Estacionamiento, V.NumeroVivienda, V.IdCluster
	FROM TipoVivienda AS TV
	Left JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
	WHERE TV.Estacionamiento = @Estacionamiento
END;

EXEC PSBuscarTipoDeViviendaSinEstacionamiento
@Estacionamiento = 0
