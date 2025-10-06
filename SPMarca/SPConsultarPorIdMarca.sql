-- Consulta por llave primaria
CREATE PROCEDURE ConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

EXEC ConsultarPorIdMarca @IdMarca = 1