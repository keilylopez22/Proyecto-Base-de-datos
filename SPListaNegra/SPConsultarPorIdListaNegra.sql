--Consulta por llave primaria
CREATE PROCEDURE ConsultarPorIdListaNegra
    @IdListaNegra INT
AS
BEGIN
    SELECT * FROM ListaNegra WHERE IdListaNegra = @IdListaNegra
END;

EXEC ConsultarPorIdListaNegra @IdListaNegra = 1;