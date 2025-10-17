----Construya un procedimiento almacenado que muestre todos los propietarios de condominio
--Diana II que son casados y menores de 30 años.
CREATE OR ALTER PROCEDURE PropietariosCondomio 
AS
BEGIN 
		SELECT c.Descripcion, CONCAT(per.PrimerNombre, '', per.PrimerApellido) AS NombreCompleto, DATEDIFF (YEAR, per.FechaNacimiento, GETDATE()) AS Edad, per.EstadoCivil
		FROM Propietario AS Pro
		INNER JOIN Persona AS per ON pro.IdPersona = per.IdPersona
		INNER JOIN Vivienda AS v ON pro.IdPropietario = v.IdPropietario
		INNER JOIN Cluster AS c ON v.IdCluster = c.IdCluster
		WHERE C.Descripcion = 'Diana II'
		AND DATEDIFF (YEAR, per.FechaNacimiento, GETDATE())< 30
		AND (per.EstadoCivil = 'Casado' or per.EstadoCivil = 'Casada');
END;
EXEC PropietariosCondomio
