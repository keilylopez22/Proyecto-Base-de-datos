--buscar  cobro por servicio y numero de vivienda
CREATE OR ALTER PROCEDURE BuscarCSVPorServicioVivienda 
@NumeroVivienda INT,
@IdCluster INT
AS
BEGIN
    SELECT csv.idCobroServicio, csv.FechaCobro,csv.Monto, csv.MontoAplicado,csv.EstadoPago,csv.IdServicio,csv.NumeroVivienda, csv.IdCluster,s.IdServicio, s.Nombre
    FROM CobroServicioVivienda csv
	INNER JOIN Servicio as s 
	on csv.IdServicio= s.IdServicio
    WHERE NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster
END;
GO
Exec BuscarCSVPorServicioVivienda
@NumeroVivienda = 101,
@IdCluster = 1

select * from  CobroServicioVivienda 