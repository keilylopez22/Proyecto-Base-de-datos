--elimina requerimento de cobro 
CREATE OR ALTER PROCEDURE EliminarRequerimientoCobro
    @IdRequerimientoC INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1 FROM RequerimientoCobro WHERE IdRequerimientoC = @IdRequerimientoC
    )
    BEGIN
        RAISERROR('El requerimiento de cobro no existe.', 16, 1);
        RETURN;
    END
    IF EXISTS (
        SELECT 1 FROM DetalleServicio WHERE IdRequerimientoC = @IdRequerimientoC
    )
    BEGIN
        RAISERROR('No se puede eliminar el requerimiento de cobro porque esta asociado a un detalle de servicio.', 16, 1);
        RETURN;
    END
    DELETE FROM RequerimientoCobro
    WHERE IdRequerimientoC = @IdRequerimientoC;

    PRINT 'El requerimiento de cobro se ha eliminado correctamente.';
END;
GO
EXEC EliminarRequerimientoCobro
@IdRequerimientoC = 20

select* from RequerimientoCobro
select* from DetalleServicio