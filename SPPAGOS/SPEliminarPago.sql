--elimina el pago
CREATE OR ALTER PROCEDURE EliminarPago
    @IdPago INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Pago WHERE IdPago = @IdPago)
	BEGIN 
		RAISERROR ('El numero de pago no existe', 16,1);
		RETURN; 
	END
		IF EXISTS (SELECT 1 FROM Recibo WHERE IdPago = @IdPago)
	BEGIN 
		RAISERROR ('El pago esta asociado con recibo',16,1);
		RETURN ;
	END 
    BEGIN

        DELETE FROM Pago
        WHERE IdPago = @IdPago;

        PRINT 'El pago se ha eliminado correctamente.';
	END
    
END;
GO
EXEC EliminarPago
@IdPago = 10
select* from Pago