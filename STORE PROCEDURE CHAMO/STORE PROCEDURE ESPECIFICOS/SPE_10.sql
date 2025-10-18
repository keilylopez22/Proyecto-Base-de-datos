-- 10) Construya una consulta que muestre cu�ntos guardias son hombres y cu�ntos son mujeres.

CREATE OR ALTER PROCEDURE SPE_10_CantidadGuardiasHombreMujeres
AS
BEGIN

SELECT p.Genero,pe.Nombre AS Puesto , COUNT(e.IdEmpleado) AS CantidadGenero FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
INNER JOIN PuestoEmpleado pe on e.IdPuestoEmpleado = pe.IdPuestoEmpleado
WHERE pe.Nombre = 'Guardia'
GROUP BY p.Genero, pe.Nombre
END

EXEC SPE_10_CantidadGuardiasHombreMujeres