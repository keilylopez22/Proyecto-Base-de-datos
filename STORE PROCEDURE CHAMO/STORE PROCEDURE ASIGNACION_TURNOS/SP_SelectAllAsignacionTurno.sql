CREATE OR ALTER PROCEDURE SP_SelectAllAsignacionDeTurno
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @IdEmpleado INT = NULL,
    @IdTurno INT = NULL,
    @FechaFilter DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT
        AT.IdAsignacionTurno,
        (P.PrimerNombre + ' ' + P.PrimerApellido) AS NombreCompleto,
        T.Descripcion AS Turno,
        AT.FechaAsignacion,
        AT.IdEmpleado,
        AT.IdTurno
    FROM AsignacionTurno AS AT
    INNER JOIN Empleado AS E ON AT.IdEmpleado = E.IdEmpleado
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN Turno AS T ON AT.IdTurno = T.IdTurno
    WHERE
        (@IdEmpleado IS NULL OR AT.IdEmpleado = @IdEmpleado)
        AND (@IdTurno IS NULL OR AT.IdTurno = @IdTurno)
        AND (@FechaFilter IS NULL OR AT.FechaAsignacion = @FechaFilter)
    ORDER BY AT.IdAsignacionTurno
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM AsignacionTurno AS AT
    WHERE
        (@IdEmpleado IS NULL OR AT.IdEmpleado = @IdEmpleado)
        AND (@IdTurno IS NULL OR AT.IdTurno = @IdTurno)
        AND (@FechaFilter IS NULL OR AT.FechaAsignacion = @FechaFilter);
END;
GO
