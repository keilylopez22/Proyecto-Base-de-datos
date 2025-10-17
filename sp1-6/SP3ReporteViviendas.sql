--Construir un reporte de viviendas. Debe mostrar, por clúster, las viviendas con sus propietarios y
--si tiene inquilinos mostrar el nombre de los inquilinos
CREATE OR ALTER PROCEDURE ReporteViviendas
AS
BEGIN
	SELECT v.IdCluster, v.NumeroVivienda, CONCAT(pe.PrimerNombre, ' ', pe.PrimerApellido, '') AS Propietrario, CONCAT(per.PrimerNombre, ' ', per.PrimerApellido, '') AS Inquilino 
	FROM Vivienda AS v
	INNER JOIN Propietario p ON v.IdPropietario = p.IdPropietario
	INNER JOIN Persona pe ON p.IdPersona = pe.IdPersona
	LEFT JOIN Residente r ON v.IdCluster = r.IdCluster AND v.NumeroVivienda = r.NumeroVivienda AND r.EsInquilino = 1
	INNER JOIN Persona per ON r.IdPersona = per.IdPersona
	ORDER BY v.IdCluster, v.NumeroVivienda 


END;
GO
EXEC ReporteViviendas
