CREATE OR ALTER PROCEDURE SP_ActualizarTurno
@IdTurno INT,
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME
AS
BEGIN
UPDATE Turno
SET Descripcion = @Descripcion,
HoraInicio = @HoraInicio,
HoraFin = @HoraFin
WHERE IdTurno = @IdTurno
END

EXEC SP_ActualizarTurno
@IdTurno = 3,
@Descripcion = 'Turno Vespertino',
@HoraInicio = '14:00',
@HoraFin = '17:00'