CREATE OR ALTER PROCEDURE SPBuscarPersonaPorCui
@NumeroDeIdentificacion VARCHAR(30)
AS
BEGIN
	SELECT CONCAT(P.PrimerNombre, ' ', P.PrimerApellido) AS Nombre, P.Cui As 'Numero de Identificacion'
	FROM PERSONA AS P
	WHERE Cui = @NumeroDeIdentificacion
END;
EXEC SPBuscarPersonaPorCui
@NumeroDeIdentificacion = '09072321839'
