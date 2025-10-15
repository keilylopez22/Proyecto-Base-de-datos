CREATE PROCEDURE SPBuscarResidencialPorNombre
@Nombre VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre = @Nombre;
END;


EXEC SPBuscarResidencialPorNombre
@Nombre = 'Residenciales San Francisco';

