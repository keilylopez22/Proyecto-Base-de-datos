CREATE OR ALTER TRIGGER TR_ActualizarMontoTotalPago
ON DetallePago
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualiza el MontoTotal en Pago sumando los montos insertados
    UPDATE p
    SET MontoTotal = ISNULL(p.MontoTotal, 0) + i.MontoTotalDetalle
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
    SET EstadoPago = 'PAGADO'
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


--Generar  Cobro mensual de cada vivienda 
Select * from CobroServicioVivienda
INSERT INTO CobroServicioVivienda(FechaCobro,Monto,EstadoPago,IdServicio,NumeroVivienda, IdCluster)
SELECT CAST(GETDATE()AS Date ) ,S.Tarifa, 'PENDIENTE', S.IdServicio , V.NumeroVivienda, V.IdCluster 
FROM Servicio AS S, Vivienda AS V
WHERE V.IdCluster = 1


SELECT * FROM Recibo
EXEC SP_SelectAllRecibo