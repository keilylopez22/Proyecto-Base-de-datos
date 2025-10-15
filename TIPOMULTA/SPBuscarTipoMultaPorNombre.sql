--buscar el tipo de multa por nombre 
CREATE OR ALTER PROCEDURE BuscarTipoMultaPorNombre
@Nombre VARCHAR (50)
AS
BEGIN 
	SELECT Nombre, Monto
	FROM TipoMulta
	WHERE Nombre LIKE '%' + @Nombre + '%';
END;
GO 
EXEC BuscarTipoMultaPorNombre
@Nombre= 'exceso'