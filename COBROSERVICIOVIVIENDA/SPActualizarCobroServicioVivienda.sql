--actualiza  cobro servicio vivienda 
CREATE OR ALTER PROCEDURE ActualizarCobroServicioVivienda
@idCobroServicio INT,
@FechaCobro Date,
@Monto DECIMAL,
@MontoAplicado DECIMAL,
@EstadoPago VARCHAR(10),
@IdServicio      int,
@NumeroVivienda  INT,
@IdCluster       INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM CobroServicioVivienda WHERE idCobroServicio = @idCobroServicio
    )
    BEGIN
        UPDATE CobroServicioVivienda
        SET FechaCobro = @FechaCobro,
            Monto = @Monto,
            MontoAplicado = @MontoAplicado,
			EstadoPago = @EstadoPago,
			IdServicio = @IdServicio,
			NumeroVivienda = @NumeroVivienda,
			IdCluster = @IdCluster
        WHERE idCobroServicio = @idCobroServicio;
        PRINT 'El cobro servicio ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El cobro servicio especificado no existe.', 16, 1);
    END
END;
GO
EXEC ActualizarCobroServicioVivienda
@idCobroServicio= 15, 
@FechaCobro = '2024-09-01',
@Monto= 115,
@MontoAplicado= 115,
@EstadoPago= 'PENDIENTE',
@IdServicio = 3,
@NumeroVivienda = 405,
@IdCluster = 4; 

select* from CobroServicioVivienda
select * from Servicio