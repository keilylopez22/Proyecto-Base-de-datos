CREATE OR ALTER PROCEDURE SP_ActualizarAsignacionTurno
@IdAsignacionTurno INT,
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN 
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdAsignacionTurno = @IdAsignacionTurno)
BEGIN
RAISERROR('No se encontro la asiganacion',16,1)
RETURN
END

UPDATE AsignacionTurno
SET FechaAsignacion = @FechaAsignacion,
IdEmpleado = @IdEmpleado,
IdTurno = @IdTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno
END

EXEC SP_ActualizarAsignacionTurno
@IdAsignacionTurno = 13,
@FechaAsignacion = '2025-10-03',
@IdEmpleado = 1,
@IdTurno = 2