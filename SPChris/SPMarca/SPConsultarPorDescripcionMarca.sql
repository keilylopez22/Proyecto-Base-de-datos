CREATE OR ALTER PROCEDURE SPConsultarPorDescripcionMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

EXEC SPConsultarPorDescripcionMarca @Descripcion = 'Honda'