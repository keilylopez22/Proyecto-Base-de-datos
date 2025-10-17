Create Or Alter Procedure InsertarTipoVivienda
@Descripcion VARCHAR(100),
@NumeroHabitaciones INT,
@SuperficieTotal Decimal,
@NumeroPisos INT,
@Estacionamiento Bit,

As

Begin 
	Insert into TipoVivienda(Descripcion ,NumeroHabitaciones,SuperficieTotal ,NumeroPisos ,Estacionamiento  )
	Values (@Descripcion ,@NumeroHabitaciones,@SuperficieTotal ,@NumeroPisos ,@Estacionamiento );
	
End;

Exec InsertarTipoVivienda
@Descripcion = 'Casa Grande Moderna Con Tecnologia incluida',
@NumeroHabitaciones = 10,
@SuperficieTotal = 500.00,
@NumeroPisos = 3,
@Estacionamiento = 1,


SELECT * FROM TipoVivienda


