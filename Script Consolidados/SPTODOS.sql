CREATE OR ALTER PROCEDURE SP_InsertarCluster
@Descripcion VARCHAR(30),
@IdResidencial INT
AS
BEGIN
    INSERT INTO Cluster(Descripcion, IdResidencial)
    VALUES(@Descripcion, @IdResidencial)
    SELECT SCOPE_IDENTITY() AS IdCluster
END;

GO
CREATE  OR ALTER PROCEDURE SP_InsertarMiembroJD
    @Estado VARCHAR(10),
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    INSERT INTO MiembroJuntaDirectiva (Estado,FechaInicio,FechaFin,IdJuntaDirectiva, IdPropietario, IdPuesto)
    VALUES (@Estado,@FechaInicio,@FechaFin, @IdJuntaDirectiva, @IdPropietario, @IdPuestoJuntaDirectiva)
    SELECT SCOPE_IDENTITY() AS 'IdMiembroJuntaDirectiva'
    
END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarPersona
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30) ,
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(10) ,
@Telefono VARCHAR(30),
@Genero CHAR(1),
@FechaNacimiento DATE ,
@EstadoCivil VARCHAR(15)

AS
BEGIN
    INSERT INTO Persona(Cui,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,Telefono,Genero,FechaNacimiento, EstadoCivil )
    VALUES(@Cui,@PrimerNombre,@SegundoNombre ,@PrimerApellido,@SegundoApellido ,@Telefono,@Genero,@FechaNacimiento,@EstadoCivil  )
    SELECT SCOPE_IDENTITY() AS IdPersona

END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarPropietario
@Estado VARCHAR(10) ,
@IdPersona INT
AS
BEGIN
    INSERT INTO Propietario(Estado,IdPersona)
    VALUES(@Estado, @IdPersona)
    SELECT SCOPE_IDENTITY() AS IdPropietario;
END; 

GO
CREATE OR ALTER PROCEDURE SP_InsertarPuestoJD
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);
    
    SELECT SCOPE_IDENTITY() AS IdPuesto;
END;

GO

CREATE  OR ALTER PROCEDURE SP_InsertarResidencial
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Residencial (Nombre)
    VALUES (@Nombre);

    
    SELECT SCOPE_IDENTITY() AS IdResidencial;
END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarResidente
@IdPersona INT,
@NumeroVivienda INT,
@IdCluster INT,
@EsInquilino BIT,
@Estado VARCHAR(10)
AS
BEGIN
    INSERT INTO Residente(IdPersona, NumeroVivienda, Estado, IdCluster, EsInquilino)
    VALUES(@IdPersona, @NumeroVivienda, @IdCluster, @EsInquilino, @Estado);
    SELECT SCOPE_IDENTITY() AS IdResidente
END;

GO
Create Or Alter Procedure SP_InsertarTipoVivienda
@Descripcion VARCHAR(100),
@NumeroHabitaciones INT,
@SuperficieTotal Decimal,
@NumeroPisos INT,
@Estacionamiento Bit

As

Begin 
    Insert into TipoVivienda(Descripcion ,NumeroHabitaciones,SuperficieTotal ,NumeroPisos ,Estacionamiento  )
    Values (@Descripcion ,@NumeroHabitaciones,@SuperficieTotal ,@NumeroPisos ,@Estacionamiento );
    
End;

GO
Create  OR ALTER Procedure SP_CrearVivienda
@NumeroVivienda INT, 
@IdCluster INT,  
@IdTipoVivienda INT,
@IdPropietario INT
As
Begin 
    Insert Into Vivienda(NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) 
    Values (@NumeroVivienda, @IdCluster,  @IdTipoVivienda, @IdPropietario);
    Select @NumeroVivienda ;
End;

GO
CREATE OR ALTER  PROCEDURE SP_InsertarJuntaDirectiva
@IdCluster INT
    
AS
BEGIN
    INSERT INTO JuntaDirectiva (IdCluster)
    VALUES (@IdCluster);
    
    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva;
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarCluster
@IdCluster INT
AS
BEGIN 
    DELETE Cluster 
    Where IdCluster = @IdCluster
    Select @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarJuntaDirectiva
    @IdJuntaDirectiva INT
AS
BEGIN
    IF EXISTS (SELECT *     FROM MiembroJuntaDirectiva 
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva)
    BEGIN
        
        RAISERROR('No se puede eliminar la Junta Directiva porque tiene miembros registrados. Debe eliminar primero los miembros.', 16, 1);
        RETURN 0;
    END;
    
    DELETE JuntaDirectiva
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva 
    
END;

GO
CREATE  OR ALTER PROCEDURE SP_EliminarMiembroJD
@IdMiembroJD INT
AS
BEGIN

    IF EXISTS (SELECT *         
	FROM MiembroJuntaDirectiva 
        WHERE IdMiembro = @IdMiembroJD And Estado = 'ACTIVO')
        BEGIN
        
            RAISERROR('No se puede eliminar el miembro porque aun esta activo.', 16, 1);
            RETURN 0;
        END
    DELETE FROM MiembroJuntaDirectiva
    WHERE
        IdMiembro =@IdMiembroJD 
        
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPersona
@IdPersona INT
AS
BEGIN
    DELETE Persona 
    WHERE IdPersona = @IdPersona
    SELECT @IdPersona 

END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPropietario
@IdPropietario INT
AS 
BEGIN
    DELETE Propietario
    WHERE IdPropietario = @IdPropietario
    SELECT @IdPropietario
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPuestoJD
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    IF EXISTS (SELECT *     FROM MiembroJuntaDirectiva 
    WHERE IdPuesto = @IdPuestoJuntaDirectiva)
    BEGIN
     
        RAISERROR('No se puede eliminar el Puesto porque esta siendo usado en MiembroJuntaDirectiva.',16,1);
        RETURN 0;
    END
    
    
    DELETE FROM PuestoJuntaDirectiva
    WHERE IdPuesto = @IdPuestoJuntaDirectiva;
       
END;

GO
CREATE  OR ALTER PROCEDURE SP_EliminarResidencial
    @IdResidencial INT
AS
BEGIN

    DELETE FROM Residencial
    WHERE IdResidencial = @IdResidencial;
    
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarResidente
@IdResidente INT
AS
BEGIN
    DELETE Residente
    WHERE IdResidente = @IdResidente
    SELECT @IdResidente
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN 
    DELETE TipoVivienda
    WHERE IdTipoVivienda = @IdTipoVivienda
    SELECT @IdTipoVivienda
END;

GO
Create Or Alter Procedure SP_EliminarVivienda
@NumeroVivienda INT, 
@IdCluster INT 

AS
Begin

    IF EXISTS(
    SELECT *
    FROM Residente
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
    ) 
    BEGIN
        RAISERROR('No se puede eliminar la vivienda porque hay residentes asociados',16,1)
        RETURN 0;
    END;
    
    Delete Vivienda
    Where NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster;
End;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarCluster
@IdCluster INT,
@Descripcion VARCHAR (30)
AS
BEGIN
    UPDATE Cluster
    SET Descripcion=@Descripcion 
    WHERE IdCluster=@IdCluster
    SELECT SCOPE_IDENTITY() AS IdCluster
    
END;

GO
CREATE OR ALTER  PROCEDURE SP_ActualizarJuntaDirectiva
@IdJuntaDirectiva INT,
@IdCluster INT
  
AS
BEGIN
    UPDATE JuntaDirectiva
    SET
        IdCluster = @IdCluster
        
    WHERE
        IdJuntaDirectiva = @IdJuntaDirectiva;

    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva
        
    
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPersona
@IdPersona INT ,
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30),
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(30),
@Telefono VARCHAR(30) ,
@Genero CHAR(1) ,
@FechaNacimiento DATE ,
@EstadoCivil VARCHAR(15)

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
    Genero  = @Genero   ,
    FechaNacimiento = @FechaNacimiento,
    EstadoCivil = @EstadoCivil
    
    WHERE IdPersona =@IdPersona
    SELECT @IdPersona

END;

GO
CREATE  OR ALTER PROCEDURE SP_ActualizarPropietario
    @IdPropietario INT,
    @Estado VARCHAR(20) ,
    @IdPersona INT
AS
BEGIN
        UPDATE Propietario
            SET IdPersona = @IdPersona, 
            Estado = @Estado
            WHERE IdPropietario = @IdPropietario;

        SELECT @IdPropietario 
   
END;

GO
CREATE  OR ALTER PROCEDURE SP_ActualizarPuestoJD
    @IdPuestoJuntaDirectiva INT,
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    
    UPDATE PuestoJuntaDirectiva
    SET
        Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE
        IdPuesto = @IdPuestoJuntaDirectiva;
    SELECT @IdPuestoJuntaDirectiva
           
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarResidencial
@IdResidencial INT,
@Nombre VARCHAR(50)
AS
BEGIN
    UPDATE Residencial
    SET
        Nombre = @Nombre
    WHERE
        IdResidencial = @IdResidencial;
   
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarResidente
    @IdResidente INT,
    @NumeroVivienda INT,
    @IdCluster INT,
    @EsInquilino BIT ,
    @Estado VARCHAR(10)
   
AS
BEGIN
    
        UPDATE Residente
        SET 
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster,
            EsInquilino = @EsInquilino,
            Estado = @Estado
            
        WHERE IdResidente = @IdResidente;
        SELECT @IdResidente
END;

GO
CREATE OR ALTER  PROCEDURE SP_ActualizarTipoVivienda
@IdTipoVivienda INT,
@Descripcion VARCHAR(50),
@NumeroHabitaciones INT,
@SuperficieTotal DECIMAL,
@NumeroPisos INT,
@Estacionamiento BIT
AS
BEGIN
    UPDATE TipoVivienda
    SET Descripcion = @Descripcion,
        NumeroHabitaciones = @NumeroHabitaciones,
        SuperficieTotal = @SuperficieTotal,
        NumeroPisos = @NumeroPisos,
        Estacionamiento = @Estacionamiento
    WHERE IdTipoVivienda = @IdTipoVivienda;
    Select @IdTipoVivienda

