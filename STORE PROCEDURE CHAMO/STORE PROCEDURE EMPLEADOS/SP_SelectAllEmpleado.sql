CREATE OR ALTER PROCEDURE SP_SelectAllEmpleado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @IdEmpleadoFilter INT = NULL,
    @PrimerNombreFilter VARCHAR(50) = NULL,
    @PrimerApellidoFilter VARCHAR(50) = NULL,
    @IdPuestoFilter INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        E.IdEmpleado,
        (P.PrimerNombre + ' ' + P.PrimerApellido) AS NombreCompleto,
        E.Estado,
        E.FechaAlta,
        E.FechaBaja,
        P.IdPersona,
        E.IdPuestoEmpleado
    FROM Empleado AS E
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON E.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE (@IdEmpleadoFilter IS NULL OR E.IdEmpleado = @IdEmpleadoFilter)
        AND (@PrimerNombreFilter IS NULL OR P.PrimerNombre LIKE @PrimerNombreFilter + '%')
        AND (@PrimerApellidoFilter IS NULL OR P.PrimerApellido LIKE @PrimerApellidoFilter + '%')
        AND (@IdPuestoFilter IS NULL OR E.IdPuestoEmpleado = @IdPuestoFilter)
    ORDER BY E.IdEmpleado
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

 
    SELECT COUNT(*) AS TotalCount
    FROM Empleado AS E
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON E.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
        (@IdEmpleadoFilter IS NULL OR E.IdEmpleado = @IdEmpleadoFilter)
        AND (@PrimerNombreFilter IS NULL OR P.PrimerNombre LIKE @PrimerNombreFilter + '%')
        AND (@PrimerApellidoFilter IS NULL OR P.PrimerApellido LIKE @PrimerApellidoFilter + '%')
        AND (@IdPuestoFilter IS NULL OR E.IdPuestoEmpleado = @IdPuestoFilter)
END;

