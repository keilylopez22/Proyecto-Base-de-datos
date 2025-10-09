--inserta un recibo
Create  OR ALTER Procedure InsertarRecibo
@Fecha Date,
@ValorTotal DECIMAL (18,2),
@IdTipoPago int ,
@NumeroVivienda int,
@IdCluster int
As
Begin 
	Insert Into Recibo(Fecha, ValorTotal, IdTipoPago, NumeroVivienda, IdCluster)
	Values (@Fecha, @ValorTotal,@IdTipoPago,  @NumeroVivienda, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdRecibo
End;

Exec InsertarRecibo
@Fecha = '2025-10-05',
@ValorTotal= 115,
@IdTipoPago = 1,
@NumeroVivienda = 311,
@IdCluster = 3

select * from Recibo
select * from Cluster
select * from Vivienda
select * from Servicio