END;

GO
Create Or Alter Procedure SP_ActualizarVivivenda
@NumeroVivienda INT, 
@IdCluster INT, 
@IdPropietario INT, 
@IdTipoVivienda INT
AS

Begin
    Update  Vivienda 
    Set IdPropietario =@IdPropietario, 
        IdTipoVivienda =@IdTipoVivienda 
    Where NumeroVivienda = @NumeroVivienda and IdCluster= @IdCluster
End;

GO
CREATE OR ALTER PROCEDURE SP_BuscarCluster
@IdCluster INT
AS
BEGIN
    SELECT *
    FROM Cluster
    WHERE IdCluster = @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarJuntaDirectivaPK
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster
       
    FROM JuntaDirectiva AS JD
    WHERE JD.IdJuntaDirectiva = @IdJuntaDirectiva;

END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarMiembroJDPK
@IdMiembro INT
AS
BEGIN
    
    SELECT
        P.IdPersona,CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, '')) AS Miembro, 
        MJD.IdJuntaDirectiva,
        MJD.IdPropietario,
        MJD.idPuesto,
        PJD.Nombre AS Puesto,
        MJD.FechaInicio,
        MJD.FechaFin
    FROM MiembroJuntaDirectiva MJD
    INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
    INNER JOIN Persona AS P ON PR.IdPersona = P.IdPersona
    INNER JOIN PuestoJuntaDirectiva AS PJD ON MJD.idPuesto = PJD.idPuesto
    
    WHERE
       MJD.IdMiembro = @IdMiembro
       
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersona
@IdPersona INT
AS
BEGIN
    SELECT *
    FROM Persona
    WHERE IdPersona= @IdPersona
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPropietario
@IdPropiestario INT
AS
BEGIN
    SELECT P.IdPropietario,SP_.IdPersona,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario'
    FROM Propietario AS P 
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    WHERE IdPropietario = @IdPropiestario
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPuestoJDPK
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
   
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva  AS PJD
    WHERE PJD.IdPuesto = @IdPuestoJuntaDirectiva;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidencialPK
@IdResidencial INT
AS
BEGIN
    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        IdResidencial = @IdResidencial;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidentePK
@IdResidente INT
AS
BEGIN
    SELECT *
    FROM Residente
    WHERE IdResidente =@IdResidente
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN
    SELECT *
    FROM TipoVivienda
    WHERE IdTipoVivienda= @IdTipoVivienda
END;

GO
Create OR Alter Procedure SP_BuscarVivienda
@NumeroVivienda INT,
@IdCluster INT

AS

Begin 
    Select *     from Vivienda
    Where  NumeroVivienda = @NumeroVivienda  and IdCluster = @IdCluster;
End;

GO
CREATE OR ALTER PROCEDURE SP_BuscarClusterPorDescripcion
@NombreCluster VARCHAR(30)
AS
BEGIN 
    SELECT IdCluster, Descripcion AS 'Nombre Cluster'
    FROM Cluster
    WHERE Descripcion =  @NombreCluster
END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarJuntaDirectivaPorCluster
    @IdCluster INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster
       
    FROM JuntaDirectiva JD
    WHERE JD.IdCluster = @IdCluster
    
END


GO

GO
CREATE OR ALTER PROCEDURE SP_BuscarMiembrosPorJunta
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        MJD.IdPropietario,
        CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario',
        PJD.Nombre AS Puesto
    FROM MiembroJuntaDirectiva AS MJD
    INNER JOIN Propietario P ON MJD.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto = PJD.IdPuesto
    WHERE MJD.IdJuntaDirectiva = @IdJuntaDirectiva
    
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaPorCui
@NumeroDeIdentificacion VARCHAR(30)
AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ', P.PrimerApellido) AS Nombre, P.Cui As 'Numero de Identificacion'
    FROM PERSONA AS P
    WHERE Cui = @NumeroDeIdentificacion
END;

GO
-- La llamada 'EXEC SP_BuscarPersonaPorCui...' se eliminó para dejar solo el cuerpo del SP_.
CREATE OR ALTER PROCEDURE SP_BuscarPersonaPorNombreCompleto
@Nombres VARCHAR(60)

AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') ,' ' ,P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
    FROM Persona AS P 
    WHERE CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') , ' ',P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
    LIKE '%' + @Nombres + '%' 
    
END;

GO
-- La llamada 'EXEC SP_BuscarPersonaPorNombreCompleto...' se eliminó para dejar solo el cuerpo del SP_.
CREATE OR ALTER PROCEDURE SP_buscarPropietarioPorCluster
@IdCluster INT
AS
BEGIN
    SELECT P.IdPropietario,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario',C.IdCluster, V.NumeroVivienda, TV.Descripcion AS 'Tipo de Vivienda'
    FROM Propietario AS P
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    INNER JOIN Vivienda AS V ON P.IdPropietario = V.IdPropietario
    INNER JOIN TipoVivienda AS TV ON V.IdTipoVivienda = TV.IdTipoVivienda
    INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
    WHERE C.IdCluster = @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPropietarioPorGenero
@Genero CHAR(1)
AS
BEGIN
    SELECT P.IdPropietario,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario', SP_.Genero
    FROM Propietario AS P
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    WHERE SP_.Genero = @Genero

END;

GO

CREATE OR ALTER  PROCEDURE SP_BuscarPuestoJDPorDescripcion
    @PalabraClave VARCHAR(50)
AS
BEGIN
    
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva PJD
    WHERE PJD.Descripcion LIKE '%' + @PalabraClave + '%';
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarPuestoJDPorNombre
    @Nombre VARCHAR(15)
AS
BEGIN
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva AS PJD
    WHERE PJD.Nombre LIKE '%' + @Nombre + '%';
END

GO
CREATE  OR ALTER PROCEDURE SP_BuscarPuestosPorPropietario
    @IdPropietario INT
AS
BEGIN
    
    SELECT
		P.PrimerNombre,
        MJD.IdJuntaDirectiva,
       	PJD.Nombre AS Puesto
      
    FROM MiembroJuntaDirectiva MJD
	INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
	INNER JOIN Persona AS P ON PR.IdPersona =  P.IdPersona
   	INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto= PJD.IdPuesto
    WHERE MJD.IdPropietario = @IdPropietario
    
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarResidencialCoicidencianombre
    @NombreParcial VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre LIKE '%' + @NombreParcial + '%';
END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarResidencialPorNombre
@Nombre VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre = @Nombre;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidentePorEstado
@Estado VARCHAR(10)
AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ', COALESCE(P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ',COALESCE (P.SegundoApellido, '')) AS 'NOMBRES Y APELLIDOS', R.Estado
    FROM Residente AS R
    INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona
    WHERE Estado = @Estado
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarResidentePorNumVivienda
@NumeroVivienda INT
AS
BEGIN
     SELECT CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, ''))AS 'Residente',R.IdResidente, R.NumeroVivienda, R.IdCluster
     FROM Residente AS R
     INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona 
     WHERE NumeroVivienda = @NumeroVivienda
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoViviendaPorNumeroHabitaciones
@NumeroHabitaciones INT
AS
BEGIN
    SELECT TV.IdTipoVivienda, TV.Descripcion AS TipoVivienda,TV.NumeroHabitaciones, V.NumeroVivienda, V.IdCluster
    FROM TipoVivienda  AS TV
    INNER JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
    WHERE TV.NumeroHabitaciones = @NumeroHabitaciones
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoDeViviendaSINEstacionamiento
AS
BEGIN
    SELECT TV.IdTipoVivienda,TV.Descripcion AS TipoVivienda,TV.Estacionamiento, V.NumeroVivienda, V.IdCluster
    FROM TipoVivienda AS TV
    Left JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
    WHERE TV.Estacionamiento = 0
END;

GO
Create Or Alter  Procedure SP_buscarViviendaPorPropietario
@IdPropietario Int
As
Begin
    SELECT V.NumeroVivienda, V.IdCluster, CONCAT(P.PrimerNombre, P.PrimerApellido) As propietario, TV.Descripcion
    FROM Vivienda As V
    Inner join TipoVivienda As TV on v.IdTipoVivienda = TV.IdTipoVivienda
    Inner Join Propietario As PT on V.IdPropietario = PT.IdPropietario
    Inner Join Persona As P on PT.IdPersona = P.IdPersona
    Where PT.IdPropietario = @IdPropietario
End;

GO
Create or alter Procedure SP_BuscarViviendaPorTipoVivienda
@IdTipoVivienda INT
As
Begin
    Select V.IdCluster, V.NumeroVivienda, TV.*
    From Vivienda As V
    Inner Join TipoVivienda As TV On V.IdTipoVivienda = tv.IdTipoVivienda
    Where TV.IdTipoVivienda = @IdTipoVivienda
End;

GO--
CREATE OR ALTER PROCEDURE SP_BuscarPuestoEmpleadoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN
   SELECT IdPuestoEmpleado, Nombre, Descripcion
   FROM PuestoEmpleado
   WHERE Descripcion = @Descripcion
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado INT,
@Nombre VARCHAR(50),
@Descripcion VARCHAR(50)
AS 
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se encontro el puesto de empleado',16,1)
RETURN
END

UPDATE PuestoEmpleado
SET Nombre = @Nombre,
Descripcion = @Descripcion
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPuestoTrabajoPorNombre
@Nombre VARCHAR(50)
AS
BEGIN
SELECT * 
FROM PuestoEmpleado
WHERE Nombre = @Nombre
END

