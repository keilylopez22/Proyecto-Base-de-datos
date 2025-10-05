CREATE OR ALTER PROCEDURE ActualizarTurno
@IdTurno INT,
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME,
@IdPuestoTrabajo INT
AS
BEGIN
UPDATE Turno
SET Descripcion = @Descripcion,
HoraInicio = @HoraInicio,
HoraFin = @HoraFin,
IdPuestoTrabajo = @IdPuestoTrabajo
WHERE IdTurno = @IdTurno;
END;

EXEC ActualizarTurno
@IdTurno = 3,
@Descripcion = 'Turno Vespertino',
@HoraInicio = '14:00',
@HoraFin = '17:00',
@IdPuestoTrabajo = 2