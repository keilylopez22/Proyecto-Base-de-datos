--buscarViviendasPorResidenteActivo
CREATE OR ALTER PROCEDURE SPbuscarPropietarioPorCluster
@IdCluster INT
AS
BEGIN
	SELECT P.IdPropietario,CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario',C.IdCluster, V.NumeroVivienda, TV.Descripcion AS 'Tipo de Vivienda'
	FROM Propietario AS P
	INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
	INNER JOIN Vivienda AS V ON P.IdPropietario = V.IdPropietario
	INNER JOIN TipoVivienda AS TV ON V.IdTipoVivienda = TV.IdTipoVivienda
	INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
	WHERE C.IdCluster = @IdCluster
END;

EXEC SPbuscarPropietarioPorCluster
@IdCluster = 1
