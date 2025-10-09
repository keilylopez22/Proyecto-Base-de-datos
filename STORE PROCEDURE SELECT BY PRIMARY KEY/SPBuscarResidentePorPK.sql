CREATE OR ALTER PROCEDURE SPBuscarResidente
@IdResidente INT
AS
BEGIN
	SELECT *
	FROM Residente
	WHERE IdResidente =@IdResidente
END;

EXEC SPBuscarResidente
@IdResidente = 1