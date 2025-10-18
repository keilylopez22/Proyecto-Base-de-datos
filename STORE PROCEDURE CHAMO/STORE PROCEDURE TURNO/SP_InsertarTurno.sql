CREATE OR ALTER PROCEDURE SP_CrearTurno
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME
AS
BEGIN

SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM Turno WHERE Descripcion = @Descripcion)
BEGIN
RAISERROR('Ya hay un turno con estre nombre',16,1)
RETURN
END

INSERT INTO Turno (Descripcion, HoraInicio, HoraFin)
VALUES (@Descripcion, @HoraInicio, @HoraFin)
END

EXEC SP_CrearTurno
@Descripcion = 'Matutino',
@HoraInicio ='07:00',
@HoraFin ='13:00'


