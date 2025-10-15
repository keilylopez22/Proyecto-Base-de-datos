CREATE OR ALTER PROCEDURE EliminarTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento)
        BEGIN
             PRINT 'Error: No se puede eliminar el tipo de documento ID ' + CAST(@IdTipoDocumento AS VARCHAR) + ' existen visitantes asociados'
            RETURN -1
        END

        DELETE FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró el tipo de documento con ID ' + CAST(@IdTipoDocumento AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Tipo de documento eliminado correctamente. ID: ' + CAST(@IdTipoDocumento AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar tipo de documento: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from TipoDocumento

-- el tipo documento se podrá eliminar si no tiene ningún visitante asociado
EXEC EliminarTipoDoc @IdTipoDocumento = 1