--inserta una planilla
Create  OR ALTER Procedure InsertarPlanilla
@Descripcion VARCHAR (100),
@Fecha Date,
@IdRecibo int
As
Begin
	IF EXISTS (SELECT 1 FROM Recibo WHERE IdRecibo = @IdRecibo)
    BEGIN
        PRINT 'El Id no existe';
    END
Begin 
	Insert Into Planilla(Descripcion, Fecha, IdRecibo)
	Values (@Descripcion, @Fecha, @IdRecibo);
	
END
End;
GO
Exec InsertarPlanilla
@Descripcion = 'Planilla mensual de octubre',
@Fecha = '2025-10-05',
@IdRecibo = 1
select * from Planilla