 --inserta un recibo
Create  OR ALTER Procedure InsertarRecibo
@FechaEmision Date,
@Idpago int 
As
Begin 
	Insert Into Recibo(FechaEmision, IdPago)
	Values (@FechaEmision, @Idpago);
	SELECT SCOPE_IDENTITY() AS IdRecibo
End;
GO
Exec InsertarRecibo
@Fechaemision = '2025-10-05',
@IdPago = 7

select * from Recibo
select * from Pago 