CREATE OR ALTER PROCEDURE SPBuscarPersonaPorNombreCompleto
@Nombres VARCHAR(60)

AS
BEGIN
	SELECT CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') ,' ' ,P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
	FROM Persona AS P 
	WHERE CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') , ' ',P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
	LIKE '%' + @Nombres + '%' 
	
END;
EXEC SPBuscarPersonaPorNombreCompleto
@Nombres ='Cristian'
