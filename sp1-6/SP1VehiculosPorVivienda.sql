--Construya una consulta que muestre cu�ntos veh�culos posee cada vivienda. El procedimiento
--almacenado debe recibir como par�metro la residencia que se desea consultar (la residencia est�
--formada por cl�ster y residencia)
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