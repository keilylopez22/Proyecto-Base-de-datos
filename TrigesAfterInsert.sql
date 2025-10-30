CREATE OR ALTER TRIGGER TR_ActualizarMontoTotalPago
ON DetallePago
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualiza el MontoTotal en Pago sumando los montos insertados
    UPDATE p
    SET MontoTotal = ISNULL(p.MontoTotal, 0) + i.MontoTotalDetalle,
    Saldo = ISNULL(p.MontoTotal, 0) + i.MontoTotalDetalle
    FROM Pago p
    INNER JOIN (
        SELECT IdPago, SUM(Monto) AS MontoTotalDetalle
        FROM inserted
        GROUP BY IdPago
    ) i ON p.IdPago = i.IdPago;
END;

GO

CREATE OR ALTER TRIGGER TR_ActualizarEstadoPagos
ON DetalleRecibo
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar CobroServicioVivienda
    UPDATE csv
    SET EstadoPago = 'PAGADO',
    MontoAplicado = Monto
    FROM CobroServicioVivienda csv
    INNER JOIN inserted i ON csv.idCobroServicio = i.idCobroServicio
    WHERE i.idCobroServicio IS NOT NULL;

    -- Actualizar MultaVivienda
    UPDATE mv
    SET EstadoPago = 'PAGADO'
    FROM MultaVivienda mv
    INNER JOIN inserted i ON mv.IdMultaVivienda = i.IdMultaVivienda
    WHERE i.IdMultaVivienda IS NOT NULL;
END;
GO

CREATE OR ALTER TRIGGER TR_ActualizarMontoLiquidadoYSaldo
ON DetalleRecibo
AFTER INSERT
AS
BEGIN
    

    -- Tabla temporal para acumular montos por IdPago
    DECLARE @MontosPorPago TABLE (
        IdPago INT,
        MontoAdicional DECIMAL(18,2)
    );

    -- 1. Obtener montos de CobroServicioVivienda
    INSERT INTO @MontosPorPago (IdPago, MontoAdicional)
    SELECT 
        r.IdPago,
        SUM(csv.Monto)
    FROM inserted i
    INNER JOIN Recibo r ON i.IdRecibo = r.IdRecibo
    INNER JOIN CobroServicioVivienda csv ON i.idCobroServicio = csv.idCobroServicio
    WHERE i.idCobroServicio IS NOT NULL
    GROUP BY r.IdPago;

    -- 2. Obtener montos de MultaVivienda
    INSERT INTO @MontosPorPago (IdPago, MontoAdicional)
    SELECT 
        r.IdPago,
        SUM(mv.Monto)
    FROM inserted i
    INNER JOIN Recibo r ON i.IdRecibo = r.IdRecibo
    INNER JOIN MultaVivienda mv ON i.IdMultaVivienda = mv.IdMultaVivienda
    WHERE i.IdMultaVivienda IS NOT NULL
    GROUP BY r.IdPago;

    -- 3. Actualizar MontoLiquidado y Saldo en Pago
    UPDATE p
    SET 
        MontoLiquidado = ISNULL(p.MontoLiquidado, 0) + m.MontoTotalAdicional,
        Saldo = p.MontoTotal - (ISNULL(p.MontoLiquidado, 0) + m.MontoTotalAdicional)
    FROM Pago p
    INNER JOIN (
        SELECT IdPago, SUM(MontoAdicional) AS MontoTotalAdicional
        FROM @MontosPorPago
        GROUP BY IdPago
    ) m ON p.IdPago = m.IdPago;
END;

GO
--Generar  Cobro mensual de cada vivienda 
Select * from CobroServicioVivienda
INSERT INTO CobroServicioVivienda(FechaCobro,Monto,EstadoPago,IdServicio,NumeroVivienda, IdCluster)
SELECT CAST(GETDATE()AS Date ) ,S.Tarifa, 'PENDIENTE', S.IdServicio , V.NumeroVivienda, V.IdCluster 
FROM Servicio AS S, Vivienda AS V
WHERE V.IdCluster = 1


SELECT * FROM Recibo
EXEC SP_SelectAllRecibo