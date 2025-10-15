CREATE OR ALTER PROCEDURE ConsultarPorIdRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
END;

EXEC ConsultarPorIdRegistroAccesos @IdRegistroAcceso = 4