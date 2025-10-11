CREATE OR ALTER PROCEDURE SP_ActualizarEmpleados
@IdEmpleado INT,
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS 
BEGIN
UPDATE Empleado
SET FechaAlta = @FechaAlta,
FechaBaja = @FechaBaja,
Estado = @Estado,
IdPersona = @IdPersona,
IdPuestoEmpleado = @IdPuestoEmpleado
WHERE IdEmpleado = @IdEmpleado
END

--EXEC SP_ActualizarEmpleados
--@IdEmpleado = 1,
--@FechaAlta = ,
--@FechaBaja = ,
--@Estado = 'Activo',
--@IdPersona = 1,
--@IdPuestoEmpleado = 1,