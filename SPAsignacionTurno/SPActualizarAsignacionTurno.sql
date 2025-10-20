CREATE OR ALTER PROCEDURE ActualizarAsignacionTurno
@IdAsignacionTurno INT,
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN 
	UPDATE AsignacionTurno
		SET FechaAsignacion = @FechaAsignacion,
		IdEmpleado = @IdEmpleado,
		IdTurno = @IdTurno
		WHERE IdAsignacionTurno = @IdAsignacionTurno
		SELECT @IdAsignacionTurno 
END;

EXEC ActualizarAsignacionTurno
@IdAsignacionTurno = 3,
@FechaAsignacion = '2025-10-03',
@IdEmpleado = 1,
@IdTurno = 4;


SELECT * FROM AsignacionTurno