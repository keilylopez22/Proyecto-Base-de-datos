CREATE OR ALTER PROCEDURE SPActualizarPersona
@IdPersona INT ,
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30),
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(30),
@Telefono VARCHAR(30) ,
@Genero CHAR(1) ,
@FechaNacimiento DATE ,

AS
BEGIN
	UPDATE Persona
	SET
	Cui = @Cui ,
	PrimerNombre = @PrimerNombre ,
	SegundoNombre = @SegundoNombre,
	PrimerApellido = @PrimerApellido ,
	SegundoApellido = @SegundoApellido ,
	Telefono  = @Telefono  ,
	Genero  = @Genero	,
	FechaNacimiento = @FechaNacimiento
	
	WHERE IdPersona =@IdPersona
	SELECT @IdPersona

END;

EXEC SPActualizarPersona
@Cui ='0907237845',
@IdPersona =21,
@PrimerNombre ='Floresita',
@SegundoNombre  = 'Elizabeth',
@PrimerApellido ='Asturias',
@SegundoApellido = 'De León',
@Telefono ='50408936',
@Genero = 'F',
@FechaNacimiento = '2000-04-19'


SELECT * FROM Persona 