-- c. Consulta por fecha de entrada
CREATE OR ALTER PROCEDURE ConsultarPorFechaEntradaRegistroVehiculos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroVehiculos WHERE CAST(FechaHoraEntrada AS DATE) = @Fecha
END;

EXEC ConsultarPorFechaEntradaRegistroVehiculos @Fecha = '2025-10-01';