GO
CREATE OR ALTER PROCEDURE SP_CrearPuestoEmpleado
@Nombre VARCHAR(50),
@Descripcion varchar(50)
AS
BEGIN

SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM PuestoEmpleado WHERE Nombre = @Nombre)
BEGIN
RAISERROR('Ya hay un puesto con ese nombre',16,1)
RETURN
END

INSERT INTO PuestoEmpleado(Nombre, Descripcion)
VALUES (@Nombre, @Descripcion)
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarPuestoEmpleado
@IdPuestoEmpleado INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN 
RAISERROR('No existe este puesto',16,1)
RETURN
END

IF EXISTS (SELECT 1 FROM Empleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se puede eliminar este puesto porque hay empleados asignados',16,1)
RETURN
END

DELETE FROM PuestoEmpleado
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_ObtenerPuestoEmpleadoPorId
@IdPuestoEmpleado INT
AS
BEGIN
SELECT * FROM PuestoEmpleado AS pe
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO

CREATE OR ALTER PROCEDURE SP_InsertarCluster
@Descripcion VARCHAR(30),
@IdResidencial INT
AS
BEGIN
    INSERT INTO Cluster(Descripcion, IdResidencial)
    VALUES(@Descripcion, @IdResidencial)
    SELECT SCOPE_IDENTITY() AS IdCluster
END;

GO
CREATE  OR ALTER PROCEDURE SP_InsertarMiembroJD
    @Estado VARCHAR(10),
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    INSERT INTO MiembroJuntaDirectiva (Estado,FechaInicio,FechaFin,IdJuntaDirectiva, IdPropietario, IdPuesto)
    VALUES (@Estado,@FechaInicio,@FechaFin, @IdJuntaDirectiva, @IdPropietario, @IdPuestoJuntaDirectiva)
    SELECT SCOPE_IDENTITY() AS 'IdMiembroJuntaDirectiva'
    
END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarPersona
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30) ,
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(10) ,
@Telefono VARCHAR(30),
@Genero CHAR(1),
@FechaNacimiento DATE ,
@EstadoCivil VARCHAR(15)

AS
BEGIN
    INSERT INTO Persona(Cui,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,Telefono,Genero,FechaNacimiento, EstadoCivil )
    VALUES(@Cui,@PrimerNombre,@SegundoNombre ,@PrimerApellido,@SegundoApellido ,@Telefono,@Genero,@FechaNacimiento,@EstadoCivil  )
    SELECT SCOPE_IDENTITY() AS IdPersona

END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarPropietario
@Estado VARCHAR(10) ,
@IdPersona INT
AS
BEGIN
    INSERT INTO Propietario(Estado,IdPersona)
    VALUES(@Estado, @IdPersona)
    SELECT SCOPE_IDENTITY() AS IdPropietario;
END; 

GO
CREATE OR ALTER PROCEDURE SP_InsertarPuestoJD
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);
    
    SELECT SCOPE_IDENTITY() AS IdPuesto;
END;

GO

CREATE  OR ALTER PROCEDURE SP_InsertarResidencial
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Residencial (Nombre)
    VALUES (@Nombre);

    
    SELECT SCOPE_IDENTITY() AS IdResidencial;
END;

GO
CREATE OR ALTER PROCEDURE SP_InsertarResidente
@IdPersona INT,
@NumeroVivienda INT,
@IdCluster INT,
@EsInquilino BIT,
@Estado VARCHAR(10)
AS
BEGIN
    INSERT INTO Residente(IdPersona, NumeroVivienda, Estado, IdCluster, EsInquilino)
    VALUES(@IdPersona, @NumeroVivienda, @IdCluster, @EsInquilino, @Estado);
    SELECT SCOPE_IDENTITY() AS IdResidente
END;

GO
Create Or Alter Procedure SP_InsertarTipoVivienda
@Descripcion VARCHAR(100),
@NumeroHabitaciones INT,
@SuperficieTotal Decimal,
@NumeroPisos INT,
@Estacionamiento Bit

As

Begin 
    Insert into TipoVivienda(Descripcion ,NumeroHabitaciones,SuperficieTotal ,NumeroPisos ,Estacionamiento  )
    Values (@Descripcion ,@NumeroHabitaciones,@SuperficieTotal ,@NumeroPisos ,@Estacionamiento );
    
End;

GO
Create  OR ALTER Procedure SP_CrearVivienda
@NumeroVivienda INT, 
@IdCluster INT,  
@IdTipoVivienda INT,
@IdPropietario INT
As
Begin 
    Insert Into Vivienda(NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) 
    Values (@NumeroVivienda, @IdCluster,  @IdTipoVivienda, @IdPropietario);
    Select @NumeroVivienda ;
End;

GO
CREATE OR ALTER  PROCEDURE SP_InsertarJuntaDirectiva
@IdCluster INT
    
AS
BEGIN
    INSERT INTO JuntaDirectiva (IdCluster)
    VALUES (@IdCluster);
    
    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva;
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarCluster
@IdCluster INT
AS
BEGIN 
    DELETE Cluster 
    Where IdCluster = @IdCluster
    Select @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarJuntaDirectiva
    @IdJuntaDirectiva INT
AS
BEGIN
    IF EXISTS (SELECT *     FROM MiembroJuntaDirectiva 
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva)
    BEGIN
        
        RAISERROR('No se puede eliminar la Junta Directiva porque tiene miembros registrados. Debe eliminar primero los miembros.', 16, 1);
        RETURN 0;
    END;
    
    DELETE JuntaDirectiva
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva 
    
END;

GO
CREATE  OR ALTER PROCEDURE SP_EliminarMiembroJD
@IdMiembroJD INT
AS
BEGIN

    IF EXISTS (SELECT *         
	FROM MiembroJuntaDirectiva 
        WHERE IdMiembro = @IdMiembroJD And Estado = 'ACTIVO')
        BEGIN
        
            RAISERROR('No se puede eliminar el miembro porque aun esta activo.', 16, 1);
            RETURN 0;
        END
    DELETE FROM MiembroJuntaDirectiva
    WHERE
        IdMiembro =@IdMiembroJD 
        
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPersona
@IdPersona INT
AS
BEGIN
    DELETE Persona 
    WHERE IdPersona = @IdPersona
    SELECT @IdPersona 

END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPropietario
@IdPropietario INT
AS 
BEGIN
    DELETE Propietario
    WHERE IdPropietario = @IdPropietario
    SELECT @IdPropietario
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarPuestoJD
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    
    IF EXISTS (SELECT *     FROM MiembroJuntaDirectiva 
    WHERE IdPuesto = @IdPuestoJuntaDirectiva)
    BEGIN
     
        RAISERROR('No se puede eliminar el Puesto porque esta siendo usado en MiembroJuntaDirectiva.',16,1);
        RETURN 0;
    END
    
    
    DELETE FROM PuestoJuntaDirectiva
    WHERE IdPuesto = @IdPuestoJuntaDirectiva;
       
END;

GO
CREATE  OR ALTER PROCEDURE SP_EliminarResidencial
    @IdResidencial INT
AS
BEGIN

    DELETE FROM Residencial
    WHERE IdResidencial = @IdResidencial;
    
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarResidente
@IdResidente INT
AS
BEGIN
    DELETE Residente
    WHERE IdResidente = @IdResidente
    SELECT @IdResidente
END;

GO
CREATE OR ALTER PROCEDURE SP_EliminarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN 
    DELETE TipoVivienda
    WHERE IdTipoVivienda = @IdTipoVivienda
    SELECT @IdTipoVivienda
END;

GO
Create Or Alter Procedure SP_EliminarVivienda
@NumeroVivienda INT, 
@IdCluster INT 

AS
Begin

    IF EXISTS(
    SELECT *
    FROM Residente
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
    ) 
    BEGIN
        RAISERROR('No se puede eliminar la vivienda porque hay residentes asociados',16,1)
        RETURN 0;
    END;
    
    Delete Vivienda
    Where NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster;
End;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarCluster
@IdCluster INT,
@Descripcion VARCHAR (30)
AS
BEGIN
    UPDATE Cluster
    SET Descripcion=@Descripcion 
    WHERE IdCluster=@IdCluster
    SELECT SCOPE_IDENTITY() AS IdCluster
    
END;

GO
CREATE OR ALTER  PROCEDURE SP_ActualizarJuntaDirectiva
@IdJuntaDirectiva INT,
@IdCluster INT
  
AS
BEGIN
    UPDATE JuntaDirectiva
    SET
        IdCluster = @IdCluster
        
    WHERE
        IdJuntaDirectiva = @IdJuntaDirectiva;

    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva
        
    
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPersona
@IdPersona INT ,
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30),
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(30),
@Telefono VARCHAR(30) ,
@Genero CHAR(1) ,
@FechaNacimiento DATE ,
@EstadoCivil VARCHAR(15)

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
    Genero  = @Genero   ,
    FechaNacimiento = @FechaNacimiento,
    EstadoCivil = @EstadoCivil
    
    WHERE IdPersona =@IdPersona
    SELECT @IdPersona

END;

GO
CREATE  OR ALTER PROCEDURE SP_ActualizarPropietario
    @IdPropietario INT,
    @Estado VARCHAR(20) ,
    @IdPersona INT
AS
BEGIN
        UPDATE Propietario
            SET IdPersona = @IdPersona, 
            Estado = @Estado
            WHERE IdPropietario = @IdPropietario;

        SELECT @IdPropietario 
   
END;

GO
CREATE  OR ALTER PROCEDURE SP_ActualizarPuestoJD
    @IdPuestoJuntaDirectiva INT,
    @Nombre VARCHAR(15),
    @Descripcion VARCHAR(100)
