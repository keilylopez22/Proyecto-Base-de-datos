CREATE OR ALTER PROCEDURE SPBuscarResidencialPK
@IdResidencial INT
AS
BEGIN
    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        IdResidencial = @IdResidencial;
END;



EXEC SPBuscarResidencialPK
@IdResidencial = 1;

