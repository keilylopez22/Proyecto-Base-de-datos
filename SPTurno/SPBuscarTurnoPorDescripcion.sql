CREATE OR ALTER PROCEDURE SPBuscarTurnoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.Descripcion = @Descripcion;
END;

EXEC SPBuscarTurnoPorDescripcion
@Descripcion = 'Turno Vespertino'

