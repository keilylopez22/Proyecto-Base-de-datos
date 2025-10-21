CREATE OR ALTER PROCEDURE SP_EliminarDocumentoPersona
@IdTipoDocumento INT,
@IdPersona INT
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS (SELECT 1 FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
BEGIN
RAISERROR('El documento no existe o ya fue eliminado.', 16, 1)
RETURN
END

DELETE FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona
END
