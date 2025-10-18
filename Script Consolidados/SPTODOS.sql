-- #############################################
-- #       CRUD COMPLETO POR TABLA             #
-- #############################################

-- #############################################
-- 1. TABLA: Residencial
-- #############################################

-- INSERTAR
CREATE OR ALTER PROCEDURE SP_InsertarResidencial
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Residencial (Nombre)
    VALUES (@Nombre);
    SELECT SCOPE_IDENTITY() AS IdResidencial;
END;
GO

-- BUSCAR TODOS (SELECT ALL)
CREATE OR ALTER PROCEDURE SP_SelectAllResidenciales
AS
BEGIN
    SELECT *
    FROM Residencial;
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarResidencialPK
@IdResidencial INT
AS
BEGIN
    SELECT
        IdResidencial,
        Nombre
    FROM Residencial
    WHERE IdResidencial = @IdResidencial;
END;
GO

-- BUSCAR POR NOMBRE (COINCIDENCIA PARCIAL)
CREATE OR ALTER PROCEDURE SP_BuscarResidencialCoicidencianombre
    @NombreParcial VARCHAR(50)
AS
BEGIN
    SELECT
        IdResidencial,
        Nombre
    FROM Residencial
    WHERE Nombre LIKE '%' + @NombreParcial + '%';
END;
GO

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE SP_ActualizarResidencial
@IdResidencial INT,
@Nombre VARCHAR(50)
AS
BEGIN
    UPDATE Residencial
    SET Nombre = @Nombre
    WHERE IdResidencial = @IdResidencial;
END;
GO

-- ELIMINAR
CREATE OR ALTER PROCEDURE SP_EliminarResidencial
    @IdResidencial INT
AS
BEGIN
    DELETE FROM Residencial
    WHERE IdResidencial = @IdResidencial;
END;
GO


-- #############################################
-- 2. TABLA: Cluster
-- #############################################

-- INSERTAR
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

-- BUSCAR TODOS (SELECT ALL con JOIN)
CREATE OR ALTER PROCEDURE SP_SelectAllClusters
AS
BEGIN
    SELECT 
        C.IdCluster, 
        C.Descripcion AS NombreCluster, 
        R.Nombre AS Residencial
    FROM Cluster AS C
    INNER JOIN Residencial AS R 
        ON C.IdResidencial = R.IdResidencial;
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarCluster
@IdCluster INT
AS
BEGIN
    SELECT *
    FROM Cluster
    WHERE IdCluster = @IdCluster
END;
GO

-- BUSCAR POR DESCRIPCION
CREATE OR ALTER PROCEDURE SP_BuscarClusterPorDescripcion
@NombreCluster VARCHAR(30)
AS
BEGIN 
    SELECT IdCluster, Descripcion AS 'Nombre Cluster'
    FROM Cluster
    WHERE Descripcion =  @NombreCluster
END;
GO

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE PSActualizarCluster
@IdCluster INT,
@Descripcion VARCHAR (30)
AS
BEGIN
    UPDATE Cluster
    SET Descripcion=@Descripcion 
    WHERE IdCluster=@IdCluster
    SELECT @IdCluster AS IdCluster
END;
GO

-- ELIMINAR
CREATE OR ALTER PROCEDURE SP_EliminarCluster
@IdCluster INT
AS
BEGIN 
    DELETE Cluster 
    Where IdCluster = @IdCluster
    Select @IdCluster
END;
GO


-- #############################################
-- 3. TABLA: Persona
-- #############################################

-- INSERTAR
CREATE OR ALTER PROCEDURE SP__InsertarPersona
@Cui VARCHAR(30) ,
@PrimerNombre VARCHAR(30) ,
@SegundoNombre VARCHAR(30) ,
@PrimerApellido VARCHAR(30) ,
@SegundoApellido VARCHAR(10) ,
@Telefono VARCHAR(30),
@Genero CHAR(1),
@FechaNacimiento DATE,
@EstadoCivil VARCHAR(15)
AS
BEGIN
    INSERT INTO Persona(Cui,PrimerNombre,SegundoNombre,PrimerApellido,SegundoApellido,Telefono,Genero,FechaNacimiento, EstadoCivil)
    VALUES(@Cui,@PrimerNombre,@SegundoNombre ,@PrimerApellido,@SegundoApellido ,@Telefono,@Genero,@FechaNacimiento, @EstadoCivil )
    SELECT SCOPE_IDENTITY() AS IdPersona
