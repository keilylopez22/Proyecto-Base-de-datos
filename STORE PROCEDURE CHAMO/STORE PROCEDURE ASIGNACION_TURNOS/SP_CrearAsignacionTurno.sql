CREATE OR ALTER PROCEDURE SP_CrearAsignacionTurno
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN 
RAISERROR('No existe este empleado',16,1)
RETURN
END


INSERT INTO AsignacionTurno(FechaAsignacion, IdEmpleado, IdTurno)
VALUES(@FechaAsignacion,@IdEmpleado, @IdTurno)
END

EXEC SP_CrearAsignacionTurno
@FechaAsignacion = '2025-10-15',
@IdEmpleado = 1,
@IdTurno = 3
