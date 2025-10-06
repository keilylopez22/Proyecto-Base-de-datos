--Consulta por marca
CREATE OR ALTER PROCEDURE ConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

EXEC ConsultarPorMarcaLinea @IdMarca = 1