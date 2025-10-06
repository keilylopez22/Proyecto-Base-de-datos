-- a. Consulta por llave primaria (IdGarita)
CREATE PROCEDURE ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

EXEC ConsultarPorIdGarita @IdGarita = 1