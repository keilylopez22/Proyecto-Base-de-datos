--actualiza multa a viviendas 
CREATE OR ALTER PROCEDURE ActualizarMultaVivienda
@IdMultaVivienda INT,
@Monto DECIMAL,
@Observaciones VARCHAR (100),
@FechaInfraccion DATE,
@FechaRegistro DATE,
@EstadoPago VARCHAR (50),
@IdTipoMulta INT,
@NumeroVivienda INT,
@IdCluster INT
AS
BEGIN
	UPDATE MultaVivienda 
	SET Monto = @Monto,
		Observaciones = @Observaciones,
		FechaInfraccion = @FechaInfraccion,
		FechaRegistro = @FechaRegistro,
		EstadoPago = @EstadoPago,
		IdTipoMulta = @IdTipoMulta,
		NumeroVivienda = @NumeroVivienda,
		IdCluster = @IdCluster
	WHERE IdMultaVivienda = @IdMultaVivienda;
	
	IF @@ROWCOUNT > 0 
	BEGIN  
	PRINT 'La fila se actualizo correctamente'
	END
	ELSE 
	BEGIN
	PRINT 'la fila no se actualizo'
	END 

END;
GO 
EXEC ActualizarMultaVivienda
@IdMultaVivienda = 1,
@Monto = 250,
@Observaciones = 'Bolsa de basura fuera de contenedor',
@FechaInfraccion = '2024-09-05',
@FechaRegistro = '2025-10-12',
@EstadoPago = 'PAGADO',
@IdTipoMulta = 1,
@NumeroVivienda = 101 ,
@IdCluster =1

select * from MultaVivienda