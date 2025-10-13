CREATE OR ALTER PROCEDURE SP_EliminarEmpleado 
@IdEmpleado INT
AS
Begin

SET NOCOUNT ON
IF EXISTS (SELECT 1 FROM AsignacionTurno WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No se puede elminar al empleado ya que tiene asigandos turnos',16,1)
RETURN 
END

IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No existe el empleado con el IdEmpleado especificado',16,1)
RETURN
END
	Delete FROM Empleado
	Where IdEmpleado = @IdEmpleado;
End;

EXEC SP_EliminarEmpleado
@IdEmpleado = 1;