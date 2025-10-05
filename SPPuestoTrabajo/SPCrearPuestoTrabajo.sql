CREATE OR ALTER PROCEDURE CrearPuestoTrabajo
@Descripcion VARCHAR(50)
AS
BEGIN
INSERT INTO PuestoTrabajo(Descripcion)
VALUES (@Descripcion);
SELECT SCOPE_IDENTITY() AS IdPuestoTrabajo;
END

EXEC CrearPuestoTrabajo
@Descripcion = 'Personal de lavanderia'