AS
BEGIN
    
    UPDATE PuestoJuntaDirectiva
    SET
        Nombre = @Nombre,
        Descripcion = @Descripcion
    WHERE
        IdPuesto = @IdPuestoJuntaDirectiva;
    SELECT @IdPuestoJuntaDirectiva
           
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarResidencial
@IdResidencial INT,
@Nombre VARCHAR(50)
AS
BEGIN
    UPDATE Residencial
    SET
        Nombre = @Nombre
    WHERE
        IdResidencial = @IdResidencial;
   
END;

GO
CREATE OR ALTER PROCEDURE SP_ActualizarResidente
    @IdResidente INT,
    @NumeroVivienda INT,
    @IdCluster INT,
    @EsInquilino BIT ,
    @Estado VARCHAR(10)
   
AS
BEGIN
    
        UPDATE Residente
        SET 
            NumeroVivienda = @NumeroVivienda,
            IdCluster = @IdCluster,
            EsInquilino = @EsInquilino,
            Estado = @Estado
            
        WHERE IdResidente = @IdResidente;
        SELECT @IdResidente
END;

GO
CREATE OR ALTER  PROCEDURE SP_ActualizarTipoVivienda
@IdTipoVivienda INT,
@Descripcion VARCHAR(50),
@NumeroHabitaciones INT,
@SuperficieTotal DECIMAL,
@NumeroPisos INT,
@Estacionamiento BIT
AS
BEGIN
    UPDATE TipoVivienda
    SET Descripcion = @Descripcion,
        NumeroHabitaciones = @NumeroHabitaciones,
        SuperficieTotal = @SuperficieTotal,
        NumeroPisos = @NumeroPisos,
        Estacionamiento = @Estacionamiento
    WHERE IdTipoVivienda = @IdTipoVivienda;
    Select @IdTipoVivienda

END;

GO
Create Or Alter Procedure SP_ActualizarVivivenda
@NumeroVivienda INT, 
@IdCluster INT, 
@IdPropietario INT, 
@IdTipoVivienda INT
AS

Begin
    Update  Vivienda 
    Set IdPropietario =@IdPropietario, 
        IdTipoVivienda =@IdTipoVivienda 
    Where NumeroVivienda = @NumeroVivienda and IdCluster= @IdCluster
End;

GO
CREATE OR ALTER PROCEDURE SP_BuscarCluster
@IdCluster INT
AS
BEGIN
    SELECT *
    FROM Cluster
    WHERE IdCluster = @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarJuntaDirectivaPK
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster
       
    FROM JuntaDirectiva AS JD
    WHERE JD.IdJuntaDirectiva = @IdJuntaDirectiva;

END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarMiembroJDPK
@IdMiembro INT
AS
BEGIN
    
    SELECT
        P.IdPersona,CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, '')) AS Miembro, 
        MJD.IdJuntaDirectiva,
        MJD.IdPropietario,
        MJD.idPuesto,
        PJD.Nombre AS Puesto,
        MJD.FechaInicio,
        MJD.FechaFin
    FROM MiembroJuntaDirectiva MJD
    INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
    INNER JOIN Persona AS P ON PR.IdPersona = P.IdPersona
    INNER JOIN PuestoJuntaDirectiva AS PJD ON MJD.idPuesto = PJD.idPuesto
    
    WHERE
       MJD.IdMiembro = @IdMiembro
       
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersona
@IdPersona INT
AS
BEGIN
    SELECT *
    FROM Persona
    WHERE IdPersona= @IdPersona
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPropietario
@IdPropiestario INT
AS
BEGIN
    SELECT P.IdPropietario,SP_.IdPersona,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario'
    FROM Propietario AS P 
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    WHERE IdPropietario = @IdPropiestario
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPuestoJDPK
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
   
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva  AS PJD
    WHERE PJD.IdPuesto = @IdPuestoJuntaDirectiva;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidencialPK
@IdResidencial INT
AS
BEGIN
    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        IdResidencial = @IdResidencial;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidentePK
@IdResidente INT
AS
BEGIN
    SELECT *
    FROM Residente
    WHERE IdResidente =@IdResidente
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN
    SELECT *
    FROM TipoVivienda
    WHERE IdTipoVivienda= @IdTipoVivienda
END;

GO
Create OR Alter Procedure SP_BuscarVivienda
@NumeroVivienda INT,
@IdCluster INT

AS

Begin 
    Select *     from Vivienda
    Where  NumeroVivienda = @NumeroVivienda  and IdCluster = @IdCluster;
End;

GO
CREATE OR ALTER PROCEDURE SP_BuscarClusterPorDescripcion
@NombreCluster VARCHAR(30)
AS
BEGIN 
    SELECT IdCluster, Descripcion AS 'Nombre Cluster'
    FROM Cluster
    WHERE Descripcion =  @NombreCluster
END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarJuntaDirectivaPorCluster
    @IdCluster INT
AS
BEGIN
    
    SELECT
        JD.IdJuntaDirectiva,
        JD.IdCluster
       
    FROM JuntaDirectiva JD
    WHERE JD.IdCluster = @IdCluster
    
END


GO

GO
CREATE OR ALTER PROCEDURE SP_BuscarMiembrosPorJunta
    @IdJuntaDirectiva INT
AS
BEGIN
    
    SELECT
        MJD.IdPropietario,
        CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario',
        PJD.Nombre AS Puesto
    FROM MiembroJuntaDirectiva AS MJD
    INNER JOIN Propietario P ON MJD.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto = PJD.IdPuesto
    WHERE MJD.IdJuntaDirectiva = @IdJuntaDirectiva
    
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaPorCui
@NumeroDeIdentificacion VARCHAR(30)
AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ', P.PrimerApellido) AS Nombre, P.Cui As 'Numero de Identificacion'
    FROM PERSONA AS P
    WHERE Cui = @NumeroDeIdentificacion
END;

GO
-- La llamada 'EXEC SP_BuscarPersonaPorCui...' se eliminó para dejar solo el cuerpo del SP_.
CREATE OR ALTER PROCEDURE SP_BuscarPersonaPorNombreCompleto
@Nombres VARCHAR(60)

AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') ,' ' ,P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
    FROM Persona AS P 
    WHERE CONCAT(P.PrimerNombre, ' ',COALESCE( P.SegundoNombre, '') , ' ',P.PrimerApellido, ' ' ,COALESCE(P.SegundoApellido, '' ))
    LIKE '%' + @Nombres + '%' 
    
END;

GO
-- La llamada 'EXEC SP_BuscarPersonaPorNombreCompleto...' se eliminó para dejar solo el cuerpo del SP_.
CREATE OR ALTER PROCEDURE SP_buscarPropietarioPorCluster
@IdCluster INT
AS
BEGIN
    SELECT P.IdPropietario,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario',C.IdCluster, V.NumeroVivienda, TV.Descripcion AS 'Tipo de Vivienda'
    FROM Propietario AS P
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    INNER JOIN Vivienda AS V ON P.IdPropietario = V.IdPropietario
    INNER JOIN TipoVivienda AS TV ON V.IdTipoVivienda = TV.IdTipoVivienda
    INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
    WHERE C.IdCluster = @IdCluster
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarPropietarioPorGenero
@Genero CHAR(1)
AS
BEGIN
    SELECT P.IdPropietario,CONCAT(SP_.PrimerNombre, ' ',COALESCE (SP_.SegundoNombre, ''), ' ', SP_.PrimerApellido, ' ', COALESCE (SP_.SegundoApellido, ''))AS 'Propietario', SP_.Genero
    FROM Propietario AS P
    INNER JOIN Persona AS SP_ ON P.IdPersona = SP_.IdPersona
    WHERE SP_.Genero = @Genero

END;

GO

CREATE OR ALTER  PROCEDURE SP_BuscarPuestoJDPorDescripcion
    @PalabraClave VARCHAR(50)
AS
BEGIN
    
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva PJD
    WHERE PJD.Descripcion LIKE '%' + @PalabraClave + '%';
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarPuestoJDPorNombre
    @Nombre VARCHAR(15)
AS
BEGIN
    SELECT
        PJD.IdPuesto,
        PJD.Nombre,
        PJD.Descripcion
    FROM PuestoJuntaDirectiva AS PJD
    WHERE PJD.Nombre LIKE '%' + @Nombre + '%';
END

GO
CREATE  OR ALTER PROCEDURE SP_BuscarPuestosPorPropietario
    @IdPropietario INT
AS
BEGIN
    
    SELECT
		P.PrimerNombre,
        MJD.IdJuntaDirectiva,
       	PJD.Nombre AS Puesto
      
    FROM MiembroJuntaDirectiva MJD
	INNER JOIN Propietario AS PR ON MJD.IdPropietario = PR.IdPropietario
	INNER JOIN Persona AS P ON PR.IdPersona =  P.IdPersona
   	INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto= PJD.IdPuesto
    WHERE MJD.IdPropietario = @IdPropietario
    
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarResidencialCoicidencianombre
    @NombreParcial VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre LIKE '%' + @NombreParcial + '%';
END;

GO
CREATE  OR ALTER PROCEDURE SP_BuscarResidencialPorNombre
@Nombre VARCHAR(50)
AS
BEGIN

    SELECT
        IdResidencial,
        Nombre
    FROM
        Residencial
    WHERE
        Nombre = @Nombre;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarResidentePorEstado
@Estado VARCHAR(10)
AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ', COALESCE(P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ',COALESCE (P.SegundoApellido, '')) AS 'NOMBRES Y APELLIDOS', R.Estado
    FROM Residente AS R
    INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona
    WHERE Estado = @Estado
END;

