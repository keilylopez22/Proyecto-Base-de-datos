--Consulta por llave primaria
CREATE OR ALTER PROCEDURE ConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

EXEC ConsultarPorIdLinea @IdLinea = 1