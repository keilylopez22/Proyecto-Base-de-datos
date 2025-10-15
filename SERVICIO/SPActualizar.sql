
--actualiza Servicio 
CREATE OR ALTER PROCEDURE ActualizarServicio
    @IdServicio INT,
    @Nombre VARCHAR(50),
    @Tarifa DECIMAL
AS
BEGIN
    
    UPDATE Servicio
    SET Nombre = @Nombre,
        Tarifa = @Tarifa
    WHERE IdServicio = @IdServicio;
END;
GO
EXEC ActualizarServicio
    @IdServicio = 3,
    @Nombre = 'Servicio de seguridad',
	@Tarifa = 115
 
select * from Servicio