END;
GO

-- BUSCAR TODOS (SELECT ALL)
CREATE OR ALTER PROCEDURE SP_SelectAllPersonas
AS
BEGIN
    SELECT *
    FROM Persona;
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarPersona
@IdPersona INT
AS
BEGIN
    SELECT *
    FROM Persona
    WHERE IdPersona= @IdPersona
END;
GO

-- BUSCAR POR CUI
CREATE OR ALTER PROCEDURE SP_BuscarPersonaPorCui
@NumeroDeIdentificacion VARCHAR(30)
AS
BEGIN
    SELECT CONCAT(P.PrimerNombre, ' ', P.PrimerApellido) AS Nombre, P.Cui As 'Numero de Identificacion'
    FROM PERSONA AS P
    WHERE Cui = @NumeroDeIdentificacion
END;
GO

-- BUSCAR POR NOMBRE COMPLETO
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

-- ACTUALIZAR
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

-- ELIMINAR
CREATE OR ALTER PROCEDURE SP_EliminarPersona
@IdPersona INT
AS
BEGIN
    DELETE Persona 
    WHERE IdPersona = @IdPersona
    SELECT @IdPersona 
END;
GO


-- #############################################
-- 4. TABLA: Propietario
-- #############################################

-- INSERTAR
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

-- BUSCAR TODOS (SELECT ALL con JOIN)
CREATE OR ALTER PROCEDURE SP_SelectAllPropietarios
AS
BEGIN
    SELECT 
        P.IdPropietario, 
        P.Estado,
        PR.IdPersona,
        CONCAT(PR.PrimerNombre, ' ', COALESCE(PR.SegundoNombre, ''), ' ', PR.PrimerApellido, ' ', COALESCE(PR.SegundoApellido, '')) AS NombreCompleto
    FROM Propietario AS P
    INNER JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona;
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarPropietario
@IdPropiestario INT
AS
BEGIN
    -- Une Propietario con Persona para mostrar el nombre completo
    SELECT P.IdPropietario,PS.IdPersona,CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario'
    FROM Propietario AS P 
    INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
    WHERE IdPropietario = @IdPropiestario
END;
GO

-- BUSCAR POR CLUSTER (con JOINs a Vivienda, TipoVivienda y Persona)
CREATE OR ALTER PROCEDURE SP_buscarPropietarioPorCluster
@IdCluster INT
AS
BEGIN
    SELECT P.IdPropietario,CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario',C.IdCluster, V.NumeroVivienda, TV.Descripcion AS 'Tipo de Vivienda'
    FROM Propietario AS P
    INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
    INNER JOIN Vivienda AS V ON P.IdPropietario = V.IdPropietario
    INNER JOIN TipoVivienda AS TV ON V.IdTipoVivienda = TV.IdTipoVivienda
    INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
    WHERE C.IdCluster = @IdCluster
END;
GO

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE SP_ActualizarPropietario
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

-- ELIMINAR
ALTER   PROCEDURE [dbo].[PSEliminarPropietario]
@IdPropietario INT
AS 
BEGIN
    DELETE Propietario
    WHERE IdPropietario = @IdPropietario
    SELECT @IdPropietario
END;
GO


-- #############################################
-- 5. TABLA: TipoVivienda
-- #############################################

-- INSERTAR
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

-- BUSCAR TODOS (SELECT ALL)
CREATE OR ALTER PROCEDURE SP_SelectAllTiposVivienda
AS
BEGIN
    SELECT *
    FROM TipoVivienda;
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN
    SELECT *
    FROM TipoVivienda
    WHERE IdTipoVivienda= @IdTipoVivienda
