--Construir un procedimiento almacenado que muestre los vehículos que pertenecen a una persona
--que ingresa todos los días entre las 23 horas de un día y la 1 am del día siguiente. Debe recibir
--como parámetro las fechas (del, al).

CREATE OR ALTER PROCEDURE VehiculosDePersonas 
@FechaInicio DATE,
@FechaFin  DATE
AS
BEGIN 
		SELECT CONCAT(p.PrimerNombre, ' ',P.PrimerApellido) AS NombreCompleto, m.Descripcion
		FROM RegistroAccesos AS ra
		INNER JOIN Residente AS r
		ON ra.IdResidente = r.IdResidente
		INNER JOIN Persona AS P 
		ON r.IdPersona = p.IdPersona
		INNER JOIN Vehiculo AS vh
		ON ra.IdVehiculo = vh.IdVehiculo
		INNER JOIN Linea AS l 
		ON vh.IdLinea = l.IdLinea 
		INNER JOIN Marca AS m 
		ON l.IdMarca = m.IdMarca
		WHERE ra.FechaIngreso >= @FechaInicio AND ra.FechaIngreso  < DATEADD(DAY,1, @FechaFin)
			  AND (DATEPART (HOUR, ra.FechaIngreso)= 23
			  OR  DATEPART(HOUR, ra.FechaIngreso) = 0 
			  OR  DATEPART(HOUR, ra.FechaIngreso)= 1)
		ORDER BY ra.FechaIngreso;


END;
EXEC VehiculosDePersonas 
@FechaInicio = '2025-10-14',
@FechaFin   = '2025-10-15'