--actualiza Detalle de servicio  
CREATE OR ALTER PROCEDURE ActualizarDS
    @IdDetalleServicio INT,
    @Valor decimal (18,2),
	@IdRequerimientoC int,
    @IdRecibo int 
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM DetalleServicio WHERE IdDetalleServicio = @IdDetalleServicio
    )
    BEGIN
        UPDATE DetalleServicio
        SET Valor = @Valor,
            IdRequerimientoC = @IdRequerimientoC,
            IdRecibo = @IdRecibo
        WHERE IdDetalleServicio = @IdDetalleServicio;
        PRINT 'el detalle del servicio ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El detalle del servicio especificado no existe.', 16, 1);
    END
END;
GO
EXEC ActualizarDS
@IdDetalleServicio = 16,
@Valor= 210,
@IdRequerimientoC=12,
@IdRecibo= 5;

select* from DetalleServicio

