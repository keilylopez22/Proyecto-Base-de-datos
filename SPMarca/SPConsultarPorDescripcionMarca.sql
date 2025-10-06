--Consultar por descripcion exacte de la marca del vehiculo
CREATE OR ALTER PROCEDURE ConsultarPorDescripcionExactaMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

EXEC ConsultarPorDescripcionExactaMarca @Descripcion = 'Toyota'