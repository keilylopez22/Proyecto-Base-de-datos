
--actualiza Servicio 
CREATE OR ALTER PROCEDURE ActualizarServicio
    @IdServicio INT,
    @Descripcion VARCHAR(100),
    @Valor DECIMAL (18,2)
AS
BEGIN
    
    UPDATE Servicio
    SET Descripcion = @Descripcion,
        Valor = @Valor
    WHERE IdServicio = @IdServicio;
END;
GO
EXEC ActualizarServicio
    @IdServicio = 4,
    @Descripcion = 'Administración',
	@Valor = 75
 
select * from Servicio