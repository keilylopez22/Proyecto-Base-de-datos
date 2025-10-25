CREATE OR ALTER PROCEDURE SP_SelectAllVehiculoProhibido
    @PageIndex INT = 1,
    @PageSize INT = 5,
    @PlacaFilter VARCHAR(20) = NULL,
    @MotivoFilter VARCHAR(50) = NULL,
    @FechaFilter DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        VP.IdVehiculoProhibido,
        V.Placa,
        m.Descripcion AS Marca,
        l.Descripcion AS Linea,
		VP.Motivo,
        VP.Fecha,
        VP.IdVehiculo
    FROM VehiculoProhibido AS VP
    INNER JOIN Vehiculo AS V ON VP.IdVehiculo = V.IdVehiculo
	INNER JOIN Marca m ON V.IdMarca = m.IdMarca
	INNER JOIN Linea l ON m.IdMarca = l.IdMarca
    WHERE
        (@PlacaFilter IS NULL OR V.Placa LIKE '%' + @PlacaFilter + '%')
        AND (@MotivoFilter IS NULL OR VP.Motivo LIKE '%' + @MotivoFilter + '%')
        AND (@FechaFilter IS NULL OR VP.Fecha = @FechaFilter)
    ORDER BY VP.IdVehiculoProhibido
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM VehiculoProhibido AS VP
    INNER JOIN Vehiculo AS V ON VP.IdVehiculo = V.IdVehiculo
    WHERE
        (@PlacaFilter IS NULL OR V.Placa LIKE '%' + @PlacaFilter + '%')
        AND (@MotivoFilter IS NULL OR VP.Motivo LIKE '%' + @MotivoFilter + '%')
        AND (@FechaFilter IS NULL OR VP.Fecha = @FechaFilter);
END

EXEC SP_SelectAllVehiculoProhibido 

