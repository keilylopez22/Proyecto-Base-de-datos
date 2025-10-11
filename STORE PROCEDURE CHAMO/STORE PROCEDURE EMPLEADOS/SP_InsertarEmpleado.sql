CREATE OR ALTER PROCEDURE SP_InsertarEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN
INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
    VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);
END