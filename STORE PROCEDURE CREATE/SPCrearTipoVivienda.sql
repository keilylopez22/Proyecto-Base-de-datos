Create Or Alter Procedure InsertarTipoVivienda
@Descripcion VARCHAR(100),
@NumeroHabitaciones INT,
@SuperficieTotal Decimal,
@NumeroPisos INT,
@ServiciosIncluidos Varchar,
@Estacionamiento Bit,
@Precio Decimal
As

Begin 
	Insert into TipoVivienda(Descripcion ,NumeroHabitaciones,SuperficieTotal ,NumeroPisos ,ServiciosIncluidos ,Estacionamiento ,Precio )
	Values (@Descripcion ,@NumeroHabitaciones,@SuperficieTotal ,@NumeroPisos ,@ServiciosIncluidos ,@Estacionamiento ,@Precio);
	
End;

Exec InsertarTipoVivienda
@Descripcion = 'Casa Grande Moderna Con Tecnologia incluida',
@NumeroHabitaciones = 10,
@SuperficieTotal = 500.00,
@NumeroPisos = 3,
@ServiciosIncluidos = '' ,
@Estacionamiento = 1,
@Precio = 20000

select * from TipoVivienda


