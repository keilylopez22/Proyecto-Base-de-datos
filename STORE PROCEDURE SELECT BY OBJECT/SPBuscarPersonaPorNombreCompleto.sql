CREATE OR ALTER PROCEDURE SPBuscarPersonaPorNombreCompleto
@Nombres VARCHAR(60),
@Apellidos VARCHAR(60)
AS
BEGIN
	SELECT CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '')) AS Nombres, CONCAT(P.PrimerApellido, ' ' ,COALESCE(p.SegundoApellido, '' )) AS Apellidos
	FROM Persona AS P 
	WHERE p.PrimerNombre = @Nombres AND P.PrimerApellido = @Apellidos
END;
EXEC SPBuscarPersonaPorNombreCompleto
@Nombres ='Cristian',
@Apellidos = 'Chamo'