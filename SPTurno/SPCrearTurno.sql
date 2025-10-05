CREATE OR ALTER PROCEDURE SPCrearTurno
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME,
@IdPuestoTrabajo INT
AS
BEGIN
INSERT INTO Turno (Descripcion, HoraInicio, HoraFin, IdPuestoTrabajo)
VALUES (@Descripcion, @HoraInicio, @HoraFin, @IdPuestoTrabajo);
END;

EXEC SPCrearTurno
@Descripcion = 'Turno Madrugada',
@HoraInicio ='07:00',
@HoraFin ='13:00',
@IdPuestoTrabajo = 2

