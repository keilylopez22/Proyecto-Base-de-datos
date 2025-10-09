--actualiza detalle de una planilla en especifico
CREATE OR ALTER PROCEDURE ActualizarDetallePlanilla
    @IdDetallePlanilla INT,
    @IdPlanilla INT,
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM DetallePlanilla WHERE IdDetallePlanilla = @IdDetallePlanilla
    )
    BEGIN
        UPDATE DetallePlanilla
        SET IdPlanilla = @IdPlanilla,
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster
        WHERE IdDetallePlanilla = @IdDetallePlanilla;
        PRINT 'Detalle actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El IdDetallePlanilla especificado no existe.', 16, 1);
    END
END;
GO
EXEC ActualizarDetallePlanilla
@IdDetallePlanilla = 9,
@IdPlanilla = 8,
@NumeroVivienda = 311,
@IdCluster = 3;

select* from DetallePlanilla
select* from Vivienda
select* from Planilla