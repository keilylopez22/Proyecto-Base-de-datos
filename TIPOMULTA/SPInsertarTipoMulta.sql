--inserta un tipo de multa 
CREATE OR ALTER PROCEDURE InsertarTipoMulta
@Nombre VARCHAR (50),
@Monto money 
AS
BEGIN
	INSERT INTO TipoMulta (Nombre, Monto)
	VALUES(@Nombre, @Monto)
	SELECT SCOPE_IDENTITY () AS IdTipoMulta;
END;
GO
EXEC InsertarTipoMulta
@Nombre = 'Embriaguez excesiva ',
@Monto = '900.00'
select * from TipoMulta