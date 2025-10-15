--inserta multa a viviendas 
CREATE OR ALTER PROCEDURE InsertarMultaVivienda
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
	INSERT INTO MultaVivienda (Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago,IdTipoMulta, NumeroVivienda, IdCluster)
	VALUES 	(@Monto, @Observaciones, @FechaInfraccion, @FechaRegistro, @EstadoPago,@IdTipoMulta, @NumeroVivienda, @IdCluster)
	SELECT SCOPE_IDENTITY () AS IdMultaVivienda;

END;
GO 
EXEC InsertarMultaVivienda
@Monto = 1000,
@Observaciones = 'Daños en area comun',
@FechaInfraccion = '2025-10-10',
@FechaRegistro = '2025-10-12',
@EstadoPago = 'Pendiente',
@IdTipoMulta = 4,
@NumeroVivienda = 103 ,
@IdCluster =1

select * from Vivienda
select * from MultaVivienda