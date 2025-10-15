CREATE OR ALTER PROCEDURE ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

EXEC ConsultarPorIdGarita @IdGarita = 1;