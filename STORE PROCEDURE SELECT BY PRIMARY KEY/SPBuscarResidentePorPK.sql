CREATE OR ALTER PROCEDURE SPBuscarResidentePK
@IdResidente INT
AS
BEGIN
	SELECT *
	FROM Residente
	WHERE IdResidente =@IdResidente
END;

EXEC SPBuscarResidentePK
@IdResidente = 1