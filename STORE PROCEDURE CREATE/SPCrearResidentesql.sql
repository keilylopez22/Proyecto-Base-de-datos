CREATE OR ALTER PROCEDURE SPInsertarResidente
@IdPersona INT,
@NumeroVivienda INT,
@IdCluster INT,
@EsInquilino BIT,
@Estado VARCHAR(10)
AS
BEGIN
	INSERT INTO Residente(IdPersona, NumeroVivienda, Estado, IdCluster, EsInquilino)
	VALUES(@IdPersona, @NumeroVivienda, @IdCluster, @EsInquilino, @Estado);
	SELECT SCOPE_IDENTITY() AS IdResidente
END;

EXEC SPInsertarResidente
@IdPersona = 1,
@NumeroVivienda = 101,
@IdCluster = 1,
@EsInquilino = 0,
@Estado = 'ACTIVO';


SELECT * FROM Residente





