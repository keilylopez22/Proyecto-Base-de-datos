CREATE OR ALTER PROCEDURE SP_SelectAllEmpleado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @NombreFilter VARCHAR(50) = NULL,
    @PuestoFilter VARCHAR(50) = NULL
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
    WHERE
        (@NombreFilter IS NULL 
            OR P.PrimerNombre LIKE '%' + @NombreFilter + '%'
            OR P.PrimerApellido LIKE '%' + @NombreFilter + '%')
        AND (@PuestoFilter IS NULL OR PE.Nombre LIKE '%' + @PuestoFilter + '%')
    ORDER BY E.IdEmpleado
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

 
    SELECT COUNT(*) AS TotalCount
    FROM Empleado AS E
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON E.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
        (@NombreFilter IS NULL 
            OR P.PrimerNombre LIKE '%' + @NombreFilter + '%'
            OR P.PrimerApellido LIKE '%' + @NombreFilter + '%')
        AND (@PuestoFilter IS NULL OR PE.Nombre LIKE '%' + @PuestoFilter + '%');
END;


EXEC SP_SelectAllEmpleado 
    @PageIndex = 1,
    @PageSize = 10,
    @NombreFilter = 'Cristian',
    @PuestoFilter = 'Guardia';

	SELECT * FROM Empleado WHERE IdEmpleado = 1;
