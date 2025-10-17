Create Or Alter  Procedure buscarViviendaPorPropietario
@IdPropietario Int
As
Begin
	SELECT V.NumeroVivienda, V.IdCluster, CONCAT(P.PrimerNombre, P.PrimerApellido) As propietario, TV.Descripcion
	FROM Vivienda As V
	Inner join TipoVivienda As TV on v.IdTipoVivienda = TV.IdTipoVivienda
	Inner Join Propietario As PT on V.IdPropietario = PT.IdPropietario
	Inner Join Persona As P on PT.IdPersona = P.IdPersona
	Where PT.IdPropietario = @IdPropietario
End;

Exec buscarViviendaPorPropietario
@IdPropietario = 8

