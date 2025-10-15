--elimina servicio
CREATE OR ALTER PROCEDURE EliminarServicio
    @IdServicio INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Servicio WHERE IdServicio = @IdServicio)
    BEGIN
        RAISERROR('Este servicio no existe', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM CobroServicioVivienda WHERE IdServicio = @IdServicio)
    BEGIN
        RAISERROR('Este servicio no se puede eliminar ya que esta asociado a otra entidad.', 16, 1);
        RETURN;
    END
    DELETE FROM Servicio
    WHERE IdServicio = @IdServicio;

END;
GO
exec EliminarServicio
@IdServicio = 4
select * from  Servicio