CREATE OR ALTER PROCEDURE SP_InsertarEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN

 
    IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
    BEGIN
        RAISERROR('No existe esta persona en la base de datos', 16,1)
        RETURN 
    END

    IF EXISTS(
    SELECT 1 
    FROM Empleado 
    WHERE IdPersona = @IdPersona AND Estado = 'ACTIVO')
    BEGIN
        RAISERROR('Esta persona ya es un empleado en actividad',16,1)
        RETURN 
    END

    INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
        VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);
END

EXEC SP_InsertarEmpleado
@FechaAlta = '2025-01-10',
@FechaBaja = '2025-10-10',
@Estado = 'ACTIVO',
@IdPersona = 1,
@IdPuestoEmpleado = 2


EXEC SP_InsertarEmpleado
@FechaAlta = '2023-05-05',
@FechaBaja ='',
@Estado ='ACTIVO',
@IdPersona =21,
@IdPuestoEmpleado =3

SELECT * FROM Empleado



