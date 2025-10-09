--elimina el detalle del servicio 
CREATE OR ALTER PROCEDURE EliminarDetalleServicio
    @IdDetalleServicio INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM DetalleServicio WHERE IdDetalleServicio = @IdDetalleServicio
    )
    BEGIN
        DELETE FROM DetalleServicio
        WHERE IdDetalleServicio = @IdDetalleServicio;

        PRINT 'Detalle eliminado correctamente.';
    END
    ELSE
    BEGIN
        PRINT 'El IdDetalleServicio no existe.';
    END
END;
GO
EXEC EliminarDetalleServicio
@IdDetalleServicio = 15
select* from DetalleServicio