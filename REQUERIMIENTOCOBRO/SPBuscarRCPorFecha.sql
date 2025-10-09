--Buscar requerimiento cobro por fecha 
CREATE OR ALTER PROCEDURE BuscarRCPorFecha
    @Fecha DATE 
AS
BEGIN
    SELECT @fecha AS Fecha, IdServicio, NumeroVivienda, IdCluster
    FROM RequerimientoCobro
    WHERE 
         Fecha = @Fecha
    ORDER BY Fecha;
END;
GO
EXEC BuscarRCPorFecha
    @Fecha = '2025-10-07'


Select * from  RequerimientoCobro