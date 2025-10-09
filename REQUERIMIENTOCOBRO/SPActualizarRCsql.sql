--actualiza dRequerimiento de cobro
CREATE OR ALTER PROCEDURE ActualizarRC
    @IdRequerimientoC INT,
    @Fecha Date,
    @NumeroVivienda INT,
    @IdCluster INT,
	@IdServicio INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM RequerimientoCobro WHERE IdRequerimientoC = @IdRequerimientoC
    )
    BEGIN
        UPDATE RequerimientoCobro
        SET Fecha = @Fecha,
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster,
			IdServicio = @IdServicio
        WHERE IdRequerimientoC = @IdRequerimientoC;
        PRINT 'Requeimiento de cobro ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El requerimiento de cobro especificado no existe.', 16, 1);
    END
END;
GO
EXEC ActualizarRC
@IdRequerimientoC = 9,
@Fecha = '2025-10-07',
@NumeroVivienda = 26,
@IdCluster = 2,
@IdServicio = 4; 

select* from RequerimientoCobro