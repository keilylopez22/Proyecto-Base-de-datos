CREATE OR ALTER PROCEDURE SPBuscarTurnoPorHoraInicioYHoraFin
@HoraInicio TIME,
@HoraFin TIME
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.HoraInicio = @HoraInicio AND t.HoraFin = @HoraFin
END;

EXEC SPBuscarTurnoPorHoraInicioYHoraFin
@HoraInicio = '13:00',
@HoraFin = '22:00'