CREATE OR ALTER PROCEDURE SPConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

EXEC SPConsultarPorIdLinea @IdLinea = 1