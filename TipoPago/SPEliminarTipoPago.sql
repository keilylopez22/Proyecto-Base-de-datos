--elimina un tipo de pago
CREATE OR ALTER PROCEDURE EliminarTipoPago
    @idTipoPago INT
AS
BEGIN
 IF NOT EXISTS (SELECT 1 FROM TipoPago WHERE idTipoPago = @idTipoPago)
    BEGIN
        RAISERROR('El tipo pago solicitado no existe.', 16,1, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM Pago WHERE idTipoPago = @idTipoPago)
    BEGIN
        RAISERROR('No se puede eliminar este tipo de pago, debido a que esta asociado a otra tabla.', 16, 1);
        RETURN;
    END

    DELETE FROM TipoPago
    WHERE idTipoPago = @idTipoPago;

    PRINT 'El tipo de pago se ha eliminado correctamente.';
END;
GO
Exec EliminarTipoPago
@idTipoPago = 2
select * from TipoPago
