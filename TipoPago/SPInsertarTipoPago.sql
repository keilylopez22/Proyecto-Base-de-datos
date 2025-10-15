--inserta un tipo de pago 
Create  OR ALTER Procedure InsertarTipoPago 
@Nombre VARCHAR (50),
@Descripcion VARCHAR (100)
As
Begin 
	Insert Into TipoPago(Nombre,Descripcion)
	Values (@Nombre, @Descripcion );
	SELECT SCOPE_IDENTITY() AS idTipoPago;
End;
GO
Exec InsertarTipoPago
@Nombre = 'Tarjeta Debito',
@Descripcion = 'pago mediante '; 

Select * FROM  TipoPago
