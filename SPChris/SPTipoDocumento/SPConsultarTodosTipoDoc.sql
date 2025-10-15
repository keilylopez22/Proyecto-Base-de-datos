CREATE OR ALTER PROCEDURE ConsultarTodosTipoDoc
AS
BEGIN
    SELECT * FROM TipoDocumento
END;

EXEC ConsultarTodosTipoDoc