GO
CREATE OR ALTER  PROCEDURE SP_BuscarResidentePorNumVivienda
@NumeroVivienda INT
AS
BEGIN
     SELECT CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, ''))AS 'Residente',R.IdResidente, R.NumeroVivienda, R.IdCluster
     FROM Residente AS R
     INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona 
     WHERE NumeroVivienda = @NumeroVivienda
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoViviendaPorNumeroHabitaciones
@NumeroHabitaciones INT
AS
BEGIN
    SELECT TV.IdTipoVivienda, TV.Descripcion AS TipoVivienda,TV.NumeroHabitaciones, V.NumeroVivienda, V.IdCluster
    FROM TipoVivienda  AS TV
    INNER JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
    WHERE TV.NumeroHabitaciones = @NumeroHabitaciones
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarTipoDeViviendaSINEstacionamiento
AS
BEGIN
    SELECT TV.IdTipoVivienda,TV.Descripcion AS TipoVivienda,TV.Estacionamiento, V.NumeroVivienda, V.IdCluster
    FROM TipoVivienda AS TV
    Left JOIN Vivienda AS V ON TV.IdTipoVivienda = V.IdTipoVivienda
    WHERE TV.Estacionamiento = 0
END;

GO
Create Or Alter  Procedure SP_buscarViviendaPorPropietario
@IdPropietario Int
As
Begin
    SELECT V.NumeroVivienda, V.IdCluster, CONCAT(P.PrimerNombre, P.PrimerApellido) As propietario, TV.Descripcion
    FROM Vivienda As V
    Inner join TipoVivienda As TV on v.IdTipoVivienda = TV.IdTipoVivienda
    Inner Join Propietario As PT on V.IdPropietario = PT.IdPropietario
    Inner Join Persona As P on PT.IdPersona = P.IdPersona
    Where PT.IdPropietario = @IdPropietario
End;

GO
Create or alter Procedure SP_BuscarViviendaPorTipoVivienda
@IdTipoVivienda INT
As
Begin
    Select V.IdCluster, V.NumeroVivienda, TV.*
    From Vivienda As V
    Inner Join TipoVivienda As TV On V.IdTipoVivienda = tv.IdTipoVivienda
    Where TV.IdTipoVivienda = @IdTipoVivienda
End;

GO--
CREATE OR ALTER PROCEDURE SP_BuscarPuestoEmpleadoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN
   SELECT IdPuestoEmpleado, Nombre, Descripcion
   FROM PuestoEmpleado
   WHERE Descripcion = @Descripcion
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPuestoEmpleado
@IdPuestoEmpleado INT,
@Nombre VARCHAR(50),
@Descripcion VARCHAR(50)
AS 
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se encontro el puesto de empleado',16,1)
RETURN
END

UPDATE PuestoEmpleado
SET Nombre = @Nombre,
Descripcion = @Descripcion
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPuestoTrabajoPorNombre
@Nombre VARCHAR(50)
AS
BEGIN
SELECT * 
FROM PuestoEmpleado
WHERE Nombre = @Nombre
END

GO
CREATE OR ALTER PROCEDURE SP_CrearPuestoEmpleado
@Nombre VARCHAR(50),
@Descripcion varchar(50)
AS
BEGIN

SET NOCOUNT ON
IF EXISTS(SELECT 1 FROM PuestoEmpleado WHERE Nombre = @Nombre)
BEGIN
RAISERROR('Ya hay un puesto con ese nombre',16,1)
RETURN
END

INSERT INTO PuestoEmpleado(Nombre, Descripcion)
VALUES (@Nombre, @Descripcion)
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarPuestoEmpleado
@IdPuestoEmpleado INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM PuestoEmpleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN 
RAISERROR('No existe este puesto',16,1)
RETURN
END

IF EXISTS (SELECT 1 FROM Empleado WHERE IdPuestoEmpleado = @IdPuestoEmpleado)
BEGIN
RAISERROR('No se puede eliminar este puesto porque hay empleados asignados',16,1)
RETURN
END

DELETE FROM PuestoEmpleado
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_ObtenerPuestoEmpleadoPorId
@IdPuestoEmpleado INT
AS
BEGIN
SELECT * FROM PuestoEmpleado AS pe
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarTurno
@IdTurno INT,
@Descripcion VARCHAR(50),
@HoraInicio DATETIME,
@HoraFin DATETIME
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('No existe este turno',16,1)
RETURN
END

UPDATE Turno
SET Descripcion = @Descripcion,
HoraInicio = @HoraInicio,
HoraFin = @HoraFin
WHERE IdTurno = @IdTurno
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.Descripcion = @Descripcion
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorHoraInicioYHoraFin
@HoraInicio DATETIME,
@HoraFin DATETIME
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.HoraInicio = @HoraInicio AND t.HoraFin = @HoraFin
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarTurno
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('No existe este turno',16,1)
RETURN
END 

IF EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('Este turno tiene empleados asignados',16,1)
RETURN
END

DELETE FROM Turno
WHERE IdTurno = @IdTurno
END

GO
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

GO
CREATE OR ALTER PROCEDURE SP_ObtenerTurnoPorId
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN
RAISERROR('No existe este turno',16,1)
RETURN
END

SELECT IdTurno, Descripcion, HoraInicio, HoraFin 
FROM Turno
WHERE IdTurno = @IdTurno;
END 

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPersonaNoGrata
@IdPeronaNoGrata INT,
@FechaInicio DATE = NULL,
@FechaFin DATE = NULL,
@Motivo VARCHAR(100) = NULL
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPeronaNoGrata)
BEGIN
RAISERROR('Esta persona no existe en la lista de no gratos',16,1)
RETURN
END

UPDATE PersonaNoGrata
SET FechaInicio = @FechaInicio,
FechaFin = @FechaFin,
Motivo = @Motivo
WHERE idPersonaNoGrata = @IdPeronaNoGrata
PRINT 'Se actualizo a la persona no grata'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPeronaNoGrataPorId
@IdPersonaNoGrata INT 
AS
BEGIN
SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaFin
@FechaFin DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaFin IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.FechaFin = @FechaFin
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaInicio
@IdPersonaNoGrata INT,
@FechaInicio DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaInicio IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata AND  pn.FechaInicio = @FechaInicio
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarPersonaNoGrata
@IdPersonaNoGrata INT
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPersonaNograta)
BEGIN
RAISERROR('Esta persona no se encuentra en el registro de no gratos',16,1)
RETURN
END

DELETE FROM PersonaNoGrata 
WHERE IdPersonaNoGrata = @IdPersonaNoGrata 
PRINT 'Persona eliminada correctamente de no gratos'
END

GO
CREATE OR ALTER PROCEDURE SP_InsertarPersonaNoGrata
@FechaInicio DATE,
@FechFin DATE = NULL,
@Motivo VARCHAR(50),
@IdPersona INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
BEGIN 
RAISERROR('La persona ingresada no existe',16,1)
RETURN
END

IF EXISTS(SELECT 1 FROM PersonaNoGrata WHERE IdPersona = @IdPersona AND (FechaFin IS NULL OR FechaFin >= CAST(GETDATE() AS DATE)))
BEGIN 
RAISERROR('La persona que intentas ingresar ya existe en esta lista y aun no puede ingresar de nuevo hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO PersonaNoGrata(FechaInicio,FechaFin, Motivo, IdPersona)
VALUES(@FechaInicio, @FechFin, @Motivo, @IdPersona)
PRINT 'Persona ingresada correctamente a la lista de no gratos'
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarVehiculoProhibido
@IdVehiculoProhibido INT,
@Fecha DATE,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN
RAISERROR('El vehiculo no existe en la lista de prohibidos',16,1)
RETURN
END

UPDATE VehiculoProhibido
SET Fecha = @Fecha,
Motivo = @Motivo,
IdVehiculo = @IdVehiculo
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'Vehiculo Prohibido actualizado exitosamente'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorFecha
@Fecha DATE
AS
BEGIN
SELECT vp.IdVehiculoProhibido, vp.Fecha, vp.Motivo, v.IdVehiculo, v.Placa, m.Descripcion AS Marca FROM VehiculoProhibido AS vp
INNER JOIN Vehiculo v ON vp.IdVehiculo = v.IdVehiculo
INNER JOIN Marca m ON v.IdMarca = M.IdMarca
WHERE vp.Fecha = @Fecha
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorId
@IdVehiculoProhibido INT
AS
BEGIN
SELECT * FROM VehiculoProhibido 
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarVehiculoProhibido
@IdVehiculoProhibido INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN 
RAISERROR('El vehiculo dado no se encuentra en la lista de prohibidos',16,1)
RETURN
END

DELETE FROM VehiculoProhibido
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'El vehiculo fue eliminado de la lista de prohibidos'
END

GO
CREATE OR ALTER PROCEDURE SP_InsertarVehiculoProhibido
@Fecha DATE = NULL,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Vehiculo WHERE IdVehiculo = @IdVehiculo)
BEGIN 
RAISERROR('El vehicuilo que intenta ingresar en la lista de prohibidos no exsite',16,1)
RETURN 
END

