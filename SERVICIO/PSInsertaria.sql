--inserta Servicio
Create  OR ALTER Procedure InsertarServicio
@Descripcion VARCHAR (100),
@Valor decimal (18,2)
As
Begin 
	Insert Into Servicio( Descripcion, Valor)
	Values (@Descripcion, @Valor);
	
End;
GO
Exec InsertarServicio
@Descripcion = 'Clabe ',
@Valor = 55
select * from Servicio