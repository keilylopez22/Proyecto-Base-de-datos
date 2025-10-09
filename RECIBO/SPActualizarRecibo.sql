
-- actualizar recibo
CREATE OR ALTER PROCEDURE ActualizarRecibo
    @IdRecibo INT,
    @Fecha DATE,
    @ValorTotal DECIMAL(18,2),
    @IdTipoPago INT,
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    UPDATE Recibo
    SET Fecha = @Fecha,
        ValorTotal = @ValorTotal,
        IdTipoPago = @IdTipoPago,
        NumeroVivienda = @NumeroVivienda,
        IdCluster = @IdCluster
    WHERE IdRecibo = @IdRecibo;
END

EXEC ActualizarRecibo
@IdRecibo = 1,
@Fecha = '2025/10/06',
@ValorTotal = 75,
@IdTipoPago = 2,
@NumeroVivienda = 27,
@IdCluster =2

select * from Recibo
select * from Cluster
select * from Vivienda
select * from Servicio