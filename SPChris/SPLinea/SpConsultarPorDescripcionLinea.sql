CREATE OR ALTER PROCEDURE SPConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

EXEC SPConsultarPorDescripcionLinea @Descripcion = 'Corolla'