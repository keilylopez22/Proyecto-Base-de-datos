CREATE OR ALTER PROCEDURE SPEliminarMarca
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Linea WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'Error: No se puede eliminar la marca ID ' + CAST(@IdMarca AS VARCHAR) + ' - existen líneas asociadas'
            RETURN -1
        END

        DELETE FROM Marca WHERE IdMarca = @IdMarca

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontró la marca con ID ' + CAST(@IdMarca AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar marca: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

select * from Marca;

-- La marca se podra eliminar si no tiene lineas asociadas
EXEC SPEliminarMarca @IdMarca = 5;
