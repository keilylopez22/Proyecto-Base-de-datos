CREATE OR ALTER PROCEDURE SPEliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
			 PRINT 'Error: No se puede eliminar la línea ID ' + CAST(@IdLinea AS VARCHAR) + ' existen vehículos asociados'
            RETURN -1
        END

        DELETE FROM Linea WHERE IdLinea = @IdLinea

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró la línea con ID ' + CAST(@IdLinea AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Línea eliminada correctamente. ID: ' + CAST(@IdLinea AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar línea: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from Linea

EXEC SPEliminarLinea @IdLinea = 1
-- Si la linea esta asociada a algún vehiculo no se podrá eliminar