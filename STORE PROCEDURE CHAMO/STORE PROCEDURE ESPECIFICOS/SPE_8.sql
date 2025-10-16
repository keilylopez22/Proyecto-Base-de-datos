-- 8) Construya un procedimiento almacenado que determine quién es la persona que nunca ha sido miembro de una junta directiva. 

CREATE OR ALTER PROCEDURE SPE_8
AS
BEGIN
SELECT CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Miembro, mjd.Estado FROM Persona AS p
LEFT JOIN Propietario pr ON p.IdPersona = pr.IdPersona
LEFT JOIN MiembroJuntaDirectiva mjd ON pr.IdPropietario = mjd.IdPropietario
WHERE mjd.IdJuntaDirectiva IS NULL
END

EXEC SPE_8

SELECT * FROM MiembroJuntaDirectiva