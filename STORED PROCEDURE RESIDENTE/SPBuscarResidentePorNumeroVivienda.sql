CREATE OR ALTER  PROCEDURE PSBuscarResidentePorNumVivienda
@NumeroVivienda INT
AS
BEGIN
	 SELECT CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, ''))AS 'Residente',R.IdResidente, R.NumeroVivienda, R.IdCluster
	 FROM Residente AS R
	 INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona 
	 WHERE NumeroVivienda = @NumeroVivienda
END;

EXEC PSBuscarResidentePorNumVivienda
@NumeroVivienda = 101