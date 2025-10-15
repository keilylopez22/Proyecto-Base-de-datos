CREATE OR ALTER PROCEDURE ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(20)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

EXEC ConsultarPorDocumentoVisitante @NumeroDocumento = '100459403124';