END;
GO

-- BUSCAR POR NUMERO DE HABITACIONES (con JOIN a Vivienda)
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

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE SP_ActualizarTipoVivienda
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

-- ELIMINAR
CREATE OR ALTER PROCEDURE SP_EliminarTipoVivienda
@IdTipoVivienda INT
AS
BEGIN 
    DELETE TipoVivienda
    WHERE IdTipoVivienda = @IdTipoVivienda
    SELECT @IdTipoVivienda
END;
GO


-- #############################################
-- 6. TABLA: Vivienda
-- #############################################

-- INSERTAR
Create OR ALTER Procedure SP_CrearVivienda
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

-- BUSCAR TODOS (SELECT ALL con JOINs)
CREATE OR ALTER PROCEDURE SP_SelectAllViviendas
AS
BEGIN
    SELECT 
        C.IdCluster,
        V.NumeroVivienda,
        C.Descripcion AS Cluster,
        TV.Descripcion AS TipoVivienda,
        CONCAT(PR.PrimerNombre, ' ', COALESCE(PR.SegundoNombre, ''), ' ', PR.PrimerApellido, ' ', COALESCE(PR.SegundoApellido, '')) AS Propietario
    FROM Vivienda AS V
    INNER JOIN Cluster AS C 
        ON V.IdCluster = C.IdCluster
    INNER JOIN TipoVivienda AS TV 
        ON V.IdTipoVivienda = TV.IdTipoVivienda
    INNER JOIN Propietario AS P 
        ON V.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona;
END;
GO

-- BUSCAR POR CLAVE COMPUESTA (PK)
Create OR Alter Procedure BuscarVivienda
@NumeroVivienda INT,
@IdCluster INT
AS
Begin 
    Select * from Vivienda
    Where  NumeroVivienda = @NumeroVivienda  and IdCluster = @IdCluster;
End;
GO

-- BUSCAR POR PROPIETARIO (con JOINs a TipoVivienda y Persona)
Create Or Alter Procedure buscarViviendaPorPropietario
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

-- ACTUALIZAR
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

-- ELIMINAR (con validación de Residentes)
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


-- #############################################
-- 7. TABLA: Residente
-- #############################################

-- INSERTAR
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

