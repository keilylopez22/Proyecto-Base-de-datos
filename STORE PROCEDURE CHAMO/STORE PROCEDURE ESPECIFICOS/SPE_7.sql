-- 7) Construya un procedimiento almacenado que determine qui�n es la persona que m�s ha sido presidente en una junta directiva.
CREATE OR ALTER PROCEDURE SPE_7_MasVecesPresidenteJD
AS
BEGIN
WITH CantidadVeces AS (
SELECT COUNT(*) AS Cantidad, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Miembro, pjd.Nombre AS Puesto FROM Persona AS p
INNER JOIN Propietario pr ON p.IdPersona = pr.IdPersona
INNER JOIN MiembroJuntaDirectiva mjd ON pr.IdPropietario = mjd.IdPropietario
INNER JOIN PuestoJuntaDirectiva pjd ON mjd.idPuesto = pjd.idPuesto
INNER JOIN JuntaDirectiva jd ON mjd.IdJuntaDirectiva = jd.IdJuntaDirectiva
WHERE pjd.Nombre = 'Presidente' 
GROUP BY CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' '), pjd.Nombre
)
SELECT * FROM CantidadVeces
WHERE Cantidad = (SELECT MAX(Cantidad) FROM CantidadVeces)
END

EXEC SPE_7_MasVecesPresidenteJD

