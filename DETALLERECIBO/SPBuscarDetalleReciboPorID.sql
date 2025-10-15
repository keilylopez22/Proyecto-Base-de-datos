--busca detalle recibo por el id 
CREATE OR ALTER PROCEDURE BuscarDetalleReciboPorID
@IdDetalleRecibo INT 
AS
BEGIN
	SELECT dr.IdRecibo,csv.MontoAplicado,v.NumeroVivienda,v.IdCluster, per.PrimerNombre, per.SegundoNombre, per.PrimerApellido, per.SegundoApellido
	From DetalleRecibo AS dr
	INNER JOIN CobroServicioVivienda AS csv ON dr.idCobroServicio = csv.idCobroServicio
	INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda 
	INNER JOIN Residente AS r ON  v.NumeroVivienda = r.NumeroVivienda
	INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
	WHERE IdDetalleRecibo = @IdDetalleRecibo
END;
GO
EXEC BuscarDetalleReciboPorID
@IdDetalleRecibo = 3
