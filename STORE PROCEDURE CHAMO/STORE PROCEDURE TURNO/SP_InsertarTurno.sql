CREATE OR ALTER PROCEDURE SP_CrearTurno
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME
AS
BEGIN
INSERT INTO Turno (Descripcion, HoraInicio, HoraFin)
VALUES (@Descripcion, @HoraInicio, @HoraFin)
END

EXEC SP_CrearTurno
@Descripcion = 'Turno Madrugada',
@HoraInicio ='07:00',
@HoraFin ='13:00'


