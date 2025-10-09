--buscar por fecha
CREATE OR ALTER PROCEDURE BuscarPlanillaFecha
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL
AS
BEGIN
    SELECT P.Fecha,
		   P.IdPlanilla,
           P.Descripcion,
           P.IdRecibo
    FROM Planilla P
    INNER JOIN Recibo R ON P.IdRecibo = R.IdRecibo
    WHERE 
        (@FechaInicio IS NULL OR P.Fecha >= @FechaInicio)
        AND (@FechaFin IS NULL OR P.Fecha <= @FechaFin)
    ORDER BY P.Fecha;
END;
GO
EXEC BuscarPlanillaFecha
    @FechaInicio = '2025-10-01', 
    @FechaFin = '2025-10-31';