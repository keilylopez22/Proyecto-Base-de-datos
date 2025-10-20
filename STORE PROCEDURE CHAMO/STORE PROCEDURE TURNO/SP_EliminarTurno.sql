CREATE OR ALTER PROCEDURE SP_EliminarTurno
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('No existe este turno',16,1)
RETURN
END 

IF EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('Este turno tiene empleados asignados',16,1)
RETURN
END

DELETE FROM Turno
WHERE IdTurno = @IdTurno
END

EXEC SP_EliminarTurno
@IdTurno = 1
