CREATE OR ALTER PROCEDURE SPInsertarPersona
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30) ,
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(30) ,
@FechaDeNacimiento DATE ,
@Cui VARCHAR(30) ,
@Telefono VARCHAR(30),
@Genero CHAR(1)
AS
BEGIN
	INSERT INTO Persona(PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,FechaDeNacimiento,Cui,Telefono,Genero)
	VALUES(@PrimerNombre,@SegundoNombre ,@PrimerApellido,@SegundoApellido ,@FechaDeNacimiento ,@Cui,@Telefono,@Genero)
	SELECT SCOPE_IDENTITY() AS IdPersona

END;

EXEC SPInsertarPersona
@PrimerNombre ='Floresita',
@SegundoNombre  = null,
@PrimerApellido ='Asturias',
@SegundoApellido = 'De Gudiel',
@FechaDeNacimiento = '2000-04-19',
@Cui ='0907237845',
@Telefono ='50408936',
@Genero = 'F'

select * from Persona