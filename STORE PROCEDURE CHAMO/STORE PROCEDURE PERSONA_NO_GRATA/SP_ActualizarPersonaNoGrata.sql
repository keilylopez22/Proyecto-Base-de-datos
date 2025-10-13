CREATE OR ALTER PROCEDURE SP_ActualizarPersonaNoGrata
@IdPeronaNoGrata INT,
@FechaInicio DATE = NULL,
@FechaFin DATE = NULL,
@Motivo VARCHAR(50) = NULL
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPeronaNoGrata)
BEGIN
RAISERROR('Esta persona no existe en la lista de no gratos',16,1)
RETURN
END

UPDATE PersonaNoGrata
SET FechaInicio = @FechaInicio,
FechaFin = @FechaFin,
Motivo = @Motivo
WHERE idPersonaNoGrata = @IdPeronaNoGrata
PRINT 'Se actulizo a la persona no grata'
END

EXEC SP_ActualizarPersonaNoGrata
@IdPeronaNoGrata = 4,
@FechaInicio = '',
@FechaFin = '2027-10-12',
@Motivo = ''

