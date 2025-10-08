CREATE OR ALTER PROCEDURE SPINSERTARRESIDENTE
@IdPersona INT,
@NumeroVivienda INT,
@Estado VARCHAR(10),
@IdCluster INT
AS
BEGIN
	INSERT INTO Residente(IdPersona, NumeroVivienda, Estado, IdCluster)
	VALUES(@IdPersona, @NumeroVivienda, @Estado, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdResidente
END;

EXEC SPINSERTARRESIDENTE
@IdPersona =30,
@NumeroVivienda =525,
@Estado = ACTIVO,
@IdCluster = 5

