--actualizar pagos  
CREATE OR ALTER PROCEDURE ActualizarPagos
    @IdPago INT,
    @FechaPago DATE ,
	@MontoTotal int,
    @idTipoPago int,
	@Referencia varchar(20)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM Pago WHERE IdPago = @IdPago
    )
    BEGIN
        UPDATE Pago
        SET FechaPago = @FechaPago,
            MontoTotal = @MontoTotal,
            idTipoPago = @idTipoPago,
			Referencia = @Referencia
        WHERE IdPago = @IdPago;
        PRINT 'el pago ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El pago solicitado no existe.', 16, 1);
    END
END;
GO
EXEC ActualizarPagos
@IdPago = 9,
@FechaPago = '2025-10-08',
@MontoTotal= 115,
@idTipoPago=4,
@Referencia= 'DEBITO-402-09';

select* from Pago