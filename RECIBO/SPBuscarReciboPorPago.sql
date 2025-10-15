
-- buscar recibos por numero de pago 
CREATE OR ALTER PROCEDURE BuscarReciboPorPago
    @IdPago INT
AS
BEGIN
    SELECT 
        IdRecibo,
        FechaEmision,
		IdPago
    FROM Recibo
    WHERE IdPago = @IdPago
END;
GO
Exec BuscarReciboPorPago
@IdPago = 2
select * from  Recibo