IF EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculo = @IdVehiculo AND (Fecha IS NULL OR FECHA >= CAST(GETDATE() AS DATE)))
BEGIN
RAISERROR('El vehiculo ya se encuentra prohibido y no puede ser prohibido de nuevo  hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO VehiculoProhibido(Fecha, Motivo, IdVehiculo)
VALUES(@Fecha, @Motivo, @IdVehiculo)
PRINT 'Vehiculo ingresado correctamente en la lista de vehiculos prohibidos'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorNombre
@PrimerNombre VARCHAR(50),
@PrimerApellido VARCHAR(50)
AS
BEGIN
SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto  FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
WHERE p.PrimerNombre = @PrimerNombre AND p.PrimerApellido = @PrimerApellido
END

GO
CREATE OR ALTER PROCEDURE SP_ObtenerEmpleadosPorPuesto
@IdPuestoEmpleado INT
AS
BEGIN
   SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreEmpleado, pe.Nombre AS Puesto FROM Persona AS p
   INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
   INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
   WHERE e.IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarEmpleados
@IdEmpleado INT,
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS 
BEGIN

SET NOCOUNT ON
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN
RAISERROR('Este empleado no existe',16,1)
RETURN 
END

UPDATE Empleado
SET FechaAlta = @FechaAlta,
FechaBaja = @FechaBaja,
Estado = @Estado,
IdPersona = @IdPersona,
IdPuestoEmpleado = @IdPuestoEmpleado
WHERE IdEmpleado = @IdEmpleado
END TRY
BEGIN CATCH
RAISERROR('Error al intentar actulizar al empleado dado por que no existe',16,1)
END CATCH
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorId
@IdEmpleado INT
AS
BEGIN
SELECT e.IdEmpleado, e.IdPersona, p.PrimerNombre, p.PrimerApellido
FROM Empleado AS e
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado;
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarEmpleado 
@IdEmpleado INT
AS
Begin

SET NOCOUNT ON
IF EXISTS (SELECT 1 FROM AsignacionTurno WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No se puede elminar al empleado ya que tiene asigandos turnos',16,1)
RETURN 
END

IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No existe el empleado con el IdEmpleado especificado',16,1)
RETURN
END
	Delete FROM Empleado
	Where IdEmpleado = @IdEmpleado;
End;

GO
CREATE OR ALTER PROCEDURE SP_InsertarEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN

 
    IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
    BEGIN
        RAISERROR('No existe esta persona en la base de datos', 16,1)
        RETURN 
    END

    IF EXISTS(
    SELECT 1 
    FROM Empleado 
    WHERE IdPersona = @IdPersona AND Estado = 'ACTIVO')
    BEGIN
        RAISERROR('Esta persona ya es un empleado en actividad',16,1)
        RETURN 
    END

    INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
        VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);
END

GO
----GARITA
CREATE OR ALTER PROCEDURE SP_ActualizarGarita
    @IdGarita INT,
    @IdCluster INT
AS
BEGIN
    UPDATE Garita 
    SET IdCluster = @IdCluster
    WHERE IdGarita = @IdGarita
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorClusterGarita
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarTodasGarita
AS
BEGIN
    SELECT * FROM Garita
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarGarita
    @IdGarita INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdGarita = @IdGarita)
        BEGIN
           PRINT 'Error: No se puede eliminar la garita ID ' + CAST(@IdGarita AS VARCHAR) + ' existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Garita WHERE IdGarita = @IdGarita

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la garita con ID ' + CAST(@IdGarita AS VARCHAR)
            RETURN 0
        END
        COMMIT TRANSACTION
		PRINT 'Garita eliminada correctamente. ID: ' + CAST(@IdGarita AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar garita: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarGarita
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (IdCluster)
    VALUES (@IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- LINEA
CREATE OR ALTER PROCEDURE SP_ActualizarLinea
    @IdLinea INT,
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    UPDATE Linea 
    SET Descripcion = @Descripcion,
        IdMarca = @IdMarca
    WHERE IdLinea = @IdLinea
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
			 PRINT 'Error: No se puede eliminar la linea ID ' + CAST(@IdLinea AS VARCHAR) + ' existen vehiculos asociados'
            RETURN -1
        END

        DELETE FROM Linea WHERE IdLinea = @IdLinea

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la linea con ID ' + CAST(@IdLinea AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Linea eliminada correctamente. ID: ' + CAST(@IdLinea AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar lonea: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarLinea
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    INSERT INTO Linea (Descripcion, IdMarca)
    VALUES (@Descripcion, @IdMarca)
    
    RETURN SCOPE_IDENTITY()
END;

GO
--MARCA
CREATE OR ALTER PROCEDURE SP_ActualizarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE Marca 
    SET Descripcion = @Descripcion
    WHERE IdMarca = @IdMarca
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarMarca
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Linea WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'Error: No se puede eliminar la marca ID ' + CAST(@IdMarca AS VARCHAR) + ' existen lineas asociadas'
            RETURN -1
        END

        DELETE FROM Marca WHERE IdMarca = @IdMarca

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la marca con ID ' + CAST(@IdMarca AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar marca: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--REGISTRO ACCESO
CREATE OR ALTER PROCEDURE SP_ActualizarRegistroAccesos
    @IdRegistroAcceso INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    UPDATE RegistroAccesos 
    SET FechaIngreso = @FechaIngreso,
        FechaSalida = @FechaSalida,
        IdVehiculo = @IdVehiculo,
        IdGarita = @IdGarita,
        IdVisitante = @IdVisitante,
        IdResidente = @IdResidente,
        IdEmpleado = @IdEmpleado
    WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorFechaIngresoRegistroAccesos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE CAST(FechaIngreso AS DATE) = @Fecha
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorVehiculoRegistroAccesos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    DELETE FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarRegistroAccesos
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado)
    VALUES (@FechaIngreso, @FechaSalida, @IdVehiculo, @IdGarita, @IdVisitante, @IdResidente, @IdEmpleado)
    
    RETURN SCOPE_IDENTITY()
END;

GO
--TIPO DOCUMENTO
CREATE OR ALTER PROCEDURE SP_ActualizarTipoDoc
    @IdTipoDocumento INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    UPDATE TipoDocumento 
    SET Nombre = @Nombre
    WHERE IdTipoDocumento = @IdTipoDocumento
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE OR ALTER  PROCEDURE SP_ConsultarPorNombreTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE Nombre = @Nombre
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarTodosTipoDoc
AS
BEGIN
    SELECT * FROM TipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento)
        BEGIN
             PRINT 'Error: No se puede eliminar el tipo de documento ID ' + CAST(@IdTipoDocumento AS VARCHAR) + ' existen visitantes asociados'
            RETURN -1
        END

        DELETE FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el tipo de documento con ID ' + CAST(@IdTipoDocumento AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Tipo de documento eliminado correctamente. ID: ' + CAST(@IdTipoDocumento AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar tipo de documento: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO TipoDocumento (Nombre)
    VALUES (@Nombre)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--VEHICULO
CREATE OR ALTER PROCEDURE SP_ActualizarVehiculo
    @IdVehiculo INT,
    @Año INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    UPDATE Vehiculo 
    SET Año = @Año,
        Placa = @Placa,
        NumeroVivienda = @NumeroVivienda,
        IdCluster = @IdCluster,
        IdLinea = @IdLinea,
        IdMarca = @IdMarca
    WHERE IdVehiculo = @IdVehiculo
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVehiculo
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorPlacaVehiculo
    @Placa VARCHAR(10)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Placa = @Placa
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorViviendaVehiculo
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Vehiculo 
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarVehiculo
    @IdVehiculo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo)
        BEGIN
			PRINT 'Error: No se puede eliminar el vehiculo ID ' + CAST(@IdVehiculo AS VARCHAR) + ' exiten registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Vehiculo WHERE IdVehiculo = @IdVehiculo

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el vehiculo con ID ' + CAST(@IdVehiculo AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Vehiculo eliminado correctamente. ID: ' + CAST(@IdVehiculo AS VARCHAR)
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar vehiculo: ' + ERROR_MESSAGE()
			RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarVehiculo
    @Año INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION 
        -- En esta parte vemos si la placa ya esta registrada o no.
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE Placa = @Placa)
        BEGIN
            RAISERROR('Error: Ya existe un vehiculo con la placa %s', 16, 1, @Placa)
            RETURN -1
        END
        -- Aca es donde contamos cuantos vehiculos tiene registrados cada vivienda
		-- y si se intenta registrar mas de 4 lanzara el error
        DECLARE @CantidadVehiculos INT
        SELECT @CantidadVehiculos = COUNT(*) 
        FROM Vehiculo 
        WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
        IF @CantidadVehiculos >= 4
        BEGIN
            RAISERROR('Error: La vivienda %d del cluster %d ya tiene %d vehiculos (maximo 4 permitidos)', 16, 1, @NumeroVivienda, @IdCluster, @CantidadVehiculos)
            RETURN -2
        END
        -- Aca vemos si la vivienda existe
        IF NOT EXISTS (SELECT 1 FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster)
        BEGIN
            RAISERROR('Error: La vivienda %d en el cluster %d no existe', 16, 1, @NumeroVivienda, @IdCluster)
            RETURN -3
        END       
        -- Aca vemos si la linea y la marca existen, y que la linea pertenezca a la marca con la que se relaciono
        IF NOT EXISTS (SELECT 1 FROM Linea WHERE IdLinea = @IdLinea AND IdMarca = @IdMarca)
        BEGIN
            RAISERROR('Error: La linea %d no existe o no corresponde a la marca %d', 16, 1, @IdLinea, @IdMarca)
            RETURN -4
        END
		-- Aca ya terminaron las verificaciones y si el registro cumple se va a registrar
        INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
        VALUES (@Año, @Placa, @NumeroVivienda, @IdCluster, @IdLinea, @IdMarca)  
        COMMIT TRANSACTION
        DECLARE @NuevoId INT = SCOPE_IDENTITY()
        PRINT 'Vehiculo insertado correctamente con ID: ' + CAST(@NuevoId AS VARCHAR(10))
        RETURN @NuevoId
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'Error: ' + @ErrorMessage
        RETURN -1
    END CATCH
END;

GO

