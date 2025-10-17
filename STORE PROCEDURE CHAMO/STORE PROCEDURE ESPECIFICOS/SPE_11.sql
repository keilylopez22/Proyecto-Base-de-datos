-- 11) Determine qui�n es el vecino que m�s veces ingresa y sale del condominio los d�as domingo.
CREATE OR ALTER PROCEDURE SPE_11_VecinoConMasSalidasDomingo
AS
BEGIN

SELECT TOP 1 CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Vecino, COUNT(*) AS CantidadSalidasEntradas FROM Garita AS g
INNER JOIN RegistroAccesos ra ON g.IdGarita = ra.IdGarita
INNER JOIN Residente r ON ra.IdResidente = r.IdResidente
INNER JOIN Persona p ON r.IdPersona = p.IdPersona
INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
WHERE DATEPART(WEEKDAY, ra.FechaIngreso) = '1' OR DATEPART(WEEKDAY, ra.FechaSalida) = '1'
GROUP BY p.PrimerNombre, p.PrimerApellido
ORDER BY CantidadSalidasEntradas

END

EXEC SPE_11_VecinoConMasSalidasDomingo


--Este exec es por si quieren insertar un registro y probar el procedimiento almacenado
EXEC InsertarRegistroAccesos
    @FechaIngreso = '2024-10-13 14:00:00',
    @FechaSalida = '2024-10-13 15:00:00',
    @IdVehiculo = 1,
    @IdGarita = 1,
    @IdVisitante = NULL,
    @IdResidente = 3,
    @IdEmpleado = 1;

SELECT * FROM RegistroAccesos

