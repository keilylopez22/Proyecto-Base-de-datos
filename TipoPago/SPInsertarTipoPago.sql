--inserta un tipo de pago 
Create  OR ALTER Procedure InsertarTipoPago 
@Descripcion VARCHAR (75)
As
Begin 
	Insert Into TipoPago(Descripcion)
	Values (@Descripcion );
	SELECT SCOPE_IDENTITY() AS IdTipoPago;
End;

Exec InsertarTipoPago
@Descripcion = 'Fichas'; 