-- BUSCAR TODOS (SELECT ALL con JOINs)
CREATE OR ALTER PROCEDURE SP_SelectAllResidentes
AS
BEGIN
    SELECT 
        R.IdResidente,
        R.NumeroVivienda,
        R.Estado,
        R.EsInquilino,
        C.Descripcion AS Cluster,
        CONCAT(P.PrimerNombre, ' ', COALESCE(P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE(P.SegundoApellido, '')) AS NombreCompleto
    FROM Residente AS R
    INNER JOIN Persona AS P 
        ON R.IdPersona = P.IdPersona
    INNER JOIN Cluster AS C 
        ON R.IdCluster = C.IdCluster;
END;
GO

CREATE OR ALTER   PROCEDURE [dbo].[SP_ObtenerResidentes]
AS
BEGIN
SELECT r.IdResidente,
        r.IdPersona,
        r.NumeroVivienda,
        r.IdCluster,
        r.EsInquilino,
        r.Estado,
        p.PrimerNombre,
        p.SegundoNombre,
        p.PrimerApellido,
        p.SegundoApellido,
        c.Descripcion AS ClusterDescripcion
    FROM Residente r
    INNER JOIN Persona p ON r.IdPersona = p.IdPersona
    INNER JOIN Cluster c ON r.IdCluster = c.IdCluster
END;
GO

-- BUSCAR POR ID (PK)
CREATE OR ALTER PROCEDURE SP_BuscarResidentePK
@IdResidente INT
AS
BEGIN
    SELECT *
    FROM Residente
    WHERE IdResidente =@IdResidente
END;
GO

-- BUSCAR POR NUMERO DE VIVIENDA (con JOIN a Persona)
CREATE OR ALTER PROCEDURE SP_BuscarResidentePorNumVivienda
@NumeroVivienda INT
AS
BEGIN
      SELECT CONCAT(P.PrimerNombre, ' ',COALESCE (P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE (P.SegundoApellido, ''))AS 'Residente',R.IdResidente, R.NumeroVivienda, R.IdCluster
      FROM Residente AS R
      INNER JOIN Persona AS P ON R.IdPersona = P.IdPersona  
      WHERE NumeroVivienda = @NumeroVivienda
END;
GO

-- ACTUALIZAR
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

-- ELIMINAR
CREATE OR ALTER PROCEDURE PSEliminarResidente
@IdResidente INT
AS
BEGIN
    DELETE Residente
    WHERE IdResidente = @IdResidente
    SELECT @IdResidente
END;
GO


-- #############################################
-- 8. TABLA: PuestoJuntaDirectiva
-- #############################################

-- INSERTAR
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

-- BUSCAR TODOS (SELECT ALL)
CREATE OR ALTER PROCEDURE SP_SelectAllPuestosJD
AS
BEGIN
    SELECT *
    FROM PuestoJuntaDirectiva;
END;
GO

-- BUSCAR POR ID (PK)
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

-- BUSCAR POR NOMBRE (COINCIDENCIA PARCIAL)
CREATE OR ALTER PROCEDURE SP_BuscarPuestoJDPorNombre
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

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE SP_ActualizarPuestoJD
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

-- ELIMINAR (con validación de MiembroJuntaDirectiva)
CREATE OR ALTER PROCEDURE SP_EliminarPuestoJD
    @IdPuestoJuntaDirectiva INT
AS
BEGIN
    IF EXISTS (SELECT * FROM MiembroJuntaDirectiva 
    WHERE IdPuesto = @IdPuestoJuntaDirectiva)
    BEGIN
        RAISERROR('No se puede eliminar el Puesto porque esta siendo usado en MiembroJuntaDirectiva.',16,1);
        RETURN 0;
    END
    
    DELETE FROM PuestoJuntaDirectiva
    WHERE IdPuesto = @IdPuestoJuntaDirectiva;
END;
GO


-- #############################################
-- 9. TABLA: JuntaDirectiva
-- #############################################

-- INSERTAR
CREATE OR ALTER PROCEDURE SP_InsertarJuntaDirectiva
@IdCluster INT
AS
BEGIN
    INSERT INTO JuntaDirectiva (IdCluster)
    VALUES (@IdCluster);
    SELECT SCOPE_IDENTITY() AS IdJuntaDirectiva;
END;
GO

-- BUSCAR TODOS (SELECT ALL con JOIN)
CREATE OR ALTER PROCEDURE SP_SelectAllJuntasDirectivas
AS
BEGIN
    SELECT 
	    C.IdCluster,
        JD.IdJuntaDirectiva,
        C.Descripcion AS Cluster
    FROM JuntaDirectiva AS JD
    INNER JOIN Cluster AS C 
        ON JD.IdCluster = C.IdCluster;
END;
GO

-- BUSCAR POR ID (PK)
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

-- BUSCAR POR CLUSTER
CREATE OR ALTER PROCEDURE SP_BuscarJuntaDirectivaPorCluster
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

-- ACTUALIZAR
CREATE OR ALTER PROCEDURE SP_ActualizarJuntaDirectiva
@IdJuntaDirectiva INT,
@IdCluster INT
AS
BEGIN
    UPDATE JuntaDirectiva
    SET IdCluster = @IdCluster
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva;

    SELECT @IdJuntaDirectiva AS IdJuntaDirectiva
END;
GO

-- ELIMINAR (con validación de MiembroJuntaDirectiva)
CREATE OR ALTER PROCEDURE SP_EliminarJuntaDirectiva
    @IdJuntaDirectiva INT
AS
BEGIN
    IF EXISTS (SELECT * FROM MiembroJuntaDirectiva 
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva)
    BEGIN
        RAISERROR('No se puede eliminar la Junta Directiva porque tiene miembros registrados. Debe eliminar primero los miembros.', 16, 1);
        RETURN 0;
    END;
    
    DELETE JuntaDirectiva
    WHERE IdJuntaDirectiva = @IdJuntaDirectiva 
    
END;
GO


-- #############################################
-- 10. TABLA: MiembroJuntaDirectiva
-- #############################################

-- INSERTAR
CREATE OR ALTER PROCEDURE SP_InsertarMiembroJD
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

CREATE OR ALTER PROCEDURE SP_ActualizarMiembroJD
    @IdMiembro INT,
    @Estado VARCHAR(10),
    @FechaInicio DATE,
    @FechaFin DATE,
    @IdJuntaDirectiva INT,
    @IdPropietario INT,
    @IdPuesto INT
AS
BEGIN
    UPDATE MiembroJuntaDirectiva
    SET
        Estado = @Estado,
        FechaInicio = @FechaInicio,
        FechaFin = @FechaFin,
        IdJuntaDirectiva = @IdJuntaDirectiva,
        IdPropietario = @IdPropietario,
        idPuesto = @IdPuesto
    WHERE IdMiembro = @IdMiembro;

    SELECT @IdMiembro AS IdMiembro;
END;
GO


-- BUSCAR TODOS (SELECT ALL con JOINs)
CREATE OR ALTER PROCEDURE SP_SelectAllMiembrosJD
AS
BEGIN
    SELECT 
        MJD.IdMiembro,
        C.Descripcion AS Cluster,
        PJD.Nombre AS Puesto,
        CONCAT(PR.PrimerNombre, ' ', COALESCE(PR.SegundoNombre, ''), ' ', PR.PrimerApellido, ' ', COALESCE(PR.SegundoApellido, '')) AS Propietario,
        MJD.Estado,
        MJD.FechaInicio,
        MJD.FechaFin
    FROM MiembroJuntaDirectiva AS MJD
    INNER JOIN JuntaDirectiva AS JD 
        ON MJD.IdJuntaDirectiva = JD.IdJuntaDirectiva
    INNER JOIN Cluster AS C 
        ON JD.IdCluster = C.IdCluster
    INNER JOIN PuestoJuntaDirectiva AS PJD 
        ON MJD.IdPuesto = PJD.IdPuesto
    INNER JOIN Propietario AS P 
        ON MJD.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona;
END;
GO

-- BUSCAR POR ID (PK con JOINs)
CREATE OR ALTER PROCEDURE SP_BuscarMiembroJDPK
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
    WHERE MJD.IdMiembro = @IdMiembro
END;
GO

-- BUSCAR POR JUNTA DIRECTIVA (con JOINs a Propietario, Persona y Puesto)
CREATE OR ALTER PROCEDURE SP_BuscarMiembroSP_orJunta
    @IdJuntaDirectiva INT
AS
BEGIN
    SELECT
        MJD.IdPropietario,
        CONCAT(PS.PrimerNombre, ' ',COALESCE (PS.SegundoNombre, ''), ' ', PS.PrimerApellido, ' ', COALESCE (PS.SegundoApellido, ''))AS 'Propietario',
        PJD.Nombre AS Puesto
    FROM MiembroJuntaDirectiva AS MJD
    INNER JOIN Propietario P ON MJD.IdPropietario = P.IdPropietario
    INNER JOIN Persona AS PS ON P.IdPersona = PS.IdPersona
    INNER JOIN PuestoJuntaDirectiva PJD ON MJD.IdPuesto = PJD.IdPuesto
    WHERE MJD.IdJuntaDirectiva = @IdJuntaDirectiva
END;
GO

-- NO HAY SP_ para actualizar MiembroJuntaDirectiva en el script original, solo INSERT/DELETE.
-- Por lo tanto, no se incluye SP_ActualizarMiembroJD.

-- ELIMINAR (con validación de Estado)
CREATE OR ALTER PROCEDURE SP_EliminarMiembroJD
@IdMiembroJD INT
AS
BEGIN
    IF EXISTS (SELECT * FROM MiembroJuntaDirectiva 
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