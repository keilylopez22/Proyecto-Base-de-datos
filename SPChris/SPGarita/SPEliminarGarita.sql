CREATE OR ALTER PROCEDURE EliminarGarita
    @IdGarita INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdGarita = @IdGarita)
        BEGIN
           PRINT 'Error: No se puede eliminar la garita ID ' + CAST(@IdGarita AS VARCHAR) + ' existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Garita WHERE IdGarita = @IdGarita

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró la garita con ID ' + CAST(@IdGarita AS VARCHAR)
            RETURN 0
        END
        COMMIT TRANSACTION
		PRINT 'Garita eliminada correctamente. ID: ' + CAST(@IdGarita AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar garita: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from Garita;

--La garita se podrá eliminar si no tiene ningun registro acceso asociado
EXEC EliminarGarita @IdGarita = 1