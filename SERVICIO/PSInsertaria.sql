--inserta Servicio
Create  OR ALTER Procedure InsertarServicio
@Nombre  VARCHAR (50),
@Tarifa decimal 
As
Begin 
	Insert Into Servicio( Nombre, Tarifa)
	Values (@Nombre, @Tarifa);
	
End;
GO
Exec InsertarServicio
@Nombre = 'Administracion ',
@Tarifa = 75.00
select * from Servicio
