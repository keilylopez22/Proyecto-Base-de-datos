--busca el tipo de monto que sea igual o mayor al parametro de entrada 
CREATE OR ALTER PROCEDURE BuscarTipoMultaPorMonto
@Monto money 
AS
BEGIN
	SELECT Nombre, Monto
	FROM TipoMulta
	WHERE Monto >= @Monto
END;
GO
EXEC BuscarTipoMultaPorMonto
@Monto = 500