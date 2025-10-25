CREATE OR ALTER PROCEDURE SP_ActualizarEmpleados
@IdEmpleado INT = NULL,
@FechaAlta DATE = NULL,
@FechaBaja DATE = NULL,
@Estado varchar(10) = NULL,
@IdPersona INT = NULL,
@IdPuestoEmpleado INT = NULL
AS 
BEGIN

SET NOCOUNT ON
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN
RAISERROR('Este empleado no existe',16,1)
RETURN 
END

UPDATE Empleado
SET FechaAlta = @FechaAlta,
FechaBaja = @FechaBaja,
Estado = @Estado,
IdPersona = @IdPersona,
IdPuestoEmpleado = @IdPuestoEmpleado
WHERE IdEmpleado = @IdEmpleado
END TRY
BEGIN CATCH
RAISERROR('Error al intentar actulizar al empleado dado por que no existe',16,1)
END CATCH
END

--EXEC SP_ActualizarEmpleados
--@IdEmpleado = 1,
--@FechaAlta = ,
--@FechaBaja = ,
--@Estado = 'Activo',
--@IdPersona = 1,
--@IdPuestoEmpleado = 1,