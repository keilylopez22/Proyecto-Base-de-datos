--Consulta por llave primaria
CREATE OR ALTER PROCEDURE ConsultarPorIdVisitante
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdVisitante = @IdVisitante
END;

EXEC ConsultarPorIdVisitante @IdVisitante = 1;