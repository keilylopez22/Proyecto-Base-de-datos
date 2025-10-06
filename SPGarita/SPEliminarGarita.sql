-- 2. Eliminar de Garita
CREATE OR ALTER PROCEDURE EliminarGarita
    @IdGarita INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        IF EXISTS (SELECT 1 FROM Visitante WHERE IdGarita = @IdGarita)
        BEGIN
            PRINT 'No se puede eliminar: existen visitantes asociados a esta garita'
            RETURN -1
        END
        
        IF EXISTS (SELECT 1 FROM RegistroVehiculos WHERE IdGarita = @IdGarita)
        BEGIN
            PRINT 'No se puede eliminar: existen registros de vehículos asociados a esta garita'
            RETURN -1
        END
        
        DELETE FROM Garita WHERE IdGarita = @IdGarita
        PRINT 'Garita eliminada exitosamente'
        COMMIT TRANSACTION
        RETURN 1
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        PRINT 'Error al eliminar la garita'
        RETURN -1
    END CATCH
END;

EXEC EliminarGarita @IdGarita = 1; --No se podrá eliminar, ya que tiene un visitante asociado.