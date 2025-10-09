--elimina recibos
Create OR Alter Procedure EliminarRecibo
@IdRecibo INT
AS
Begin
	IF EXISTS (SELECT 1 FROM Planilla WHERE IdRecibo = @IdRecibo)
	BEGIN
        RAISERROR('No se puede eliminar el recibo ya que está asociado a una planilla.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM DetalleServicio WHERE IdRecibo = @IdRecibo)
    BEGIN
        RAISERROR('No se puede eliminar el recibo ya que está asociado a un detalle de servicio.', 16, 1);
        RETURN;
    END

	BEGIN
		Delete FROM Recibo
		Where IdRecibo = @IdRecibo;
		PRINT 'El recibo se ha eliminado correctamente'
	END
End;
GO
select * from Recibo
Exec EliminarRecibo
@IdRecibo = 5