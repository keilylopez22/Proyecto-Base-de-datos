-- Consulta por modelo de Vehiculo
CREATE OR ALTER PROCEDURE ConsultarPorModeloVehiculo
    @Modelo VARCHAR(30)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Modelo LIKE '%' + @Modelo + '%'
END;

EXEC ConsultarPorModeloVehiculo @Modelo = 'Sedan';