--VISITANTE
CREATE OR ALTER PROCEDURE SP_ActualizarVisitante
    @IdVisitante INT,
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    UPDATE Visitante 
    SET NombreCompleto = @NombreCompleto,
        NumeroDocumento = @NumeroDocumento,
        Telefono = @Telefono,
        MotivoVisita = @MotivoVisita,
        IdTipoDocumento = @IdTipoDocumento
    WHERE IdVisitante = @IdVisitante
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(20)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVisitante
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdVisitante = @IdVisitante
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorTipoDocumentoVisitante
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarVisitante
    @IdVisitante INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'Error: No se puede eliminar el visitante ID ' + CAST(@IdVisitante AS VARCHAR) + ' - existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Visitante WHERE IdVisitante = @IdVisitante

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el visitante con ID ' + CAST(@IdVisitante AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Visitante eliminado correctamente. ID: ' + CAST(@IdVisitante AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar visitante: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarVisitante
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    VALUES (@NombreCompleto, @NumeroDocumento, @Telefono, @MotivoVisita, @IdTipoDocumento)
    
    RETURN SCOPE_IDENTITY()
END;

GO


GO
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.Descripcion = @Descripcion
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorHoraInicioYHoraFin
@HoraInicio DATETIME,
@HoraFin DATETIME
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.HoraInicio = @HoraInicio AND t.HoraFin = @HoraFin
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarTurno
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('No existe este turno',16,1)
RETURN
END 

IF EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdTurno = @IdTurno)
BEGIN 
RAISERROR('Este turno tiene empleados asignados',16,1)
RETURN
END

DELETE FROM Turno
WHERE IdTurno = @IdTurno
END

GO
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

GO
CREATE OR ALTER PROCEDURE SP_ObtenerTurnoPorId
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Turno WHERE IdTurno = @IdTurno)
BEGIN
RAISERROR('No existe este turno',16,1)
RETURN
END

SELECT IdTurno, Descripcion, HoraInicio, HoraFin 
FROM Turno
WHERE IdTurno = @IdTurno;
END 

GO
CREATE OR ALTER PROCEDURE SP_ActualizarPersonaNoGrata
@IdPeronaNoGrata INT,
@FechaInicio DATE = NULL,
@FechaFin DATE = NULL,
@Motivo VARCHAR(100) = NULL
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPeronaNoGrata)
BEGIN
RAISERROR('Esta persona no existe en la lista de no gratos',16,1)
RETURN
END

UPDATE PersonaNoGrata
SET FechaInicio = @FechaInicio,
FechaFin = @FechaFin,
Motivo = @Motivo
WHERE idPersonaNoGrata = @IdPeronaNoGrata
PRINT 'Se actualizo a la persona no grata'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPeronaNoGrataPorId
@IdPersonaNoGrata INT 
AS
BEGIN
SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaFin
@FechaFin DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaFin IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.FechaFin = @FechaFin
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarPersonaNoGrataPorFechaInicio
@IdPersonaNoGrata INT,
@FechaInicio DATE
AS
BEGIN

SET NOCOUNT ON
IF @FechaInicio IS NULL
BEGIN
RAISERROR('Debe de proporcionar una fecha valida',16,1)
RETURN
END

SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata AND  pn.FechaInicio = @FechaInicio
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarPersonaNoGrata
@IdPersonaNoGrata INT
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS(SELECT 1 FROM PersonaNoGrata WHERE idPersonaNoGrata = @IdPersonaNograta)
BEGIN
RAISERROR('Esta persona no se encuentra en el registro de no gratos',16,1)
RETURN
END

DELETE FROM PersonaNoGrata 
WHERE IdPersonaNoGrata = @IdPersonaNoGrata 
PRINT 'Persona eliminada correctamente de no gratos'
END

GO
CREATE OR ALTER PROCEDURE SP_InsertarPersonaNoGrata
@FechaInicio DATE,
@FechFin DATE = NULL,
@Motivo VARCHAR(50),
@IdPersona INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
BEGIN 
RAISERROR('La persona ingresada no existe',16,1)
RETURN
END

IF EXISTS(SELECT 1 FROM PersonaNoGrata WHERE IdPersona = @IdPersona AND (FechaFin IS NULL OR FechaFin >= CAST(GETDATE() AS DATE)))
BEGIN 
RAISERROR('La persona que intentas ingresar ya existe en esta lista y aun no puede ingresar de nuevo hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO PersonaNoGrata(FechaInicio,FechaFin, Motivo, IdPersona)
VALUES(@FechaInicio, @FechFin, @Motivo, @IdPersona)
PRINT 'Persona ingresada correctamente a la lista de no gratos'
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarVehiculoProhibido
@IdVehiculoProhibido INT,
@Fecha DATE,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN
RAISERROR('El vehiculo no existe en la lista de prohibidos',16,1)
RETURN
END

UPDATE VehiculoProhibido
SET Fecha = @Fecha,
Motivo = @Motivo,
IdVehiculo = @IdVehiculo
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'Vehiculo Prohibido actualizado exitosamente'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorFecha
@Fecha DATE
AS
BEGIN
SELECT vp.IdVehiculoProhibido, vp.Fecha, vp.Motivo, v.IdVehiculo, v.Placa, m.Descripcion AS Marca FROM VehiculoProhibido AS vp
INNER JOIN Vehiculo v ON vp.IdVehiculo = v.IdVehiculo
INNER JOIN Marca m ON v.IdMarca = M.IdMarca
WHERE vp.Fecha = @Fecha
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorId
@IdVehiculoProhibido INT
AS
BEGIN
SELECT * FROM VehiculoProhibido 
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarVehiculoProhibido
@IdVehiculoProhibido INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculoProhibido = @IdVehiculoProhibido)
BEGIN 
RAISERROR('El vehiculo dado no se encuentra en la lista de prohibidos',16,1)
RETURN
END

DELETE FROM VehiculoProhibido
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
PRINT 'El vehiculo fue eliminado de la lista de prohibidos'
END

GO
CREATE OR ALTER PROCEDURE SP_InsertarVehiculoProhibido
@Fecha DATE = NULL,
@Motivo VARCHAR(50),
@IdVehiculo INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Vehiculo WHERE IdVehiculo = @IdVehiculo)
BEGIN 
RAISERROR('El vehicuilo que intenta ingresar en la lista de prohibidos no exsite',16,1)
RETURN 
END

IF EXISTS(SELECT 1 FROM VehiculoProhibido WHERE IdVehiculo = @IdVehiculo AND (Fecha IS NULL OR FECHA >= CAST(GETDATE() AS DATE)))
BEGIN
RAISERROR('El vehiculo ya se encuentra prohibido y no puede ser prohibido de nuevo  hasta que cumpla su sancion',16,1)
RETURN
END

INSERT INTO VehiculoProhibido(Fecha, Motivo, IdVehiculo)
VALUES(@Fecha, @Motivo, @IdVehiculo)
PRINT 'Vehiculo ingresado correctamente en la lista de vehiculos prohibidos'
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorNombre
@PrimerNombre VARCHAR(50),
@PrimerApellido VARCHAR(50)
AS
BEGIN
SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto  FROM Persona AS p
INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
WHERE p.PrimerNombre = @PrimerNombre AND p.PrimerApellido = @PrimerApellido
END

GO
CREATE OR ALTER PROCEDURE SP_ObtenerEmpleadosPorPuesto
@IdPuestoEmpleado INT
AS
BEGIN
   SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreEmpleado, pe.Nombre AS Puesto FROM Persona AS p
   INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
   INNER JOIN PuestoEmpleado pe ON e.IdPuestoEmpleado = pe.IdPuestoEmpleado
   WHERE e.IdPuestoEmpleado = @IdPuestoEmpleado
END

GO
CREATE OR ALTER PROCEDURE SP_ActualizarEmpleados
@IdEmpleado INT,
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS 
BEGIN

SET NOCOUNT ON
BEGIN TRY
IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN
RAISERROR('Este empleado no existe',16,1)
RETURN 
END

UPDATE Empleado
SET FechaAlta = @FechaAlta,
FechaBaja = @FechaBaja,
Estado = @Estado,
IdPersona = @IdPersona,
IdPuestoEmpleado = @IdPuestoEmpleado
WHERE IdEmpleado = @IdEmpleado
END TRY
BEGIN CATCH
RAISERROR('Error al intentar actulizar al empleado dado por que no existe',16,1)
END CATCH
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarEmpleadoPorId
@IdEmpleado INT
AS
BEGIN
SELECT e.IdEmpleado, e.IdPersona, p.PrimerNombre, p.PrimerApellido
FROM Empleado AS e
INNER JOIN Persona p ON e.IdPersona = p.IdPersona
WHERE e.IdEmpleado = @IdEmpleado;
END

GO
CREATE OR ALTER PROCEDURE SP_EliminarEmpleado 
@IdEmpleado INT
AS
Begin

