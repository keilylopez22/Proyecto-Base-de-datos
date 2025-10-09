
--actualiza una planilla 
CREATE OR ALTER PROCEDURE ActualizarPlanilla
    @IdPlanilla INT,
    @Descripcion VARCHAR(100),
    @Fecha DATE,
    @IdRecibo INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Planilla WHERE IdPlanilla = @IdPlanilla)
    BEGIN
        RAISERROR('La planilla no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM Recibo WHERE IdRecibo = @IdRecibo)
    BEGIN
        RAISERROR('El recibo no existe.', 16, 1);
        RETURN;
    END
    UPDATE Planilla
    SET Descripcion = @Descripcion,
        Fecha = @Fecha,
        IdRecibo = @IdRecibo
    WHERE IdPlanilla = @IdPlanilla;
END;
GO
EXEC ActualizarPlanilla
    @IdPlanilla = 5,
    @Descripcion = 'Planilla actualizada octubre',
    @Fecha = '2025-10-07',
    @IdRecibo = 1;
select * from Planilla