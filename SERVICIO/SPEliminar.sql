--elimina servicio
CREATE OR ALTER PROCEDURE EliminarServicio
    @IdServicio INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM RequerimientoCobro WHERE IdServicio = @IdServicio)
    BEGIN
        RAISERROR('Este servicio no se puede eliminar ya que esta asociado a requerimientos de cobro.', 16, 1);
        RETURN;
    END
    DELETE FROM Servicio
    WHERE IdServicio = @IdServicio;

END;
GO
exec EliminarServicio
@IdServicio = 5
select * from  Servicio