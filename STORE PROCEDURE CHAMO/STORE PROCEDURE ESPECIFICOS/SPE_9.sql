-- 9) Construya un procedimiento almacenado que dado un periodo tiempo determine si un guardia ha trabajado más de 24 horas en un turno.

--Cambie el tipo de dato de HoraInicio y HoraFin de VARCHAR a DATETIME

GO
ALTER TABLE Turno
ALTER COLUMN HoraInicio DATETIME;

GO

GO

ALTER TABLE Turno
ALTER COLUMN HoraFin DATETIME;

GO

CREATE OR ALTER PROCEDURE SPE_9
@FechaInicio DATE,
@FechaFin DATE,
@IdTurno INT
AS 
BEGIN

SELECT e.IdEmpleado, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Empleado, pe.Nombre AS Puesto,t.Descripcion AS Turno ,COUNT(ta.IdTurno) AS CantidadTurnos, 
SUM(CASE 
WHEN t.HoraFin < t.HoraInicio 
THEN DATEDIFF(HOUR, t.HoraInicio, DATEADD(DAY, 1, t.HoraFin))
ELSE DATEDIFF(HOUR,t.HoraInicio, t.HoraFin )
END
) AS Horas FROM Turno AS t
INNER JOIN AsignacionTurno ta ON t.IdTurno = ta.IdTurno
INNER JOIN Empleado e ON ta.IdEmpleado = e.IdEmpleado
INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE pe.Nombre = 'Guardia' AND ta.FechaAsignacion BETWEEN @FechaInicio AND @FechaFin AND t.IdTurno = @IdTurno
GROUP by e.IdEmpleado, pe.Nombre, p.PrimerNombre, p.PrimerApellido, t.Descripcion
HAVING COUNT(ta.IdTurno) > 3 OR SUM(CASE 
WHEN t.HoraFin < t.HoraInicio 
THEN DATEDIFF(HOUR, t.HoraInicio, DATEADD(DAY, 1, t.HoraFin))
ELSE DATEDIFF(HOUR,t.HoraInicio, t.HoraFin )
END
) > 24
END

EXEC SPE_9
@FechaInicio = '2025-10-10',
@FechaFin = '2025-10-15',
@IdTurno = 1

SELECT * FROM AsignacionTurno

