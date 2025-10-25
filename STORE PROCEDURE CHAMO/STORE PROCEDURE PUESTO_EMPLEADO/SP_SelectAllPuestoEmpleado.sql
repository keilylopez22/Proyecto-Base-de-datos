CREATE OR ALTER PROCEDURE SP_SelectAllPuestoEmpleado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @NombreFilter VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        IdPuestoEmpleado,
        Nombre,
        Descripcion
    FROM PuestoEmpleado
    WHERE
        (@NombreFilter IS NULL OR Nombre LIKE '%' + @NombreFilter + '%')
    ORDER BY IdPuestoEmpleado
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM PuestoEmpleado
    WHERE
        (@NombreFilter IS NULL OR Nombre LIKE '%' + @NombreFilter + '%');
END;
GO
