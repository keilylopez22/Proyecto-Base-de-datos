CREATE PROCEDURE SPBuscarResidencialCoicidencianombre
    @NombreParcial VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre LIKE '%' + @NombreParcial + '%';
END;

EXEC SPBuscarResidencialCoicidencianombre
@NombreParcial = 'San';

