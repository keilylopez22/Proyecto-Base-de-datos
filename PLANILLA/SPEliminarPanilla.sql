--elimina una planilla
CREATE OR ALTER PROCEDURE EliminarPlanilla
    @IdPlanilla INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM DetallePlanilla WHERE IdPlanilla = @IdPlanilla)
    BEGIN
        RAISERROR('No se puede eliminar la planilla ya que tiene detalles asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM Planilla
    WHERE IdPlanilla = @IdPlanilla;

    PRINT 'La planilla se ha eliminado correctamente';
END;
GO
EXEC EliminarPlanilla 
@IdPlanilla = 5;

SELECT * FROM Planilla;