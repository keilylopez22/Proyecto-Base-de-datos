--busca el tipo de multa por el id 
CREATE OR ALTER PROCEDURE BuscarTipoMultaPorID
@IdTipoMulta int
AS
BEGIN 
	SELECT IdTipoMulta, Nombre, Monto
	FROM TipoMulta
	WHERE IdTipoMulta = @IdTipoMulta
END;
GO
EXEC BuscarTipoMultaPorID
@IdTipoMulta = 2
select * from TipoMulta