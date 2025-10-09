
-- buscar recibos por numero de vivienda u cluster
CREATE OR ALTER PROCEDURE BuscarReciboPorNumeroVivienda
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT 
        IdRecibo,
        Fecha,
        ValorTotal,
        IdTipoPago,
        NumeroVivienda,
        IdCluster
    FROM Recibo
    WHERE NumeroVivienda = @NumeroVivienda
      AND IdCluster = @IdCluster;
END;
GO
Exec BuscarReciboPorNumeroVivienda
@NumeroVivienda = 27,
@IdCluster = 2
select * from Recibo
