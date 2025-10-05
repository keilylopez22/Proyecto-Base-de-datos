Create OR Alter Procedure EliminarEmpleado
@IdEmpleado INT
AS
Begin
	Delete FROM Empleado
	Where IdEmpleado = @IdEmpleado;
End;

EXEC EliminarEmpleado
@IdEmpleado = 10;