CREATE PROCEDURE SPResidencial
AS
BEGIN

    SELECT *
    FROM
        Residencial
    ORDER BY
        Nombre;
END;

EXEC SPResidencial;