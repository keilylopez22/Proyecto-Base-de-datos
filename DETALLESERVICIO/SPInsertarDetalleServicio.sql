--insertar detalle servicio
Create  OR ALTER Procedure InsertarDetalleServicio
@Valor decimal (18,2),
@IdRequerimientoC int,
@IdRecibo int
As
Begin 
	Insert Into DetalleServicio(Valor, IdRequerimientoC,IdRecibo)
	Values (@Valor,@IdRequerimientoC, @IdRecibo);
	SELECT SCOPE_IDENTITY() AS IdDetalleServicio
End;
GO
Exec InsertarDetalleServicio
@valor = 75,
@IdRequerimientoC = 9,
@IdRecibo = 4; 

select* from DetalleServicio