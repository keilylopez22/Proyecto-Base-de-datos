CREATE OR ALTER PROCEDURE SPConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

EXEC SPConsultarPorIdMarca @IdMarca = 1