CREATE OR ALTER PROCEDURE SPActualizarPersona
@IdPersona INT ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30),
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(30),
@FechaDeNacimiento DATE ,
@Cui VARCHAR(30) ,
@Telefono VARCHAR(30) ,
@Genero CHAR(1)
AS
BEGIN
	UPDATE Persona
	SET
	PrimerNombre = @PrimerNombre ,
	SegundoNombre = @SegundoNombre,
	PrimerApellido = @PrimerApellido ,
	SegundoApellido = @SegundoApellido ,
	FechaDeNacimiento = @FechaDeNacimiento,
	Cui = @Cui ,
	Telefono  = @Telefono  ,
	Genero  = @Genero	
	WHERE IdPersona =@IdPersona
	SELECT @IdPersona

END;

EXEC SPActualizarPersona
@IdPersona =38,
@PrimerNombre ='Floresita',
@SegundoNombre  = 'Elizabeth',
@PrimerApellido ='Asturias',
@SegundoApellido = 'De Gudiel',
@FechaDeNacimiento = '2000-04-19',
@Cui ='0907237845',
@Telefono ='50408936',
@Genero = 'F'

