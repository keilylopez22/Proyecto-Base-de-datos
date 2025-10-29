CREATE OR ALTER PROCEDURE SP_ActualizarLosEmpleados
@IdEmpleado INT,
@FechaAlta DATE = NULL,
@FechaBaja DATE = NULL,
@Estado varchar(10) = NULL,
@IdPersona INT,
@IdPuestoEmpleado INT = NULL
AS 
BEGIN

SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN
RAISERROR('Este empleado no existe',16,1)
RETURN 
END

UPDATE Empleado
SET FechaAlta = Isnull(@FechaAlta,FechaAlta),
FechaBaja = Isnull(@FechaBaja,FechaBaja),
Estado = Isnull(@Estado,Estado),
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