CREATE OR ALTER  PROCEDURE ActualizarTipoVivienda
@IdTipoVivienda INT,
@Descripcion VARCHAR(50),
@NumeroHabitaciones INT,
@SuperficieTotal DECIMAL,
@NumeroPisos INT,
@ServiciosIncluidos VARCHAR(200),
@Estacionamiento BIT,
@Precio DECIMAL
AS
BEGIN
	UPDATE TipoVivienda
	SET Descripcion = @Descripcion,
		NumeroHabitaciones = @NumeroHabitaciones,
		SuperficieTotal = @SuperficieTotal,
		NumeroPisos = @NumeroPisos,
		ServiciosIncluidos = @ServiciosIncluidos,
		Estacionamiento = @Estacionamiento,
		Precio = @Precio
	WHERE IdTipoVivienda = @IdTipoVivienda;
	Select @IdTipoVivienda

END;

EXEC ActualizarTipoVivienda
@IdTipoVivienda = 25,
@Descripcion ='Casa grande vintage moderna Minimalista',
@NumeroHabitaciones =8,
@SuperficieTotal =400.00,
@NumeroPisos =3,
@ServiciosIncluidos ='',
@Estacionamiento =2,
@Precio =20000

Select * from TipoVivienda


