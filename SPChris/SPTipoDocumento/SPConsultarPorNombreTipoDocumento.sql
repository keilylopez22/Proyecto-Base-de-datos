CREATE PROCEDURE ConsultarPorNombreTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE Nombre = @Nombre
END;

EXEC ConsultarPorNombreTipoDoc @Nombre = 'DPI';