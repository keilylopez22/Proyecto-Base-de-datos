--Consulta por visitante
CREATE PROCEDURE ConsultarPorVisitanteListaNegra
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM ListaNegra WHERE IdVisitante = @IdVisitante
END;

EXEC ConsultarPorVisitanteListaNegra @IdVisitante = 8