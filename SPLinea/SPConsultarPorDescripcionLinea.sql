--Consulta por descripción
CREATE OR ALTER PROCEDURE ConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

EXEC ConsultarPorDescripcionLinea @Descripcion = 'Corolla'