-- Buscar servicio  por descripcion  
Create OR Alter Procedure BuscarServicioDescripcion 
@Nombre Varchar(50)
AS
Begin 
	Select  Nombre, Tarifa 
	from Servicio
	Where  Nombre = @Nombre 

END;
GO
Exec BuscarServicioDescripcion
@Nombre = 'Servicio de Seguridad'
select * from Servicio
