--insertar requerimiento de cobro 
Create  OR ALTER Procedure InsertarRC
@Fecha Date,
@IdServicio int,
@NumeroVivienda int,
@IdCluster int
As
Begin 
	Insert Into RequerimientoCobro(Fecha, IdServicio,NumeroVivienda, IdCluster)
	Values (@Fecha,@IdServicio, @NumeroVivienda, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdRequerimientoC
End;
GO
Exec InsertarRC
@Fecha = '2025-10-07',
@IdServicio = 3,
@NumeroVivienda = 314,
@IdCluster = 1; 

select* from RequerimientoCobro
