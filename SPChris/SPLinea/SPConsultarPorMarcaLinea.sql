CREATE OR ALTER PROCEDURE SPConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

EXEC SPConsultarPorMarcaLinea @IdMarca = 1