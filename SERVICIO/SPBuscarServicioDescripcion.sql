-- Buscar servicio  por descripcion  
Create OR Alter Procedure BuscarServicioDescripcion 
@Descripcion Varchar(100)
AS
Begin 
	Select  @Descripcion as DescripcionServicio
	from Servicio
	Where  Descripcion = @Descripcion 

END;
GO
Exec BuscarServicioDescripcion
@Descripcion = 'Servicio de Seguridad'
select * from Servicio