SET NOCOUNT ON
IF EXISTS (SELECT 1 FROM AsignacionTurno WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No se puede elminar al empleado ya que tiene asigandos turnos',16,1)
RETURN 
END

IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
Begin
RAISERROR('No existe el empleado con el IdEmpleado especificado',16,1)
RETURN
END
	Delete FROM Empleado
	Where IdEmpleado = @IdEmpleado;
End;

GO
CREATE OR ALTER PROCEDURE SP_InsertarEmpleado
@FechaAlta DATE,
@FechaBaja DATE,
@Estado varchar(10),
@IdPersona INT,
@IdPuestoEmpleado INT
AS
BEGIN

 
    IF NOT EXISTS(SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
    BEGIN
        RAISERROR('No existe esta persona en la base de datos', 16,1)
        RETURN 
    END

    IF EXISTS(
    SELECT 1 
    FROM Empleado 
    WHERE IdPersona = @IdPersona AND Estado = 'ACTIVO')
    BEGIN
        RAISERROR('Esta persona ya es un empleado en actividad',16,1)
        RETURN 
    END

    INSERT INTO Empleado (FechaAlta, FechaBaja, Estado, IdPersona, IdPuestoEmpleado)
        VALUES (@FechaAlta, @FechaBaja, @Estado, @IdPersona, @IdPuestoEmpleado);
END

GO
----GARITA
CREATE OR ALTER PROCEDURE SP_ActualizarGarita
    @IdGarita INT,
    @IdCluster INT
AS
BEGIN
    UPDATE Garita 
    SET IdCluster = @IdCluster
    WHERE IdGarita = @IdGarita
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorClusterGarita
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarTodasGarita
AS
BEGIN
    SELECT * FROM Garita
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarGarita
    @IdGarita INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdGarita = @IdGarita)
        BEGIN
           PRINT 'Error: No se puede eliminar la garita ID ' + CAST(@IdGarita AS VARCHAR) + ' existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Garita WHERE IdGarita = @IdGarita

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la garita con ID ' + CAST(@IdGarita AS VARCHAR)
            RETURN 0
        END
        COMMIT TRANSACTION
		PRINT 'Garita eliminada correctamente. ID: ' + CAST(@IdGarita AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar garita: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarGarita
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (IdCluster)
    VALUES (@IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- LINEA
CREATE OR ALTER PROCEDURE SP_ActualizarLinea
    @IdLinea INT,
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    UPDATE Linea 
    SET Descripcion = @Descripcion,
        IdMarca = @IdMarca
    WHERE IdLinea = @IdLinea
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarLinea
    @IdLinea INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE IdLinea = @IdLinea)
        BEGIN
			 PRINT 'Error: No se puede eliminar la linea ID ' + CAST(@IdLinea AS VARCHAR) + ' existen vehiculos asociados'
            RETURN -1
        END

        DELETE FROM Linea WHERE IdLinea = @IdLinea

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la linea con ID ' + CAST(@IdLinea AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Linea eliminada correctamente. ID: ' + CAST(@IdLinea AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar lonea: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarLinea
    @Descripcion VARCHAR(50),
    @IdMarca INT
AS
BEGIN
    INSERT INTO Linea (Descripcion, IdMarca)
    VALUES (@Descripcion, @IdMarca)
    
    RETURN SCOPE_IDENTITY()
END;

GO
--MARCA
CREATE OR ALTER PROCEDURE SP_ActualizarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(50)
AS
BEGIN
    UPDATE Marca 
    SET Descripcion = @Descripcion
    WHERE IdMarca = @IdMarca
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarMarca
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Linea WHERE IdMarca = @IdMarca)
        BEGIN
            PRINT 'Error: No se puede eliminar la marca ID ' + CAST(@IdMarca AS VARCHAR) + ' existen lineas asociadas'
            RETURN -1
        END

        DELETE FROM Marca WHERE IdMarca = @IdMarca

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro la marca con ID ' + CAST(@IdMarca AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar marca: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--REGISTRO ACCESO
CREATE OR ALTER PROCEDURE SP_ActualizarRegistroAccesos
    @IdRegistroAcceso INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    UPDATE RegistroAccesos 
    SET FechaIngreso = @FechaIngreso,
        FechaSalida = @FechaSalida,
        IdVehiculo = @IdVehiculo,
        IdGarita = @IdGarita,
        IdVisitante = @IdVisitante,
        IdResidente = @IdResidente,
        IdEmpleado = @IdEmpleado
    WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorFechaIngresoRegistroAccesos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE CAST(FechaIngreso AS DATE) = @Fecha
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorVehiculoRegistroAccesos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    DELETE FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarRegistroAccesos
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME = NULL,
    @IdVehiculo INT = NULL,
    @IdGarita INT,
    @IdVisitante INT = NULL,
    @IdResidente INT = NULL,
    @IdEmpleado INT
AS
BEGIN
    INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado)
    VALUES (@FechaIngreso, @FechaSalida, @IdVehiculo, @IdGarita, @IdVisitante, @IdResidente, @IdEmpleado)
    
    RETURN SCOPE_IDENTITY()
END;

GO
--TIPO DOCUMENTO
CREATE OR ALTER PROCEDURE SP_ActualizarTipoDoc
    @IdTipoDocumento INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    UPDATE TipoDocumento 
    SET Nombre = @Nombre
    WHERE IdTipoDocumento = @IdTipoDocumento
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE  OR ALTER PROCEDURE SP_ConsultarPorNombreTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE Nombre = @Nombre
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarTodosTipoDoc
AS
BEGIN
    SELECT * FROM TipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento)
        BEGIN
             PRINT 'Error: No se puede eliminar el tipo de documento ID ' + CAST(@IdTipoDocumento AS VARCHAR) + ' existen visitantes asociados'
            RETURN -1
        END

        DELETE FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el tipo de documento con ID ' + CAST(@IdTipoDocumento AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Tipo de documento eliminado correctamente. ID: ' + CAST(@IdTipoDocumento AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar tipo de documento: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO TipoDocumento (Nombre)
    VALUES (@Nombre)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--VEHICULO
CREATE OR ALTER PROCEDURE SP_ActualizarVehiculo
    @IdVehiculo INT,
    @Año INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    UPDATE Vehiculo 
    SET Año = @Año,
        Placa = @Placa,
        NumeroVivienda = @NumeroVivienda,
        IdCluster = @IdCluster,
        IdLinea = @IdLinea,
        IdMarca = @IdMarca
    WHERE IdVehiculo = @IdVehiculo
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVehiculo
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorPlacaVehiculo
    @Placa VARCHAR(10)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Placa = @Placa
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorViviendaVehiculo
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Vehiculo 
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarVehiculo
    @IdVehiculo INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo)
        BEGIN
			PRINT 'Error: No se puede eliminar el vehiculo ID ' + CAST(@IdVehiculo AS VARCHAR) + ' exiten registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Vehiculo WHERE IdVehiculo = @IdVehiculo

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el vehiculo con ID ' + CAST(@IdVehiculo AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Vehiculo eliminado correctamente. ID: ' + CAST(@IdVehiculo AS VARCHAR)
        RETURN 1
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
			PRINT 'Error al eliminar vehiculo: ' + ERROR_MESSAGE()
			RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarVehiculo
    @Año INT,
    @Placa VARCHAR(10),
    @NumeroVivienda INT,
    @IdCluster INT,
    @IdLinea INT,
    @IdMarca INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION 
        -- En esta parte vemos si la placa ya esta registrada o no.
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE Placa = @Placa)
        BEGIN
            RAISERROR('Error: Ya existe un vehiculo con la placa %s', 16, 1, @Placa)
            RETURN -1
        END
        -- Aca es donde contamos cuantos vehiculos tiene registrados cada vivienda
		-- y si se intenta registrar mas de 4 lanzara el error
        DECLARE @CantidadVehiculos INT
        SELECT @CantidadVehiculos = COUNT(*) 
        FROM Vehiculo 
        WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
        IF @CantidadVehiculos >= 4
        BEGIN
            RAISERROR('Error: La vivienda %d del cluster %d ya tiene %d vehiculos (maximo 4 permitidos)', 16, 1, @NumeroVivienda, @IdCluster, @CantidadVehiculos)
            RETURN -2
        END
        -- Aca vemos si la vivienda existe
        IF NOT EXISTS (SELECT 1 FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster)
        BEGIN
            RAISERROR('Error: La vivienda %d en el cluster %d no existe', 16, 1, @NumeroVivienda, @IdCluster)
            RETURN -3
        END       
        -- Aca vemos si la linea y la marca existen, y que la linea pertenezca a la marca con la que se relaciono
        IF NOT EXISTS (SELECT 1 FROM Linea WHERE IdLinea = @IdLinea AND IdMarca = @IdMarca)
        BEGIN
            RAISERROR('Error: La linea %d no existe o no corresponde a la marca %d', 16, 1, @IdLinea, @IdMarca)
            RETURN -4
        END
		-- Aca ya terminaron las verificaciones y si el registro cumple se va a registrar
        INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
        VALUES (@Año, @Placa, @NumeroVivienda, @IdCluster, @IdLinea, @IdMarca)  
        COMMIT TRANSACTION
        DECLARE @NuevoId INT = SCOPE_IDENTITY()
        PRINT 'Vehiculo insertado correctamente con ID: ' + CAST(@NuevoId AS VARCHAR(10))
        RETURN @NuevoId
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'Error: ' + @ErrorMessage
        RETURN -1
    END CATCH
END;

GO

--VISITANTE
CREATE OR ALTER PROCEDURE SP_ActualizarVisitante
    @IdVisitante INT,
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    UPDATE Visitante 
    SET NombreCompleto = @NombreCompleto,
        NumeroDocumento = @NumeroDocumento,
        Telefono = @Telefono,
        MotivoVisita = @MotivoVisita,
        IdTipoDocumento = @IdTipoDocumento
    WHERE IdVisitante = @IdVisitante
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(20)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVisitante
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdVisitante = @IdVisitante
END;

GO

CREATE OR ALTER PROCEDURE SP_ConsultarPorTipoDocumentoVisitante
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE SP_EliminarVisitante
    @IdVisitante INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT 1 FROM RegistroAccesos WHERE IdVisitante = @IdVisitante)
        BEGIN
            PRINT 'Error: No se puede eliminar el visitante ID ' + CAST(@IdVisitante AS VARCHAR) + ' - existen registros de acceso asociados'
            RETURN -1
        END

        DELETE FROM Visitante WHERE IdVisitante = @IdVisitante

		IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'Advertencia: No se encontro el visitante con ID ' + CAST(@IdVisitante AS VARCHAR)
            RETURN 0
        END

        COMMIT TRANSACTION
		PRINT 'Visitante eliminado correctamente. ID: ' + CAST(@IdVisitante AS VARCHAR)
        RETURN 1
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        PRINT 'Error al eliminar visitante: ' + ERROR_MESSAGE()
        RETURN -1
    END CATCH
END;

GO

CREATE OR ALTER PROCEDURE SP_InsertarVisitante
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    VALUES (@NombreCompleto, @NumeroDocumento, @Telefono, @MotivoVisita, @IdTipoDocumento)
    
    RETURN SCOPE_IDENTITY()
END;

GO