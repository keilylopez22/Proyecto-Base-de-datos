Create or alter Procedure BuscarViviendaPorTipoVivienda
@IdTipoVivienda INT
As
Begin
	Select V.IdCluster, V.NumeroVivienda, TV.*
	From Vivienda As V
	Inner Join TipoVivienda As TV On V.IdTipoVivienda = tv.IdTipoVivienda
	Where TV.IdTipoVivienda = @IdTipoVivienda
End;

Exec BuscarViviendaPorTipoVivienda
@IdTipoVivienda = 1