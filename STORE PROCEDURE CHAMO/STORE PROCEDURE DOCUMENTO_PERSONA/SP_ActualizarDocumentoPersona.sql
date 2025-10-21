CREATE OR ALTER PROCEDURE SP_ActualizarDocumentoPersona
@IdTipoDocumento INT,
@IdPersona INT,
@NumeroDocumento INT,
@Observaciones VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS (SELECT 1 FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
BEGIN
RAISERROR('No existe un documento con esos datos para actualizar.', 16, 1)
RETURN
END

UPDATE DocumentoPersona
SET NumeroDocumento = @NumeroDocumento,
Observaciones = @Observaciones
WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona
END
