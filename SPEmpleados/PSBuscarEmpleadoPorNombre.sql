CREATE OR ALTER PROCEDURE PSBuscarEmpleadoPorNombre
@PrimerNombre VARCHAR(50),
@PrimerApellido VARCHAR(50)
AS
BEGIN
SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto  FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
WHERE p.PrimerNombre = @PrimerNombre AND p.PrimerApellido = @PrimerApellido
END

EXEC PSBuscarEmpleadoPorNombre
@PrimerNombre = 'Cristian',
@PrimerApellido = 'Chamo'



