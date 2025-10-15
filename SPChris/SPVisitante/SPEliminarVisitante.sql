CREATE OR ALTER PROCEDURE EliminarVisitante
    @IdVisitante INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'Error: No se puede eliminar el visitante ID ' + CAST(@IdVisitante AS VARCHAR) + ' - existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Visitante WHERE IdVisitante = @IdVisitante

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró el visitante con ID ' + CAST(@IdVisitante AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Visitante eliminado correctamente. ID: ' + CAST(@IdVisitante AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar visitante: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from Visitante;

EXEC EliminarVisitante @IdVisitante = 1;
--El visitante se podra eliminar si el IDVisitante no esta en RegistroAcceso