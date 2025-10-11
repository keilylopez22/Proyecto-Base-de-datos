CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.Descripcion = @Descripcion
END

EXEC SP_BuscarTurnoPorDescripcion
@Descripcion = 'Turno Vespertino'

