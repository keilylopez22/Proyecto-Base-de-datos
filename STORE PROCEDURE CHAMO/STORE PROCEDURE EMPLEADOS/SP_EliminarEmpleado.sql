CREATE OR ALTER PROCEDURE SP_EliminarEmpleado 
@IdEmpleado INT
AS
Begin
	Delete FROM Empleado
	Where IdEmpleado = @IdEmpleado;
End;

EXEC SP_EliminarEmpleado
@IdEmpleado = 1;