CREATE OR ALTER PROCEDURE SP_InsertarPersonNoGrata
@FechaInicio DATE,
@FechFin DATE,
@Motivo VARCHAR(50),
@IdPersona INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
BEGIN 
RAISERROR('La persona igresada no existe',16,1)
RETURN
END

IF EXISTS(SELECT 1 FROM PersonaNoGrata WHERE IdPersona = @IdPersona)
BEGIN 
RAISERROR('La perosna que intentas ingresar ya existe en esta lista',16,1)
RETURN
END

INSERT INTO PersonaNoGrata(FechaInicio,FechaFin, Motivo, IdPersona)
VALUES(@FechaInicio, @FechFin, @Motivo, @IdPersona)
PRINT 'Persona ingresada correctamente a la lista de no gratos'
END

EXEC SP_InsertarPersonNoGrata
@FechaInicio = '2025-10-12',
@FechFin = '',
@Motivo = 'Robo a casas',
@IdPersona = 4

