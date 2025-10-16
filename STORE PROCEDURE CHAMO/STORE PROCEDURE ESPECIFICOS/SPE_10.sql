-- 10) Construya una consulta que muestre cuántos guardias son hombres y cuántos son mujeres.

CREATE OR ALTER PROCEDURE SPE_10
AS
BEGIN

SELECT p.Genero,pe.Nombre AS Puesto , COUNT(e.IdEmpleado) AS CantidadGenero FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
INNER JOIN PuestoEmpleado pe on e.IdPuestoEmpleado = pe.IdPuestoEmpleado
GROUP BY p.Genero, pe.Nombre
END

EXEC SPE_10

SELECT * FROM Empleado
