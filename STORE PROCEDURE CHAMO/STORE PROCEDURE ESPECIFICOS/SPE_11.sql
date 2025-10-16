-- 11) Determine quién es el vecino que más veces ingresa y sale del condominio los días domingo.
CREATE OR ALTER PROCEDURE SPE_11
AS
BEGIN

SELECT TOP 1 CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Vecino, COUNT(*) AS CantidadSalidasDomingo FROM Garita AS g
INNER JOIN RegistroAccesos ra ON g.IdGarita = ra.IdGarita
INNER JOIN Residente r ON ra.IdResidente = r.IdResidente
INNER JOIN Persona p ON r.IdPersona = p.IdPersona
INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
WHERE DATEPART(WEEKDAY, ra.FechaSalida) = '1'
GROUP BY p.PrimerNombre, p.PrimerApellido

END

EXEC SPE_11

SELECT * FROM RegistroAccesos

EXEC InsertarRegistroAccesos
    @FechaIngreso = '2024-10-13 14:00:00',
    @FechaSalida = '2024-10-13 15:00:00',
    @IdVehiculo = 1,
    @IdGarita = 1,
    @IdVisitante = NULL,
    @IdResidente = 3,
    @IdEmpleado = 1;


