CREATE OR ALTER  PROCEDURE ActualizarTipoVivienda
@IdTipoVivienda INT,
@Descripcion VARCHAR(50),
@NumeroHabitaciones INT,
@SuperficieTotal DECIMAL,
@NumeroPisos INT,
@Estacionamiento BIT
AS
BEGIN
	UPDATE TipoVivienda
	SET Descripcion = @Descripcion,
		NumeroHabitaciones = @NumeroHabitaciones,
		SuperficieTotal = @SuperficieTotal,
		NumeroPisos = @NumeroPisos,
		Estacionamiento = @Estacionamiento
	WHERE IdTipoVivienda = @IdTipoVivienda;
	Select @IdTipoVivienda

END;

EXEC ActualizarTipoVivienda
@IdTipoVivienda = 4,
@Descripcion ='Casa grande vintage moderna Minimalista',
@NumeroHabitaciones =8,
@SuperficieTotal =400.00,
@NumeroPisos =3,
@Estacionamiento =2

SELECT * FROM TipoVivienda


