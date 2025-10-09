--elimina un tipo de pago
Create OR Alter Procedure EliminarTipoPago
@IdTipoPago INT
AS
Begin
	IF EXISTS (SELECT 1 FROM Recibo WHERE IdTipoPago = @IdTipoPago)
    BEGIN
        PRINT 'No se puede eliminar este tipo de pago ya que está en uso.';
    END
    ELSE
	BEGIN
		Delete TipoPago
		Where IdTipoPago = @IdTipoPago;
		PRINT 'El tipo de pago se ha eliminado correctamente'
	END
End;
GO
Exec EliminarTipoPago
@IdTipopago = 7
