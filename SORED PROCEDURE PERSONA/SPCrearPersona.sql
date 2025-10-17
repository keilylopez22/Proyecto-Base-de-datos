CREATE OR ALTER PROCEDURE SPInsertarPersona
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30) ,
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(10) ,
@Telefono VARCHAR(30),
@Genero CHAR(1),
@FechaNacimiento DATE 

AS
BEGIN
	INSERT INTO Persona(Cui,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,Telefono,Genero,FechaNacimiento)
	VALUES(@Cui,@PrimerNombre,@SegundoNombre ,@PrimerApellido,@SegundoApellido ,@Telefono,@Genero,@FechaNacimiento )
	SELECT SCOPE_IDENTITY() AS IdPersona

END;

EXEC SPInsertarPersona
@Cui ='0907237845',
@PrimerNombre ='Floresita',
@SegundoNombre  = null,
@PrimerApellido ='Asturias',
@SegundoApellido = 'De Gomez',
@Telefono ='50408936',
@Genero = 'F',
@FechaNacimiento = '2000-04-19'



SELECT * FROM Persona