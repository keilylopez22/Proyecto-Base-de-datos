CREATE OR ALTER PROCEDURE ActualizarEmpleado
@IdPersona INT,
@IdEmpleado INT
AS 
BEGIN
	UPDATE Empleado
	SET IdPersona = @IdPersona
	WHERE IdEmpleado = @IdEmpleado;
END

EXEC ActualizarEmpleado 
@IdPersona = 1,
@IdEmpleado = 1