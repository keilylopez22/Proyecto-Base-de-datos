--inserta  pago 
Create  OR ALTER Procedure InsertarPago 
@FechaPago date,
@MontoTotal decimal,
@idTipoPago int, 
@Referencia VARCHAR (20)
As
Begin 
	Insert Into Pago (FechaPago , MontoTotal , idTipoPago, Referencia)
	Values (@FechaPago, @MontoTotal, @idTipoPago, @Referencia )
	SELECT SCOPE_IDENTITY() AS IdPago;
End;
GO
EXEC InsertarPago
@FechaPago='2025-10-12',
@MontoTotal= 115.00,
@idTipoPago = 1,
@Referencia = 'EFECTIVO-304-09'
Select * from pago
Select * from TipoPago
