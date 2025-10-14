CREATE OR ALTER PROCEDURE SP_InsertarPersonNoGrata
@FechaInicio DATE,
@FechFin DATE = NULL,
@Motivo VARCHAR(50),
@IdPersona INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
BEGIN 
RAISERROR('La persona ingresada no existe',16,1)
RETURN
END

IF EXISTS(SELECT 1 FROM PersonaNoGrata WHERE IdPersona = @IdPersona AND (FechaFin IS NULL OR FechaFin >= CAST(GETDATE() AS DATE)))
BEGIN 
RAISERROR('La persona que intentas ingresar ya existe en esta lista y aun no puede ingresar de nuevo hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO PersonaNoGrata(FechaInicio,FechaFin, Motivo, IdPersona)
VALUES(@FechaInicio, @FechFin, @Motivo, @IdPersona)
PRINT 'Persona ingresada correctamente a la lista de no gratos'
END

EXEC SP_InsertarPersonNoGrata
@FechaInicio = '2025-10-12',
@FechFin = '2025-10-13',
@Motivo = 'Robo a casas',
@IdPersona = 4

