--insertar cobro de serivicio por vivienda 
Create  OR ALTER Procedure InsertarCobroServicioVivienda
@FechaCobro Date,
@Monto DECIMAL,
@MontoAplicado DECIMAL,
@EstadoPago VARCHAR(10),
@IdServicio      int,
@NumeroVivienda  INT,
@IdCluster       INT
As
 IF DAY(@FechaCobro) NOT BETWEEN 1 AND 10
    BEGIN
        RAISERROR('La fecha de cobro debe estar dentro de los primeros 10 días del mes.', 16, 1);
        RETURN;
    END
Begin 
	Insert Into CobroServicioVivienda(FechaCobro,Monto,MontoAplicado,EstadoPago ,IdServicio,NumeroVivienda, IdCluster)
	Values (@FechaCobro, @Monto, @MontoAplicado,@EstadoPago,@IdServicio, @NumeroVivienda, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdCobroServicio
End;
GO
Exec InsertarCobroServicioVivienda
@FechaCobro = '2025-10-15',
@Monto= 75,
@MontoAplicado= 75,
@EstadoPago= 'Cancelado',
@IdServicio = 1,
@NumeroVivienda = 404,
@IdCluster = 4; 

select* from CobroServicioVivienda
select* from Vivienda
select* from Servicio


