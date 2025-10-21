CREATE OR ALTER PROCEDURE SP_InsertarDocumentoPersona
    @NumeroDocumento INT,
    @IdTipoDocumento INT,
    @IdPersona INT,
    @Observaciones VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
    BEGIN
        RAISERROR('La persona no existe en la tabla Persona.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento)
    BEGIN
        RAISERROR('Este tipo de documento no existe.', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM DocumentoPersona 
               WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
    BEGIN
        RAISERROR('Ya existe un documento para esta persona y tipo.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM DocumentoPersona
               WHERE NumeroDocumento = @NumeroDocumento AND IdTipoDocumento = @IdTipoDocumento)
    BEGIN
        RAISERROR('Ya existe un documento con ese número para este tipo.', 16, 1);
        RETURN;
    END

    INSERT INTO DocumentoPersona (NumeroDocumento, IdTipoDocumento, IdPersona, Observaciones)
    VALUES (@NumeroDocumento, @IdTipoDocumento, @IdPersona, @Observaciones);
END
