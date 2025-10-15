CREATE OR ALTER PROCEDURE SPEliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
			 PRINT 'Error: No se puede eliminar la l�nea ID ' + CAST(@IdLinea AS VARCHAR) + ' existen veh�culos asociados'
            RETURN -1
        END

        DELETE FROM Linea WHERE IdLinea = @IdLinea

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontr� la l�nea con ID ' + CAST(@IdLinea AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'L�nea eliminada correctamente. ID: ' + CAST(@IdLinea AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar l�nea: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from Linea

EXEC SPEliminarLinea @IdLinea = 1
-- Si la linea esta asociada a alg�n vehiculo no se podr� eliminar