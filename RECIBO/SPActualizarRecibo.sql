
-- actualizar recibo
CREATE OR ALTER PROCEDURE ActualizarRecibo
    @IdRecibo INT,
    @FechaEmision DATE,
	@Idpago int 
AS
BEGIN
    UPDATE Recibo
    SET FechaEmision = @FechaEmision,
		Idpago = @IdPago
    WHERE IdRecibo = @IdRecibo;
END

EXEC ActualizarRecibo
@IdRecibo = 1,
@FechaEmision = '2025/10/06',
@Idpago = 1

select * from Recibo
select * from Pago