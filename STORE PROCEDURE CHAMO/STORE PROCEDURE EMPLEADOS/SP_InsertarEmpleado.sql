CREATE OR ALTER PROCEDURE SP_InsertarEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
BEGIN
RAISERROR('No existe esta persona en la base de datos', 16,1)
RETURN 
END

IF EXISTS(SELECT 1 FROM Empleado WHERE IdPersona = @IdPersona AND Estado = 'Activo')
BEGIN
RAISERROR('Esta persona ya es un empleado en actividad',16,1)
RETURN 
END

INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
    VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);
END TRY
BEGIN CATCH
RAISERROR('Error al insertar el empleado',16,1)
END CATCH
END