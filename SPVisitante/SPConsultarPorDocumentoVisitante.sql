--Consulta por número de documento
CREATE OR ALTER PROCEDURE ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(50)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

EXEC ConsultarPorDocumentoVisitante @NumeroDocumento = 'DPI-11112222333';