--Crear empleados
CREATE OR ALTER PROCEDURE CrearEmpleado
@IdPersona INT
AS
BEGIN
	INSERT INTO Empleado (IdPersona)
	VALUES(@IdPersona);
	SELECT SCOPE_IDENTITY() AS IdEmpleadoCreado;
END;
--Ejemplo Crear Persona
Exec CrearEmpleado
@IdPersona  = 21;


