CREATE OR ALTER PROCEDURE CrearEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado VARCHAR(30),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN
	INSERT INTO Empleado (IdPersona)
	VALUES(@IdPersona);
	SELECT SCOPE_IDENTITY() AS IdEmpleadoCreado;
END;
--Ejemplo Crear Persona
Exec CrearEmpleado
@IdPersona  = 21;


