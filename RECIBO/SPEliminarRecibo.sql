--elimina recibos
Create OR Alter Procedure EliminarRecibo
@IdRecibo INT
AS
Begin
	IF NOT EXISTS (SELECT 1 FROM Recibo WHERE IdRecibo = @IdRecibo)
	BEGIN
        RAISERROR('El recibo solicitado no existe.', 16, 1);
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdRecibo=@IdRecibo)
	BEGIN 
		RAISERROR('No se puede eliminar el recibo debido a que esta asociado a otra entidad', 16,1);
		return;
	END
	BEGIN
		Delete FROM Recibo
		Where IdRecibo = @IdRecibo;
		PRINT 'El recibo se ha eliminado correctamente'
	END
End;
GO
Exec EliminarRecibo
@IdRecibo = 5
select * from Recibo