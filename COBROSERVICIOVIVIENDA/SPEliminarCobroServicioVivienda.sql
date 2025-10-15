--elimina el cobro del servicio por vivienda 
CREATE OR ALTER PROCEDURE EliminarCobroServicioVivienda
    @idCobroServicioVivienda INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1 FROM CobroServicioVivienda WHERE idCobroServicio = @idCobroServicioVivienda
    )
    BEGIN
        RAISERROR('El cobro del servicio de cobro no existe.', 16, 1);
        RETURN;
    END
    IF EXISTS (
        SELECT 1 FROM DetalleRecibo WHERE idCobroServicio = @idCobroServicioVivienda
    )
    BEGIN
        RAISERROR('No se puede eliminar el cobro del sevicio debido a que esta asocida a otra tabla.', 16, 1);
        RETURN;
    END
    DELETE FROM CobroServicioVivienda
    WHERE idCobroServicio = @idCobroServicioVivienda;

    PRINT 'El cobro del servicio se ha eliminado correctamente.';
END;
GO
EXEC EliminarCobroServicioVivienda
@idCobroServicioVivienda = 17

select* from CobroServicioVivienda
