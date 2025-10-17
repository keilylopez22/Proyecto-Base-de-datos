--Construya una consulta que muestre cuántos vehículos posee cada vivienda. El procedimiento
--almacenado debe recibir como parámetro la residencia que se desea consultar (la residencia está
--formada por clúster y residencia)
CREATE OR ALTER PROCEDURE VehiculosPorVivienda
@IdCluster INT,
@NumeroVivienda INT 
AS
BEGIN
	SELECT COUNT(*) AS CantidadVehiculo, v.IdCluster, v.NumeroVivienda 
	FROM Vehiculo AS v
	WHERE v.IdCluster = @IdCluster AND v.NumeroVivienda = @NumeroVivienda
	GROUP BY v.NumeroVivienda, v.IdCluster
END;
EXEC VehiculosPorVivienda
@IdCluster = 2, 
@NumeroVivienda= 202