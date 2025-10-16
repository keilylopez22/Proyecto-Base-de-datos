-- 9) Construya un procedimiento almacenado que dado un periodo tiempo determine si un guardia ha trabajado más de 24 horas en un turno.

--Cambie el tipo de dato de HoraInicio y HoraFin de VARCHAR a TIME
--cambiar HoraInicio a TIME
GO
ALTER TABLE Turno
ALTER COLUMN HoraInicio TIME;

GO

GO
--cambiar HoraFin a TIME
ALTER TABLE Turno
ALTER COLUMN HoraFin TIME;

GO

GO
CREATE OR ALTER PROCEDURE SPE_9
AS 
BEGIN

SELECT e.IdEmpleado, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido, ' ') AS Empleado, pe.Nombre AS Puesto, t.IdTurno, t.Descripcion AS Turno, ta.FechaAsignacion, t.HoraInicio, t.HoraFin FROM Turno AS t
INNER JOIN AsignacionTurno ta ON t.IdTurno = ta.IdTurno
INNER JOIN Empleado e ON ta.IdEmpleado = e.IdEmpleado
INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE pe.Nombre = 'Guardia' AND DATEDIFF(HOUR, t.HoraInicio, t.HoraFin) > 24   
END

GO

EXEC SPE_9

SELECT * FROM Turno



