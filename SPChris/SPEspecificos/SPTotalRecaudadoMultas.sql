--24. Cuanto se ha recaudado por concepto de multas. 
CREATE OR ALTER PROCEDURE TotalRecaudadoMultas
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT 
        COUNT(mv.IdMultaVivienda) AS TotalMultas,
        SUM(mv.Monto) AS TotalRecaudado,
        AVG(mv.Monto) AS PromedioPorMulta,
        SUM(CASE WHEN mv.EstadoPago = 'PAGADO' THEN mv.Monto ELSE 0 END) AS TotalPagado,
        SUM(CASE WHEN mv.EstadoPago = 'PENDIENTE' THEN mv.Monto ELSE 0 END) AS TotalPendiente,
        COUNT(CASE WHEN mv.EstadoPago = 'PAGADO' THEN 1 END) AS MultasPagadas,
        COUNT(CASE WHEN mv.EstadoPago = 'PENDIENTE' THEN 1 END) AS MultasPendientes
    FROM MultaVivienda mv
    WHERE 
        (@FechaInicio IS NULL OR mv.FechaInfraccion >= @FechaInicio)
        AND (@FechaFin IS NULL OR mv.FechaInfraccion <= @FechaFin)
END;

EXEC TotalRecaudadoMultas;

EXEC TotalRecaudadoMultas
    @FechaInicio = '2024-09-01', 
    @FechaFin = '2024-09-30';