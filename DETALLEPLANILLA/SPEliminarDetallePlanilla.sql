-- elimina detalles de planillas
CREATE OR ALTER PROCEDURE EliminarDetallePlanilla
    @IdDetallePlanilla INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1 FROM DetallePlanilla WHERE IdDetallePlanilla = @IdDetallePlanilla
    )
    BEGIN
        RAISERROR('El detalle de la planilla no existe.', 16, 1);
        RETURN;
    END
    DELETE FROM DetallePlanilla
    WHERE IdDetallePlanilla = @IdDetallePlanilla;

    PRINT 'El detalle de la planilla se ha eliminado.';
END;
GO
EXEC EliminarDetallePlanilla
@IdDetallePlanilla = 3

select * from DetallePlanilla