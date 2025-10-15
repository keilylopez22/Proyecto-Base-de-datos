CREATE OR ALTER PROCEDURE ConsultarPorFechaIngresoRegistroAccesos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE CAST(FechaIngreso AS DATE) = @Fecha
END;

EXEC ConsultarPorFechaIngresoRegistroAccesos @Fecha = '2024-10-09'