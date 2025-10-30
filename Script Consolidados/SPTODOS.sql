-- 1. TABLA: Residencial
go
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


-- 2. TABLA: Cluster

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
@PageIndex INT = 1,
@PageSize INT = 10,
@ResidencialFilter VARCHAR(30)= NULL,
@ClusterFilter VARCHAR(30) = NULL
AS
BEGIN

    DECLARE @offset INT = (@PageIndex -1) * @pageSize;
    SELECT 
        C.IdCluster, 
        C.Descripcion AS NombreCluster, 
        R.Nombre AS Residencial
    FROM Cluster AS C
    INNER JOIN Residencial AS R 
        ON C.IdResidencial = R.IdResidencial
    WHERE
        (@ResidencialFilter IS NULL OR R.Nombre LIKE '%' + @ResidencialFilter + '%')
        AND (@ClusterFilter IS NULL OR C.Descripcion LIKE '%' + @ClusterFilter + '%')
    ORDER BY C.IdCluster
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    From Cluster AS C
    INNER JOIN Residencial AS R
    ON C.IdResidencial = R.IdResidencial
    WHERE
    (@ResidencialFilter IS NULL OR R.Nombre LIKE '%' + @ResidencialFilter + '%')
        AND (@ClusterFilter IS NULL OR C.Descripcion LIKE '%' + @ClusterFilter + '%')

END;

EXEC  SP_SelectAllClusters
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
CREATE OR ALTER PROCEDURE SP_ActualizarCluster
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


-- 3. TABLA: Persona

CREATE OR ALTER PROCEDURE SP_ExistePropietarioPorPersonaId
    @IdPersona INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Propietario WHERE IdPersona = @IdPersona)
    BEGIN
        SELECT 1;
    END
    ELSE
    BEGIN
        SELECT 0;
    END
END;
GO

go
-- INSERTAR
CREATE OR ALTER PROCEDURE SP_InsertarPersona
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
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @CuiFilter VARCHAR(30) = NULL,
    @NombreFilter VARCHAR(30) = NULL
AS
BEGIN
   

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
       P.IdPersona, Cui, PrimerNombre, SegundoNombre, 
        PrimerApellido, SegundoApellido, Telefono, Genero,FechaNacimiento, EstadoCivil, PR.IdPropietario
    FROM Persona P
    LEFT JOIN Propietario AS PR ON P.IdPersona = PR.IdPersona
    WHERE 
        (@CuiFilter IS NULL OR Cui LIKE '%' + @CuiFilter + '%')
        AND (@NombreFilter IS NULL OR 
             PrimerNombre LIKE '%' + @NombreFilter + '%' OR
             PrimerApellido LIKE '%' + @NombreFilter + '%')
    ORDER BY IdPersona
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Devolver total de registros (para el paginador)
    SELECT COUNT(*) AS TotalCount
    FROM Persona
    WHERE 
        (@CuiFilter IS NULL OR Cui LIKE '%' + @CuiFilter + '%')
        AND (@NombreFilter IS NULL OR 
             PrimerNombre LIKE '%' + @NombreFilter + '%' OR
             PrimerApellido LIKE '%' + @NombreFilter + '%');
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
go



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


-- 4. TABLA: Propietario

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
@PageIndex INT =1,
@PageSize INT = 10,
@EstadoFilter VARCHAR(10) = NULL,
@NombreFilter VARCHAR(30) = NULL
AS
BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;
    SELECT 
        P.IdPropietario, 
        P.Estado,
        PR.IdPersona,
        CONCAT(PR.PrimerNombre, ' ', COALESCE(PR.SegundoNombre, ''), ' ', PR.PrimerApellido, ' ', COALESCE(PR.SegundoApellido, '')) AS NombreCompleto
    FROM Propietario AS P
    INNER JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona
    WHERE 
        (@EstadoFilter IS NULL OR P.Estado LIKE '%' + @EstadoFilter + '%' )
        AND (@NombreFilter IS NULL OR PR.PrimerNombre LIKE '%' + @NombreFilter + '%' 
        OR PR.PrimerApellido LIKE '%' + @NombreFilter + '%')
    ORDER BY IdPropietario
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM Propietario AS P
    INNER JOIN Persona AS PR 
    ON P.IdPersona = PR.IdPersona
    WHERE
    (@EstadoFilter IS NULL OR P.Estado LIKE '%' + @EstadoFilter + '%' )
        AND (@NombreFilter IS NULL OR PR.PrimerNombre LIKE '%' + @NombreFilter + '%' 
        OR PR.PrimerApellido LIKE '%' + @NombreFilter + '%');

END;
EXEC SP_SelectAllPropietarios
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
CREATE OR ALTER   PROCEDURE SP_EliminarPropietario
@IdPropietario INT
AS 
BEGIN
    DELETE Propietario
    WHERE IdPropietario = @IdPropietario
    SELECT @IdPropietario
END;
GO

-- 5. TABLA: TipoVivienda

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
@PageIndex INT = 1,
@PageSize INT = 10
AS
BEGIN
    
    Declare @Offset INT = (@PageIndex -1 ) * @PageSize;
    SELECT *
    FROM TipoVivienda
    ORDER BY IdTipoVivienda
    OFFSET @Offset ROWS
    FETCH NEXT  @PageSize ROWS ONLY;

    SELECT  COUNT(*) AS TotalCount
    FROM  TipoVivienda
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


-- 6. TABLA: Vivienda

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
@PageIndex INT = 1,
@PageSize INT =10,
@PropietarioFilter VARCHAR(30) = NULL,
@ClusterFilter VARCHAR(30) = NULL,
@TipoViviendaFilter VARCHAR(30) = NULL
AS
BEGIN

    DECLARE @Offset INT  = (@PageIndex -1) * @PageSize;
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
    LEFT JOIN Propietario AS P 
        ON V.IdPropietario = P.IdPropietario
    Left JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona

    WHERE
        (@PropietarioFilter IS NULL OR 
        PR.PrimerNombre LIKE '%' + @PropietarioFilter +'%' OR
        PR.PrimerApellido LIKE '%'+ @PropietarioFilter + '%')AND
        (@ClusterFilter  IS NULL OR C.Descripcion LIKE '%' + @ClusterFilter)AND
        (@TipoViviendaFilter  IS NULL OR TV.Descripcion LIKE '%' + @TipoViviendaFilter + '%')
        ORDER BY C.IdCluster, V.NumeroVivienda
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;

        SELECT COUNT(*) AS TotalCount
        FROM Vivienda AS V
    INNER JOIN Cluster AS C 
        ON V.IdCluster = C.IdCluster
    INNER JOIN TipoVivienda AS TV 
        ON V.IdTipoVivienda = TV.IdTipoVivienda
    LEFT JOIN Propietario AS P 
        ON V.IdPropietario = P.IdPropietario
    Left JOIN Persona AS PR 
        ON P.IdPersona = PR.IdPersona
        WHERE
        (@PropietarioFilter IS NULL OR 
        PR.PrimerNombre LIKE '%' + @PropietarioFilter +'%' OR
        PR.PrimerApellido LIKE '%'+ @PropietarioFilter + '%')AND
        (@ClusterFilter  IS NULL OR C.Descripcion LIKE '%' + @ClusterFilter)AND
        (@TipoViviendaFilter  IS NULL OR TV.Descripcion LIKE '%' + @TipoViviendaFilter + '%');
        
        

END;
EXEC SP_SelectAllViviendas
@PageSize =1000,
@PageIndex =1
SELECT * FROM Vivienda
GO

-- BUSCAR POR CLAVE COMPUESTA (PK)
Create OR Alter Procedure SP_BuscarVivienda
@NumeroVivienda INT,
@IdCluster INT
AS
Begin 
    Select * from Vivienda
    Where  NumeroVivienda = @NumeroVivienda  and IdCluster = @IdCluster;
End;
GO

-- BUSCAR POR PROPIETARIO (con JOINs a TipoVivienda y Persona)
Create Or Alter Procedure SP_buscarViviendaPorPropietario
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


-- 7. TABLA: Residente

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
@PageIndex INT = 1,
@PageSize INT = 10,
@NombreResidenteFilter VARCHAR (30) = NULL,
@EsInquilinoFilter BIT= 0,
@EstadoFilter VARCHAR(10) = NULL,
@ClusterFilter VARCHAR(30) = NULL,
@NumeroViviendaFilter INT = NULL,
@GeneroFilter CHAR(1)  = NULL
AS
BEGIN
    DECLARE @Offset INT = (@PageIndex -1) * @PageSize;
    SELECT 
        P.IdPersona,
        C.IdCluster,
        R.IdResidente,
        R.NumeroVivienda,
        R.Estado,
        R.EsInquilino,
        C.Descripcion AS ClusterDescripcion,
        CONCAT(P.PrimerNombre, ' ', COALESCE(P.SegundoNombre, ''), ' ', P.PrimerApellido, ' ', COALESCE(P.SegundoApellido, '')) AS NombreCompleto
    FROM Residente AS R
    INNER JOIN Persona AS P 
        ON R.IdPersona = P.IdPersona
    INNER JOIN Cluster AS C 
        ON R.IdCluster = C.IdCluster
    WHERE 
    (@NombreResidenteFilter IS NULL OR
     P.PrimerNombre LIKE '%' + @NombreResidenteFilter + '%' OR
     P.SegundoNombre LIKE '%' + @NombreResidenteFilter + '%')AND
    (@EsInquilinoFilter IS NULL OR
     R.EsInquilino = COALEsce(@EsInquilinoFilter,0))AND
    (@EstadoFilter IS NULL OR
     R.Estado LIKE '%' + @EstadoFilter + '%')AND
    (@ClusterFilter  IS NULL OR 
     C.Descripcion LIKE '%' + @ClusterFilter + '%')AND
    (@NumeroViviendaFilter  IS NULL OR
     R.NumeroVivienda = @NumeroViviendaFilter)AND
     (@GeneroFilter IS NULL OR
     P.Genero LIKE '%' + @GeneroFilter + '%')
     ORDER BY IdResidente
     OFFSET @Offset ROWS
     FETCH NEXT @PageSize ROWS ONLY;

     SELECT COUNT(*) AS TotalCount
     FROM Residente AS R
    INNER JOIN Persona AS P 
        ON R.IdPersona = P.IdPersona
    INNER JOIN Cluster AS C 
        ON R.IdCluster = C.IdCluster
    WHERE 
    (@NombreResidenteFilter IS NULL OR
     P.PrimerNombre LIKE '%' + @NombreResidenteFilter + '%' OR
     P.SegundoNombre LIKE '%' + @NombreResidenteFilter + '%')AND
    (@EsInquilinoFilter IS NULL OR
     R.EsInquilino= Coalesce(@EsInquilinoFilter, 0 ))AND
    (@EstadoFilter IS NULL OR
     R.Estado LIKE '%' + @EstadoFilter + '%')AND
    (@ClusterFilter  IS NULL OR 
     C.Descripcion LIKE '%' + @ClusterFilter + '%')AND
    (@NumeroViviendaFilter  IS NULL OR
     R.NumeroVivienda = @NumeroViviendaFilter )AND
     (@GeneroFilter IS NULL OR
     P.Genero LIKE '%' + @GeneroFilter + '%')
     
    
END;
EXEC SP_SelectAllResidentes


GO

CREATE OR ALTER PROCEDURE SP_ObtenerResidentes
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
CREATE OR ALTER PROCEDURE SP_EliminarResidente
@IdResidente INT
AS
BEGIN
    DELETE Residente
    WHERE IdResidente = @IdResidente
    SELECT @IdResidente
END;
GO


-- 8. TABLA: PuestoJuntaDirectiva

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


-- 9. TABLA: JuntaDirectiva

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


-- 10. TABLA: MiembroJuntaDirectiva


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

GO
-- 11. TABLA: PuestoEmpleado

-- Buscar puesto empleado por descripcion
CREATE OR ALTER PROCEDURE SP_BuscarPuestoEmpleadoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN
   SELECT IdPuestoEmpleado, Nombre, Descripcion
   FROM PuestoEmpleado
   WHERE Descripcion = @Descripcion
END
GO 
CREATE OR ALTER PROCEDURE SP_ListarTodosPuestosEmpleados
AS
BEGIN
    SET NOCOUNT ON;
    SELECT IdPuestoEmpleado, Nombre, Descripcion
    FROM PuestoEmpleado
    ORDER BY Nombre;
END
GO
GO

-- Actualizar puesto empleado
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

-- Buscar PuestoEmpleado por nombre
CREATE OR ALTER PROCEDURE SP_BuscarPuestoTrabajoPorNombre
@Nombre VARCHAR(50)
AS
BEGIN
SELECT * 
FROM PuestoEmpleado
WHERE Nombre = @Nombre
END

GO

-- Crear puesto empleado
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

-- Eliminar puesto empleado
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

--Obtener puesto empleado por ID
CREATE OR ALTER PROCEDURE SP_ObtenerPuestoEmpleadoPorId
@IdPuestoEmpleado INT
AS
BEGIN
SELECT * FROM PuestoEmpleado AS pe
WHERE IdPuestoEmpleado = @IdPuestoEmpleado
END

GO

CREATE OR ALTER PROCEDURE SP_SelectAllPuestoEmpleado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @NombreFilter VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        IdPuestoEmpleado,
        Nombre,
        Descripcion
    FROM PuestoEmpleado
    WHERE
        (@NombreFilter IS NULL OR Nombre LIKE '%' + @NombreFilter + '%')
    ORDER BY IdPuestoEmpleado
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM PuestoEmpleado
    WHERE
        (@NombreFilter IS NULL OR Nombre LIKE '%' + @NombreFilter + '%');
END;
GO

-- 12. TABLA: Turno

-- Actualizar Turno
CREATE OR ALTER PROCEDURE SP_ActualizarTurno
@IdTurno INT,
@Descripcion VARCHAR(50),
@HoraInicio TIME,
@HoraFin TIME
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

-- Buscar Turno por descripcion
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorDescripcion
@Descripcion VARCHAR(50)
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.Descripcion = @Descripcion
END

GO

-- Buscar turno por hora inicio y descripcion
CREATE OR ALTER PROCEDURE SP_BuscarTurnoPorHoraInicioYHoraFin
@HoraInicio DATETIME,
@HoraFin DATETIME
AS
BEGIN 
SELECT t.IdTurno, t.Descripcion, t.HoraInicio, t.HoraFin FROM Turno AS t
WHERE t.HoraInicio = @HoraInicio AND t.HoraFin = @HoraFin
END

GO

-- Eliminar turno
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
-- Crear Turno
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

-- Obtner Turno por Id
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

-- 13. TABLA: AsignacionTurno
GO
-- Actualizacion de asugancion turno
CREATE OR ALTER PROCEDURE SP_ActualizarAsignacionTurno
@IdAsignacionTurno INT,
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN 
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdAsignacionTurno = @IdAsignacionTurno)
BEGIN
RAISERROR('No se encontro la asiganacion',16,1)
RETURN
END

UPDATE AsignacionTurno
SET FechaAsignacion = @FechaAsignacion,
IdEmpleado = @IdEmpleado,
IdTurno = @IdTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno
END
GO
CREATE OR ALTER PROCEDURE SP_ListarTodosAsignacionesTurno
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.IdAsignacionTurno,
        st.IdEmpleado,
        st.IdTurno,
        st.FechaAsignacion,
        t.Descripcion AS TurnoDescripcion,
        p.PrimerNombre + ' ' + p.PrimerApellido AS NombreEmpleado
    FROM AsignacionTurno st
    INNER JOIN Turno t ON st.IdTurno = t.IdTurno
    INNER JOIN Empleado e ON st.IdEmpleado = e.IdEmpleado
    INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
    ORDER BY st.FechaAsignacion, st.IdTurno;
END
GO


-- Buscar asiganacion turno por fecha
GO
CREATE OR ALTER PROCEDURE SP_BuscaAsignacionTurnoPorFech
@FechaAsignacion DATE
AS
BEGIN
SELECT st.FechaAsignacion, st.IdTurno, t.Descripcion AS Turno FROM AsignacionTurno AS st
INNER JOIN Turno t ON st.IdTurno = t.IdTurno
WHERE FechaAsignacion = @FechaAsignacion
END

GO

GO

-- Buscar asigancion turno por empleado
CREATE OR ALTER PROCEDURE SP_BuscarAsignacionTurnoPorEmplead
@IdEmpleado INT 
AS
BEGIN 
	SELECT st.FechaAsignacion, st.IdTurno, e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS 'Nombre Empleado' 
	FROM AsignacionTurno AS st
	INNER JOIN Empleado e ON st.IdEmpleado = e.IdEmpleado
	INNER JOIN Persona p ON e.IdEmpleado = p.IdPersona
	WHERE e.IdEmpleado = @IdEmpleado
END

GO

GO

-- Crear una nueva asignacion de turno
CREATE OR ALTER PROCEDURE SP_CrearAsignacionTurno
@FechaAsignacion DATE,
@IdEmpleado INT,
@IdTurno INT
AS
BEGIN

SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM Empleado WHERE IdEmpleado = @IdEmpleado)
BEGIN 
RAISERROR('No existe este empleado',16,1)
RETURN
END


INSERT INTO AsignacionTurno(FechaAsignacion, IdEmpleado, IdTurno)
VALUES(@FechaAsignacion,@IdEmpleado, @IdTurno)
END

GO

GO
-- Eliminar asignacion turno
CREATE OR ALTER PROCEDURE SP_EliminarAsignacionTurno
@IdAsignacionTurno INT
AS
BEGIN
SET NOCOUNT ON
IF NOT EXISTS(SELECT 1 FROM AsignacionTurno WHERE IdAsignacionTurno = @IdAsignacionTurno)
BEGIN
RAISERROR('No se encontro la asiganacion',16,1)
RETURN
END

DELETE FROM AsignacionTurno
WHERE IdAsignacionTurno = @IdAsignacionTurno
END 

GO
-- Buscar asignacion por Id
CREATE OR ALTER PROCEDURE SP_ObtenerAsignacionTurnoPorId
@IdAsignacionTurno INT
AS
BEGIN
SELECT *
FROM AsignacionTurno AS st
WHERE st.IdAsignacionTurno = @IdAsignacionTurno
END


GO

CREATE OR ALTER PROCEDURE SP_SelectAllAsignacionTurno
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @IdEmpleado INT = NULL,
    @IdTurno INT = NULL,
    @FechaFilter DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT
        AT.IdAsignacionTurno,
        (P.PrimerNombre + ' ' + P.PrimerApellido) AS NombreCompleto,
        T.Descripcion AS Turno,
        AT.FechaAsignacion,
        AT.IdEmpleado,
        AT.IdTurno
    FROM AsignacionTurno AS AT
    INNER JOIN Empleado AS E ON AT.IdEmpleado = E.IdEmpleado
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN Turno AS T ON AT.IdTurno = T.IdTurno
    WHERE
        (@IdEmpleado IS NULL OR AT.IdEmpleado = @IdEmpleado)
        AND (@IdTurno IS NULL OR AT.IdTurno = @IdTurno)
        AND (@FechaFilter IS NULL OR AT.FechaAsignacion = @FechaFilter)
    ORDER BY AT.IdAsignacionTurno
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM AsignacionTurno AS AT
    WHERE
        (@IdEmpleado IS NULL OR AT.IdEmpleado = @IdEmpleado)
        AND (@IdTurno IS NULL OR AT.IdTurno = @IdTurno)
        AND (@FechaFilter IS NULL OR AT.FechaAsignacion = @FechaFilter);
END;
GO


-- 14. TABLA: PersonaNoGrata

CREATE OR ALTER PROCEDURE SP_SelectAllPersonasNoGratas
AS
BEGIN
    SELECT P.PrimerNombre + ' ' +  P.PrimerApellido AS Nombre ,PG.*
    FROM PersonaNoGrata AS PG
    INNER JOIN Persona AS P ON PG.IdPersona= P.IdPersona
END;
GO
exec SP_SelectAllPersonasNoGratas

-- ActrulaizarPersonaNoGrata
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

-- Buscar personaNoGrata por Id
CREATE OR ALTER PROCEDURE SP_BuscarPeronaNoGrataPorId
@IdPersonaNoGrata INT 
AS
BEGIN
SELECT pn.idPersonaNoGrata, p.PrimerNombre, p.PrimerApellido, pn.FechaInicio, pn.FechaFin, pn.Motivo FROM PersonaNoGrata AS pn
INNER JOIN Persona p ON pn.IdPersona = p.IdPersona
WHERE pn.idPersonaNoGrata = @IdPersonaNoGrata
END

GO
-- Buscar personaNograta Por fecha fin
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

-- Buscar persona No grata por fecha Inicio
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
-- Eliminar Persona No grata
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

-- Crear a persona no grata
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

-- 15. TABLA: VehiculoProhibido

-- Actualizar vehiculo prohibido 
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
-- Buscar vehiculo prohibido por fecha

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

-- Busacar vehiculo prohibido por Id
CREATE OR ALTER PROCEDURE SP_BuscarVehiculoProhiubidoPorId
@IdVehiculoProhibido INT
AS
BEGIN
SELECT * FROM VehiculoProhibido 
WHERE IdVehiculoProhibido = @IdVehiculoProhibido
END

GO

-- Eliminar vehiculo prohibido por Id
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

-- Insertar a un vehiculo prohibido 
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

CREATE OR ALTER PROCEDURE SP_SelectAllVehiculoProhibido
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @PlacaFilter VARCHAR(20) = NULL,
    @MotivoFilter VARCHAR(50) = NULL,
    @FechaFilter DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        VP.IdVehiculoProhibido,
        V.Placa,
        m.Descripcion AS Marca,
        l.Descripcion AS Linea,
		VP.Motivo,
        VP.Fecha,
        VP.IdVehiculo
    FROM VehiculoProhibido AS VP
    INNER JOIN Vehiculo AS V ON VP.IdVehiculo = V.IdVehiculo
	INNER JOIN Marca m ON V.IdMarca = m.IdMarca
	INNER JOIN Linea l ON v.IdLinea = l.IdLinea
    WHERE
        (@PlacaFilter IS NULL OR V.Placa LIKE '%' + @PlacaFilter + '%')
        AND (@MotivoFilter IS NULL OR VP.Motivo LIKE '%' + @MotivoFilter + '%')
        AND (@FechaFilter IS NULL OR VP.Fecha = @FechaFilter)
    ORDER BY VP.IdVehiculoProhibido
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM VehiculoProhibido AS VP
    INNER JOIN Vehiculo AS V ON VP.IdVehiculo = V.IdVehiculo
	INNER JOIN Marca m ON V.IdMarca = m.IdMarca
	INNER JOIN Linea l ON v.IdLinea = l.IdLinea
    WHERE
        (@PlacaFilter IS NULL OR V.Placa LIKE '%' + @PlacaFilter + '%')
        AND (@MotivoFilter IS NULL OR VP.Motivo LIKE '%' + @MotivoFilter + '%')
        AND (@FechaFilter IS NULL OR VP.Fecha = @FechaFilter);
END

GO

-- 16. TABLA: Empleado


CREATE OR ALTER PROCEDURE SP_SelectAllEmpleado
@PageIndex INT = 1,
@PageSize INT = 10,
@FechaAltaFilter DATE = NULL,
@FechaBajaFilter DATE = NULL,
@NombreEmpleadoFilter VARCHAR(50) = NULL,
@PuestoFilter VARCHAR(50) = NULL
AS
BEGIN
    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;
    SELECT e.IdEmpleado, p.PrimerNombre + ' ' + p.PrimerApellido AS NombreCompleto , PE.Nombre, PE.Descripcion, E.FechaAlta, E.FechaBaja
    FROM Persona AS p
    INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON e.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
    (@FechaAltaFilter IS NULL OR
    E.FechaAlta = @FechaAltaFilter)AND
    (@FechaBajaFilter IS NULL OR
     E.FechaBaja =@FechaBajaFilter)AND
    (@NombreEmpleadoFilter  IS NULL OR 
     p.PrimerNombre + ' ' + p.PrimerApellido LIKE '%' + @NombreEmpleadoFilter + '%')AND
    (@PuestoFilter  IS NULL OR
     PE.Nombre LIKE '%' + @PuestoFilter + '%')
     ORDER BY E.IdEmpleado
     OFFSET @Offset ROWS
     FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM Persona AS p
    INNER JOIN Empleado e ON p.IdPersona = e.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON e.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
    (@FechaAltaFilter IS NULL OR
    E.FechaAlta = @FechaAltaFilter)AND
    (@FechaBajaFilter IS NULL OR
     E.FechaBaja =@FechaBajaFilter)AND
    (@NombreEmpleadoFilter  IS NULL OR 
     p.PrimerNombre + ' ' + p.PrimerApellido LIKE '%' + @NombreEmpleadoFilter + '%')AND
    (@PuestoFilter  IS NULL OR
     PE.Nombre LIKE '%' + @PuestoFilter + '%')

END;  
EXEC SP_SelectAllEmpleado
GO
-- Buscar empleado por nombre 
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

-- Actualizar empleados 
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

-- Buscar empleaado por Id
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

-- Insertar empleado 
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

CREATE OR ALTER PROCEDURE SP_SelectAllEmpleado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @NombreFilter VARCHAR(50) = NULL,
    @PuestoFilter VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        E.IdEmpleado,
        (P.PrimerNombre + ' ' + P.PrimerApellido) AS NombreCompleto,
        E.Estado,
        E.FechaAlta,
        E.FechaBaja,
        P.IdPersona,
        E.IdPuestoEmpleado
    FROM Empleado AS E
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON E.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
        (@NombreFilter IS NULL 
            OR P.PrimerNombre LIKE '%' + @NombreFilter + '%'
            OR P.PrimerApellido LIKE '%' + @NombreFilter + '%')
        AND (@PuestoFilter IS NULL OR PE.Nombre LIKE '%' + @PuestoFilter + '%')
    ORDER BY E.IdEmpleado
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

 
    SELECT COUNT(*) AS TotalCount
    FROM Empleado AS E
    INNER JOIN Persona AS P ON E.IdPersona = P.IdPersona
    INNER JOIN PuestoEmpleado AS PE ON E.IdPuestoEmpleado = PE.IdPuestoEmpleado
    WHERE
        (@NombreFilter IS NULL 
            OR P.PrimerNombre LIKE '%' + @NombreFilter + '%'
            OR P.PrimerApellido LIKE '%' + @NombreFilter + '%')
        AND (@PuestoFilter IS NULL OR PE.Nombre LIKE '%' + @PuestoFilter + '%');
END;


EXEC SP_SelectAllEmpleado 
    @PageIndex = 1,
    @PageSize = 10,
    @NombreFilter = 'Cristian',
    @PuestoFilter = 'Guardia';

	SELECT * FROM Empleado WHERE IdEmpleado = 1;
GO

-- 17. TABLA: Garita

-- Actualizar Garita
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

-- Buscar garita por cluster
CREATE OR ALTER PROCEDURE SP_ConsultarPorClusterGarita
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdCluster = @IdCluster
END;

GO

-- Buscar garita por Id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

GO

--Buscar todas las garita 
CREATE OR ALTER PROCEDURE SP_ConsultarTodasGarita
AS
BEGIN
    SELECT  g.* , r.Nombre AS Residencial FROM Garita AS g
	INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
	INNER JOIN Residencial r ON c.IdResidencial = r.IdResidencial
END;

GO
exec SP_ConsultarTodasGarita
go
-- Eliminar una garita 
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

-- Crear Garita
CREATE OR ALTER PROCEDURE SP_InsertarGarita
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (IdCluster)
    VALUES (@IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- 18. TABLA: Linea

-- Actualizar linea de carro
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

-- Buscar linea de carro por descripcion
CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

GO

-- Buscar linea de carro por Id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

GO

-- Buscar por la marca de la linea
CREATE OR ALTER PROCEDURE SP_ConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

GO

-- Eliminar linea de carro
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

-- Insertar linea de carro
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
-- 19. TABLA: Marca

-- Actualizar marca de carroo
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

-- Consultar marca por descripcion
CREATE OR ALTER PROCEDURE SP_ConsultarPorDescripcionMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

GO

-- Buscar marca por ID
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

GO

-- Eliminar marca 
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

-- Insertar marca de carro 
CREATE OR ALTER PROCEDURE SP_InsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- 20. TABLA: RegistroAcceso

CREATE OR ALTER PROCEDURE SP_SelectAllRegistroAcceso
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @FechaIngresoDesde DATETIME = NULL,
    @FechaIngresoHasta DATETIME = NULL,
    @IdGaritaFilter INT = NULL,
    @IdEmpleadoFilter INT = NULL,
    @TipoAccesoFilter VARCHAR(10) = NULL 
AS
BEGIN

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    
    SELECT 
        ra.IdAcceso,
        ra.FechaIngreso,
        ra.FechaSalida,
        ra.Observaciones,
        ra.IdVehiculo,
        ra.IdGarita,
        ra.IdVisitante,
        ra.IdResidente,
        ra.IdEmpleado,
        g.IdCluster AS IdClusterGarita,
        c.Descripcion AS ClusterGarita,
       
        CASE 
            WHEN ra.IdVehiculo IS NOT NULL THEN 'Vehículo'
            WHEN ra.IdVisitante IS NOT NULL THEN 'Visitante'
            WHEN ra.IdResidente IS NOT NULL THEN 'Residente'
            ELSE 'Empleado'
        END AS TipoAcceso,
        COALESCE(v.Placa, vis.NombreCompleto, res.NombreCompleto, emp.NombreCompleto) AS DescripcionAcceso
    FROM RegistroAccesos ra
    INNER JOIN Garita g ON ra.IdGarita = g.IdGarita
    INNER JOIN Cluster c ON g.IdCluster = c.IdCluster
    LEFT JOIN Vehiculo v ON ra.IdVehiculo = v.IdVehiculo
    LEFT JOIN Visitante vis ON ra.IdVisitante = vis.IdVisitante
    LEFT JOIN (
        SELECT r.IdResidente, 
               CONCAT(p.PrimerNombre, ' ', ISNULL(p.SegundoNombre, ''), ' ', p.PrimerApellido, ' ', ISNULL(p.SegundoApellido, '')) AS NombreCompleto
        FROM Residente r
        INNER JOIN Persona p ON r.IdPersona = p.IdPersona
    ) res ON ra.IdResidente = res.IdResidente
    LEFT JOIN (
        SELECT e.IdEmpleado,
               CONCAT(p.PrimerNombre, ' ', ISNULL(p.SegundoNombre, ''), ' ', p.PrimerApellido, ' ', ISNULL(p.SegundoApellido, '')) AS NombreCompleto
        FROM Empleado e
        INNER JOIN Persona p ON e.IdPersona = p.IdPersona
    ) emp ON ra.IdEmpleado = emp.IdEmpleado
    WHERE 
        (@FechaIngresoDesde IS NULL OR ra.FechaIngreso >= @FechaIngresoDesde)
        AND (@FechaIngresoHasta IS NULL OR ra.FechaIngreso <= @FechaIngresoHasta)
        AND (@IdGaritaFilter IS NULL OR ra.IdGarita = @IdGaritaFilter)
        AND (@IdEmpleadoFilter IS NULL OR ra.IdEmpleado = @IdEmpleadoFilter)
        AND (
            @TipoAccesoFilter IS NULL OR
            (@TipoAccesoFilter = 'Vehiculo' AND ra.IdVehiculo IS NOT NULL) OR
            (@TipoAccesoFilter = 'Visitante' AND ra.IdVisitante IS NOT NULL) OR
            (@TipoAccesoFilter = 'Residente' AND ra.IdResidente IS NOT NULL) OR
            (@TipoAccesoFilter = 'Empleado' AND ra.IdVehiculo IS NULL AND ra.IdVisitante IS NULL AND ra.IdResidente IS NULL)
        )
    ORDER BY ra.FechaIngreso DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Total de registros
    SELECT COUNT(*) AS TotalCount
    FROM RegistroAccesos ra
    WHERE 
        (@FechaIngresoDesde IS NULL OR ra.FechaIngreso >= @FechaIngresoDesde)
        AND (@FechaIngresoHasta IS NULL OR ra.FechaIngreso <= @FechaIngresoHasta)
        AND (@IdGaritaFilter IS NULL OR ra.IdGarita = @IdGaritaFilter)
        AND (@IdEmpleadoFilter IS NULL OR ra.IdEmpleado = @IdEmpleadoFilter)
        AND (
            @TipoAccesoFilter IS NULL OR
            (@TipoAccesoFilter = 'Vehiculo' AND ra.IdVehiculo IS NOT NULL) OR
            (@TipoAccesoFilter = 'Visitante' AND ra.IdVisitante IS NOT NULL) OR
            (@TipoAccesoFilter = 'Residente' AND ra.IdResidente IS NOT NULL) OR
            (@TipoAccesoFilter = 'Empleado' AND ra.IdVehiculo IS NULL AND ra.IdVisitante IS NULL AND ra.IdResidente IS NULL)
        );
END;

Exec SP_SelectAllRegistroAcceso

Go

--Actualizar registro acceso
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

-- Buscar registro acceso por fecha de ingreso
CREATE OR ALTER PROCEDURE SP_ConsultarPorFechaIngresoRegistroAccesos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE CAST(FechaIngreso AS DATE) = @Fecha
END;

GO

-- Buscar registro acceso por id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
END;

GO

-- Buscar registro acceso por vehiculo
CREATE OR ALTER PROCEDURE SP_ConsultarPorVehiculoRegistroAccesos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo
END;

GO

-- Eliminar un registro acceso
CREATE OR ALTER PROCEDURE SP_EliminarRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    DELETE FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

-- Crear un registro acceso
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

-- 21. TABLA: TipoDocumento 

-- Actualizar Tipo documento
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
-- Buscar tipo documento por id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

-- Buscar tipo docuemnto por nombre
CREATE OR ALTER PROCEDURE SP_ConsultarPorNombreTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE Nombre = @Nombre
END;

GO

-- Consultar todos los tipo doc
CREATE OR ALTER PROCEDURE SP_ConsultarTodosTipoDoc
AS
BEGIN
    SELECT * FROM TipoDocumento
END;

GO

-- Eliminar tipo documento
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

-- Crea tipo docuemento
CREATE OR ALTER PROCEDURE SP_InsertarTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO TipoDocumento (Nombre)
    VALUES (@Nombre)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- 22. TABLA: Vehiculo
CREATE OR ALTER PROCEDURE SP_SelectAllVehiculo
@PageIndex  INT= 1,
@PageSize  INT = 10,
@AnioFilter INT= NULL,
@MarcaFilter VARCHAR(20) = NULL,
@LineaFilter VARCHAR(20) = NULL
As
BEGIN

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize
    SELECT V.Año, V.Placa ,M.Descripcion AS Marca ,L.Descripcion AS Linea
    FROM Vehiculo AS V
    INNER JOIN MARCA AS M ON  V.IdMarca = M.IdMarca
    INNER JOIN Linea AS L ON V.IdLinea = L.IdLinea
    WHERE
    (@AnioFilter IS NULL OR 
    V.Año = @AnioFilter)AND
    (@MarcaFilter IS NULL OR
    M.Descripcion LIKE '' + @MarcaFilter + '')AND
    (@LineaFilter IS NULL OR
    L.Descripcion  LIKE '' + @LineaFilter + '')
    ORDER BY V.IdVehiculo
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT (*)
    FROM Vehiculo AS V
    INNER JOIN MARCA AS M ON  V.IdMarca = M.IdMarca
    INNER JOIN Linea AS L ON V.IdLinea = L.IdLinea
    WHERE
    (@AnioFilter IS NULL OR 
    V.Año = @AnioFilter)AND
    (@MarcaFilter IS NULL OR
    M.Descripcion LIKE '' + @MarcaFilter + '')AND
    (@LineaFilter IS NULL OR
    L.Descripcion  LIKE '' + @LineaFilter + '')

   
END;
EXEC SP_SelectAllVehiculo



GO
-- Actualizar vehiculo
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

-- Buscar vehiculo por Id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVehiculo
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
END;

GO

-- Buscar vehiculo por placa
CREATE OR ALTER PROCEDURE SP_ConsultarPorPlacaVehiculo
    @Placa VARCHAR(10)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Placa = @Placa
END;

GO

-- Buscar vehiculo por vivienda
CREATE OR ALTER PROCEDURE SP_ConsultarPorViviendaVehiculo
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Vehiculo 
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
END;

GO

-- Eliminar Vehiculo
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

-- Insertar un nuevo vehiculo 
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
        IF EXISTS (SELECT 1 FROM Vehiculo WHERE Placa = @Placa)
        BEGIN
            RAISERROR('Error: Ya existe un vehiculo con la placa %s', 16, 1, @Placa)
            RETURN -1
        END
        DECLARE @CantidadVehiculos INT
        SELECT @CantidadVehiculos = COUNT(*) 
        FROM Vehiculo 
        WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
        IF @CantidadVehiculos >= 4
        BEGIN
            RAISERROR('Error: La vivienda %d del cluster %d ya tiene %d vehiculos (maximo 4 permitidos)', 16, 1, @NumeroVivienda, @IdCluster, @CantidadVehiculos)
            RETURN -2
        END
        IF NOT EXISTS (SELECT 1 FROM Vivienda WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster)
        BEGIN
            RAISERROR('Error: La vivienda %d en el cluster %d no existe', 16, 1, @NumeroVivienda, @IdCluster)
            RETURN -3
        END       
        IF NOT EXISTS (SELECT 1 FROM Linea WHERE IdLinea = @IdLinea AND IdMarca = @IdMarca)
        BEGIN
            RAISERROR('Error: La linea %d no existe o no corresponde a la marca %d', 16, 1, @IdLinea, @IdMarca)
            RETURN -4
        END
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

-- 23. TABLA: Visitante 

CREATE OR ALTER PROCEDURE SP_SelectAllVisitante
@PageIndex INT = 1,
@PageSize INT = 10,
@NumeroDocumentoFilter VARCHAR(20) = NULL,
@NombreVisitanteFilter VARCHAR(100) = NULL
AS
BEGIN
    DECLARE @Offset INT  =(@PageIndex - 1) * @PageSize
    SELECT V.*, T.Nombre AS NombreDocumento
    FROM Visitante AS V 
    INNER JOIN TipoDocumento AS T ON V.IdTipoDocumento = T.IdTipoDocumento
    WHERE
    (@NumeroDocumentoFilter IS NULL OR
    V.NumeroDocumento LIKE '' + @NumeroDocumentoFilter + '')AND
    (@NombreVisitanteFilter IS NULL OR
    V.NombreCompleto LIKE '' +@NombreVisitanteFilter + '')
    ORDER BY V.IdVisitante
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT (*) AS TotalCount
    FROM Visitante AS V
    WHERE
    (@NumeroDocumentoFilter IS NULL OR
    V.NumeroDocumento LIKE '' + @NumeroDocumentoFilter + '')AND
    (@NombreVisitanteFilter IS NULL OR
    V.NombreCompleto LIKE '' +@NombreVisitanteFilter + '')
    

END;
exec SP_SelectAllVisitante
go
--Actualizar vehiculo
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
-- Buscar visitante por documento
CREATE OR ALTER PROCEDURE SP_ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(20)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

GO

-- Buscar visistante por Id
CREATE OR ALTER PROCEDURE SP_ConsultarPorIdVisitante
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdVisitante = @IdVisitante
END;

GO

-- Buscar visiatante por su tipo documento
CREATE OR ALTER PROCEDURE SP_ConsultarPorTipoDocumentoVisitante
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

-- Eliminar Visitante 
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

-- Insertar visitante 
CREATE OR ALTER PROCEDURE SP_InsertarVisitante
    @NombreCompleto VARCHAR(100),
    @NumeroDocumento VARCHAR(20),
    @Telefono VARCHAR(15),
    @MotivoVisita VARCHAR(100),
    @IdTipoDocumento INT
AS
BEGIN
	IF EXISTS (SELECT * 
	FROM Persona AS P
	INNER JOIN PersonaNoGrata AS PNG
	ON P.IdPersona = PNG.IdPersona
	WHERE Cui =  @NumeroDocumento
	)
	BEGIN
	RAISERROR('Visitante no permitido, es persona no grata', 16, 1);
	RETURN;
	END;
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    VALUES (@NombreCompleto, @NumeroDocumento, @Telefono, @MotivoVisita, @IdTipoDocumento)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- 24. TABLA: TipoPago 

-- Creas tipo Pago
Create  OR ALTER Procedure SP_InsertarTipoPago 
@Nombre VARCHAR (50),
@Descripcion VARCHAR (100)
As
Begin 
	Insert Into TipoPago(Nombre,Descripcion)
	Values (@Nombre, @Descripcion );
	SELECT SCOPE_IDENTITY() AS idTipoPago;
End;
GO
Create OR Alter Procedure BuscarTipoPagoPorNombre 
@Nombre VARCHAR (50)
AS

Begin 
	Select Nombre, Descripcion
	from TipoPago
	Where  Nombre = @Nombre 

END;
GO

-- Actualizar tipo pago
CREATE OR  ALTER PROCEDURE SP_ActualizarTipoPago
@idTipoPago int, 
@NuevoNombre VARCHAR (50),
@NuevaDescripcion VARCHAR(100)
AS

BEGIN 
	UPDATE TipoPago
	SET Nombre = @NuevoNombre,
		Descripcion = @NuevaDescripcion
	WHERE idTipoPago = @idTipoPago
	
	IF @@ROWCOUNT > 0 
	BEGIN  
	PRINT 'La fila se actualizo correctamente'
	END
	ELSE 
	BEGIN
	PRINT 'la fila no se actualizo'
	END 
END;
GO

-- Buscar tipo pago por Id
Create OR Alter Procedure SP_BuscarTipoPagoPorID
@idTipoPago int 
AS

Begin 
	Select idTipoPago, Nombre, Descripcion
	from TipoPago
	Where  idTipoPago = @idTipoPago 

END;
GO

-- Eliminar tipo pago
CREATE OR ALTER PROCEDURE SP_EliminarTipoPago
    @idTipoPago INT
AS
BEGIN
 IF NOT EXISTS (SELECT 1 FROM TipoPago WHERE idTipoPago = @idTipoPago)
    BEGIN
        RAISERROR('El tipo pago solicitado no existe.', 16,1, 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM DetallePago WHERE idTipoPago = @idTipoPago)
    BEGIN
        RAISERROR('No se puede eliminar este tipo de pago, debido a que esta asociado a otra tabla.', 16, 1);
        RETURN;
    END

    DELETE FROM TipoPago
    WHERE idTipoPago = @idTipoPago;

    PRINT 'El tipo de pago se ha eliminado correctamente.';
END;
GO

-- 25. TABLA: Pago 

--inserta  pago 
Create  OR ALTER Procedure SP_InsertarPago 
@FechaPago date,
@MontoTotal decimal
As
Begin 
	Insert Into Pago (FechaPago , MontoTotal, MontoLiquidado, Saldo )
	Values (@FechaPago, @MontoTotal, 0, @MontoTotal )
	SELECT SCOPE_IDENTITY() AS IdPago;
End;
GO
CREATE OR ALTER PROCEDURE SP_SelectAllPago
@PageIndex INT = 1,
@PageSize INT = 10,
@FechaPagoFilter DATE = null,
@MontoTotalFilter DECIMAL(18,2) = NULL
AS
BEGIN

    DECLARE @offset INT = (@PageIndex -1) * @pageSize;
    SELECT 
		p.IdPago, p.FechaPago,p.MontoTotal, p.MontoLiquidado, p.Saldo
    FROM Pago AS p
    WHERE
        (@FechaPagoFilter IS NULL OR cast( p.FechaPago as date) = @FechaPagoFilter )
		AND (@MontoTotalFilter IS NULL OR p.MontoTotal = @MontoTotalFilter)
		
    ORDER BY p.FechaPago desc 
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    From Pago AS p
    WHERE
        (@FechaPagoFilter IS NULL OR cast( p.FechaPago as date) = @FechaPagoFilter )
		AND (@MontoTotalFilter IS NULL OR p.MontoTotal = @MontoTotalFilter)
		

END;
EXEC SP_SelectAllPago
GO
--actualizar pagos  
CREATE OR ALTER PROCEDURE SP_ActualizarPagos
    @IdPago INT,
    @FechaPago DATE ,
	@MontoTotal int
   
	
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM Pago WHERE IdPago = @IdPago
    )
    BEGIN
        UPDATE Pago
        SET FechaPago = @FechaPago,
            MontoTotal = @MontoTotal          
        WHERE IdPago = @IdPago;
        PRINT 'el pago ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El pago solicitado no existe.', 16, 1);
    END
END;
GO

-- Buscar pagi por monto
Create OR Alter Procedure SP_BuscarPagoPorMonto
@MontoTotal decimal 
AS
Begin 
	Select IdPago, FechaPago,  MontoTotal
	from Pago
	Where  MontoTotal >= @MontoTotal 

END;
GO
-- Buscar pagos por fecha 
Create OR Alter Procedure SP_BuscarPagoPorFecha
@FechaPago date 
AS
Begin 
	Select FechaPago, MontoTotal
	from Pago
	Where  FechaPago = @FechaPago 

END;
GO
-- =Buscar pago por ID
Create OR Alter Procedure SP_BuscarPagoPorID
@IdPago int 
AS

Begin 
	Select IdPago, FechaPago, MontoTotal, MontoLiquidado, Saldo
	from Pago
	Where  IdPago = @IdPago 

END;
Go
--elimina el pago
CREATE OR ALTER PROCEDURE SP_EliminarPago
    @IdPago INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Pago WHERE IdPago = @IdPago)
	BEGIN 
		RAISERROR ('El numero de pago no existe', 16,1);
		RETURN; 
	END
		IF EXISTS (SELECT 1 FROM Recibo WHERE IdPago = @IdPago)
	BEGIN 
		RAISERROR ('El pago esta asociado con recibo',16,1);
		RETURN ;
	END 
    BEGIN
        DELETE FROM DetallePago
        WHERE IdPago = @IdPago;
        DELETE FROM Pago
        WHERE IdPago = @IdPago;

        PRINT 'El pago se ha eliminado correctamente.';
	END
    
END;
GO

-- 26. TABLA: TipoMulta

--inserta un tipo de multa 
CREATE OR ALTER PROCEDURE SP_InsertarTipoMulta
@Nombre VARCHAR (50),
@Monto money 
AS
BEGIN
	INSERT INTO TipoMulta (Nombre, Monto)
	VALUES(@Nombre, @Monto)
	SELECT SCOPE_IDENTITY () AS IdTipoMulta;
END;
GO
--buscar el tipo de multa por nombre 
CREATE OR ALTER PROCEDURE SP_BuscarTipoMultaPorNombre
@Nombre VARCHAR (50)
AS
BEGIN 
	SELECT Nombre, Monto
	FROM TipoMulta
	WHERE Nombre LIKE '%' + @Nombre + '%';
END;
GO 

--busca el tipo de monto que sea igual o mayor al parametro de entrada 
CREATE OR ALTER PROCEDURE SP_BuscarTipoMultaPorMonto
@Monto money 
AS
BEGIN
	SELECT Nombre, Monto
	FROM TipoMulta
	WHERE Monto >= @Monto
END;
GO
--busca el tipo de multa por el id 
CREATE OR ALTER PROCEDURE SP_BuscarTipoMultaPorID
@IdTipoMulta int
AS
BEGIN 
	SELECT IdTipoMulta, Nombre, Monto
	FROM TipoMulta
	WHERE IdTipoMulta = @IdTipoMulta
END;
GO
--actualiza tipo multa por fila
CREATE OR ALTER PROCEDURE SP_ActualizarTipoMulta
@IdTipoMulta int, 
@Nombre VARCHAR (50),
@Monto MONEY
AS
BEGIN
	UPDATE TipoMulta 
	SET Nombre = @Nombre,
		Monto = @Monto
	WHERE IdTipoMulta = @IdTipoMulta
	
	IF @@ROWCOUNT > 0 
	BEGIN  
	PRINT 'La fila se actualizo correctamente'
	END
	ELSE 
	BEGIN
	PRINT 'la fila no se actualizo'
	END 

END;
GO
--elimina un tipo de multa por medio del id 
CREATE OR ALTER PROCEDURE SP_EliminarTipoMulta
@IdTipoMulta int 
AS
	IF NOT EXISTS (SELECT 1 FROM TipoMulta WHERE IdTipoMulta= @IdTipoMulta)
	BEGIN
		RAISERROR('El tipo de multa solicitado no existe.',16,1);
		RETURN;
	END
	IF EXISTS (SELECT 1 FROM MultaVivienda WHERE IdTipoMulta = @IdTipoMulta)
	BEGIN
		RAISERROR ('El tipo pagono se puede eliminar bedido a que esta asociado a otra entidad', 16,1);
		RETURN;
	END
 
BEGIN
	DELETE TipoMulta
	WHERE IdTipoMulta= @IdTipoMulta; 
	PRINT 'El tipo multa se ha eliminado correctamente.'
END;
GO

-- 27. TABLA: Servicio

--inserta Servicio
Create  OR ALTER Procedure SP_InsertarServicio
@Nombre  VARCHAR (50),
@Tarifa decimal 
As
Begin 
	Insert Into Servicio( Nombre, Tarifa)
	Values (@Nombre, @Tarifa);
	
End;
GO
-- Buscar servicio  por descripcion  
Create OR Alter Procedure SP_BuscarServicioDescripcion 
@Nombre Varchar(50)
AS
Begin 
	Select  Nombre, Tarifa 
	from Servicio
	Where  Nombre = @Nombre 

END;
GO

-- Buscar servico  por id 
Create OR Alter Procedure SP_BuscarServicioId
@IdServicio int 
AS

Begin 
	Select IdServicio,Nombre, Tarifa
	from Servicio
	Where  IdServicio = @IdServicio 

END;
GO
--actualiza Servicio 
CREATE OR ALTER PROCEDURE SP_ActualizarServicio
    @IdServicio INT,
    @Nombre VARCHAR(50),
    @Tarifa DECIMAL
AS
BEGIN
    
    UPDATE Servicio
    SET Nombre = @Nombre,
        Tarifa = @Tarifa
    WHERE IdServicio = @IdServicio;
END;
GO
--elimina servicio
CREATE OR ALTER PROCEDURE SP_EliminarServicio
    @IdServicio INT
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Servicio WHERE IdServicio = @IdServicio)
    BEGIN
        RAISERROR('Este servicio no existe', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM CobroServicioVivienda WHERE IdServicio = @IdServicio)
    BEGIN
        RAISERROR('Este servicio no se puede eliminar ya que esta asociado a otra entidad.', 16, 1);
        RETURN;
    END
    DELETE FROM Servicio
    WHERE IdServicio = @IdServicio;

END;
GO
-- Buscar servicIo  por valor 
Create OR Alter Procedure SP_BuscarServicioValor
@Tarifa int 
AS
Begin 
	Select IdServicio,Tarifa, Nombre 
	from Servicio
	Where  Tarifa = @Tarifa 

END;
GO

-- 28. TABLA: Recibo

 --inserta un recibo
Create  OR ALTER Procedure SP_InsertarRecibo
@FechaEmision Date,
@IdPago int,
@NumeroVivienda int, 
@IdCluster int
As
Begin 
	Insert Into Recibo(FechaEmision, IdPago, NumeroVivienda, IdCluster)
	Values (@FechaEmision, @IdPago, @NumeroVivienda, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdRecibo
End;
GO
CREATE OR ALTER PROCEDURE SP_SelectAllRecibo
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @FechaEmisionFilter DATE = NULL,
    @IdPagoFilter INT = NULL, 
    @NumeroViviendaFilter INT = NULL,
    @ClusterFilter INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        r.IdRecibo, 
        r.FechaEmision,
        r.IdPago,
        r.NumeroVivienda,
        r.IdCluster, 
        CONCAT(p.PrimerNombre, ' ', ISNULL(p.SegundoNombre, ''), ' ', p.PrimerApellido, ' ', ISNULL(p.SegundoApellido, '')) AS NombreCompleto,
        c.Descripcion AS NombreCluster,
        ISNULL(SUM(COALESCE(cs.Monto, 0) + COALESCE(mv.Monto, 0)), 0) AS MontoTotal
    FROM Recibo r
    INNER JOIN Vivienda v ON r.NumeroVivienda = v.NumeroVivienda AND r.IdCluster = v.IdCluster
    LEFT JOIN Residente re ON v.NumeroVivienda = re.NumeroVivienda AND v.IdCluster = re.IdCluster
    LEFT JOIN Persona p ON re.IdPersona = p.IdPersona
    INNER JOIN Cluster c ON r.IdCluster = c.IdCluster
    LEFT JOIN DetalleRecibo dr ON r.IdRecibo = dr.IdRecibo
    LEFT JOIN CobroServicioVivienda cs ON dr.idCobroServicio = cs.idCobroServicio
    LEFT JOIN MultaVivienda mv ON dr.IdMultaVivienda = mv.IdMultaVivienda
    WHERE
        (@FechaEmisionFilter IS NULL OR CAST(r.FechaEmision AS DATE) = @FechaEmisionFilter)
        AND (@IdPagoFilter IS NULL OR r.IdPago = @IdPagoFilter)
        AND (@NumeroViviendaFilter IS NULL OR r.NumeroVivienda = @NumeroViviendaFilter)
        AND (@ClusterFilter IS NULL OR r.IdCluster = @ClusterFilter)
    GROUP BY 
        r.IdRecibo, r.FechaEmision, r.IdPago, r.NumeroVivienda, r.IdCluster, 
        p.PrimerNombre, p.SegundoNombre, p.PrimerApellido, p.SegundoApellido, c.Descripcion
    ORDER BY r.FechaEmision DESC
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    
    SELECT COUNT(*) AS TotalCount
    FROM Recibo r
    INNER JOIN Vivienda v ON r.NumeroVivienda = v.NumeroVivienda AND r.IdCluster = v.IdCluster
    LEFT JOIN Residente re ON v.NumeroVivienda = re.NumeroVivienda AND v.IdCluster = re.IdCluster
    LEFT JOIN Persona p ON re.IdPersona = p.IdPersona
    INNER JOIN Cluster c ON r.IdCluster = c.IdCluster
    WHERE
        (@FechaEmisionFilter IS NULL OR CAST(r.FechaEmision AS DATE) = @FechaEmisionFilter)
        AND (@IdPagoFilter IS NULL OR r.IdPago = @IdPagoFilter)
        AND (@NumeroViviendaFilter IS NULL OR r.NumeroVivienda = @NumeroViviendaFilter)
        AND (@ClusterFilter IS NULL OR r.IdCluster = @ClusterFilter);
END;

EXEC SP_SelectAllRecibo
go
-- buscar recibos por numero de pago 
CREATE OR ALTER PROCEDURE SP_BuscarReciboPorPago
    @IdPago INT
AS
BEGIN
    SELECT 
	    r.IdRecibo, r.FechaEmision,r.IdPago,r.NumeroVivienda,r.IdCluster, 
		Concat(p.PrimerNombre,' ',p.SegundoNombre,' ', p.PrimerApellido, ' ', p.SegundoApellido ) AS NombreCompleto,
		c.Descripcion AS NombreCluster
    FROM Recibo AS r
	INNER JOIN Vivienda AS v ON r.NumeroVivienda = v.NumeroVivienda and r.IdCluster= v.IdCluster
	INNER JOIN Residente AS re ON v.NumeroVivienda = re.NumeroVivienda and v.IdCluster = re.IdCluster
	INNER JOIN Persona AS p ON re.IdPersona = p.IdPersona
	INNER JOIN Cluster AS c ON r.IdCluster = c.IdCluster
    WHERE IdPago = @IdPago
END;
GO
-- buscar recibos por id

Create OR Alter Procedure SP_BuscarReciboPorId
@IdRecibo int 
AS

Begin 
	Select r.IdRecibo, r.FechaEmision,r.IdPago,r.NumeroVivienda,r.IdCluster,CONCAT(per.PrimerNombre,' ', per.SegundoNombre,' ',PrimerApellido, ' ' , per.SegundoApellido) AS NombreCompleto
	from Recibo as r
	INNER JOIN Vivienda as v ON r.NumeroVivienda = v.NumeroVivienda
	INNER JOIN Residente as re ON v.NumeroVivienda = re.NumeroVivienda
	INNER JOIN Persona as per ON re.IdPersona = per.IdPersona

	Where  IdRecibo = @IdRecibo 

END;
GO
-- Buscar recibos por fecha de emision 
Create OR Alter Procedure SP_BuscarReciboPorFecha
@FechaEmision date 
AS
Begin 
	Select 
		r.IdRecibo, r.FechaEmision,r.IdPago,r.NumeroVivienda,r.IdCluster, 
		Concat(p.PrimerNombre,' ',p.SegundoNombre,' ', p.PrimerApellido, ' ', p.SegundoApellido ) AS NombreCompleto,
		c.Descripcion AS NombreCluster
    FROM Recibo AS r
	INNER JOIN Vivienda AS v ON r.NumeroVivienda = v.NumeroVivienda and r.IdCluster= v.IdCluster
	INNER JOIN Residente AS re ON v.NumeroVivienda = re.NumeroVivienda and v.IdCluster = re.IdCluster
	INNER JOIN Persona AS p ON re.IdPersona = p.IdPersona
	INNER JOIN Cluster AS c ON r.IdCluster = c.IdCluster
	Where  FechaEmision = @FechaEmision 

END;
GO
-- actualizar recibo
CREATE OR ALTER PROCEDURE SP_ActualizarRecibo
    @IdRecibo INT,
    @FechaEmision DATE,
	@IdPago int,
	@NumeroVivienda int,
	@IdCluster int
AS
BEGIN
    UPDATE Recibo
    SET FechaEmision = @FechaEmision,
		IdPago = @IdPago,
		NumeroVivienda= @NumeroVivienda,
		IdCluster= @IdCluster
    WHERE IdRecibo = @IdRecibo;
END
GO
--elimina recibos
Create OR Alter Procedure SP_EliminarRecibo
@IdRecibo INT
AS
Begin
	IF NOT EXISTS (SELECT 1 FROM Recibo WHERE IdRecibo = @IdRecibo)
	BEGIN
        RAISERROR('El recibo solicitado no existe.', 16, 1);
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdRecibo=@IdRecibo)
	BEGIN 
		RAISERROR('No se puede eliminar el recibo debido a que esta asociado a otra entidad', 16,1);
		return;
	END
	BEGIN
		Delete FROM Recibo
		Where IdRecibo = @IdRecibo;
		PRINT 'El recibo se ha eliminado correctamente'
	END
End;
GO

-- 29. TABLA: MultaVivienda

--inserta multa a viviendas 
CREATE OR ALTER PROCEDURE SP_InsertarMultaVivienda
@Monto DECIMAL,
@Observaciones VARCHAR (100),
@FechaInfraccion DATE,
@FechaRegistro DATE = now,
@EstadoPago VARCHAR (50),
@IdTipoMulta INT,
@NumeroVivienda INT,
@IdCluster INT
AS
BEGIN
	INSERT INTO MultaVivienda (Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago,IdTipoMulta, NumeroVivienda, IdCluster)
	VALUES 	(@Monto, @Observaciones, @FechaInfraccion, @FechaRegistro, @EstadoPago,@IdTipoMulta, @NumeroVivienda, @IdCluster)
	SELECT SCOPE_IDENTITY () AS IdMultaVivienda;

END;
GO

CREATE OR ALTER PROCEDURE SP_SelectAllMultaVivienda
@PageIndex INT = 1,
@PageSize INT = 10,
@MultaViviendaFilter VARCHAR(30) = NULL,
@TipoMultaFilter VARCHAR (50) = NULL, 
@NumeroViviendaFilter INT = NULL,
@ClusterFilter INT = NULL,
@FechaInfraccionDesdeFilter DATE = NULL,
@FechaInfraccionHastaFilter DATE = NULL,
@FechaRegistroDesdeFilter DATE = NULL,
@FechaRegistroHastaFilter DATE = NULL,
@EstadoFilter VARCHAR(10) = NULL
AS
BEGIN

    DECLARE @offset INT = (@PageIndex -1) * @pageSize;
    SELECT 
        mv.IdMultaVivienda, mv.Monto, mv.Observaciones, mv.FechaInfraccion, mv.FechaRegistro, mv.EstadoPago, mv.IdTipoMulta, tm.Nombre AS NombreTipoMulta, v.NumeroVivienda,mv.IdCluster, c.Descripcion AS NombreCluster
    FROM MultaVivienda AS mv
    INNER JOIN TipoMulta AS tm 
        ON mv.IdTipoMulta = tm.IdTipoMulta
	INNER JOIN Vivienda AS v 
		ON mv.NumeroVivienda = v.NumeroVivienda AND mv.IdCluster = V.IdCluster
	INNER JOIN Cluster AS c 
	    ON mv.IdCluster = c.IdCluster 
    WHERE
        (@MultaViviendaFilter IS NULL OR  mv.FechaInfraccion LIKE '%' + @MultaviviendaFilter + '%')
		AND (@TipoMultaFilter IS NULL OR tm.Nombre LIKE '%' + @TipoMultaFilter + '%')
		AND (@NumeroViviendaFilter IS NULL OR v.NumeroVivienda  = @NumeroViviendaFilter)
		AND (@ClusterFilter IS NULL OR c.IdCluster = @ClusterFilter )
        AND(@FechaInfraccionDesdeFilter IS NULL OR CAST(mv.FechaInfraccion AS DATE) >= @FechaInfraccionDesdeFilter)
        AND(@FechaInfraccionHastaFilter IS NULL OR CAST(mv.FechaInfraccion AS DATE) <= @FechaInfraccionHastaFilter)
        AND(@FechaRegistroDesdeFilter  IS NULL OR CAST(mv.FechaRegistro AS DATE) >=@FechaRegistroDesdeFilter)
        AND(@FechaRegistroHastaFilter  IS NULL OR CAST(mv.FechaRegistro AS DATE) <=@FechaRegistroHastaFilter)
        AND(@EstadoFilter IS NULL OR
         mv.EstadoPago LIKE + '%' + @EstadoFilter + '%')
    ORDER BY mv.Monto
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    From MultaVivienda AS mv
	INNER JOIN TipoMulta AS tm 
        ON mv.IdTipoMulta = tm.IdTipoMulta
	INNER JOIN Vivienda AS v 
		ON mv.NumeroVivienda = v.NumeroVivienda AND mv.IdCluster = V.IdCluster
	INNER JOIN Cluster AS c 
	    ON mv.IdCluster = c.IdCluster 
    WHERE
        (@MultaViviendaFilter IS NULL OR  mv.FechaInfraccion LIKE '%' + @MultaviviendaFilter + '%')
		AND (@TipoMultaFilter IS NULL OR tm.Nombre LIKE '%' + @TipoMultaFilter + '%')
		AND (@NumeroViviendaFilter IS NULL OR v.NumeroVivienda =  @NumeroViviendaFilter )
		AND (@ClusterFilter IS NULL OR c.IdCluster =  @ClusterFilter )
        AND(@FechaInfraccionDesdeFilter IS NULL OR CAST(mv.FechaInfraccion AS DATE) >= @FechaInfraccionDesdeFilter)
        AND(@FechaInfraccionHastaFilter IS NULL OR CAST(mv.FechaInfraccion AS DATE) <= @FechaInfraccionHastaFilter)
        AND(@FechaRegistroDesdeFilter  IS NULL OR CAST(mv.FechaRegistro AS DATE) >=@FechaRegistroDesdeFilter)
        AND(@FechaRegistroHastaFilter  IS NULL OR CAST(mv.FechaRegistro AS DATE) <=@FechaRegistroHastaFilter)
        AND(@EstadoFilter IS NULL OR
         mv.EstadoPago LIKE + '%' + @EstadoFilter + '%')

END;
GO
exec SP_SelectAllMultaVivienda
go 
--busca multa de vivienda por numero de vivienda y cluster 
CREATE OR ALTER PROCEDURE SP_BuscarMVPorViviendaCluster
@NumeroVivienda int,
@IdCluster int 
AS
BEGIN 
		SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, NumeroVivienda, IdCluster
		FROM MultaVivienda
		WHERE NumeroVivienda = @NumeroVivienda AND IdCluster= @IdCluster

END;
GO
--busca multa de las viviendad por id 
CREATE OR ALTER PROCEDURE SP_BuscarMultaViviendaPorId 
@IdMultaVivienda int
AS
BEGIN
	SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster
	FROM MultaVivienda
	WHERE IdMultaVivienda = @IdMultaVivienda
END;
GO
--busca multa de vivienda por fecha de la infraccion 
CREATE OR ALTER PROCEDURE SP_BuscarMultaViviendaPorFechaInfraccion 
@FechaInfraccion DATE
AS
BEGIN
	SELECT IdMultaVivienda,Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster
	FROM MultaVivienda
	WHERE FechaInfraccion = @FechaInfraccion
END;
GO
--actualiza multa a viviendas 
CREATE OR ALTER PROCEDURE SP_ActualizarMultaVivienda
@IdMultaVivienda INT,
@Monto DECIMAL,
@Observaciones VARCHAR (100),
@FechaInfraccion DATE,
@FechaRegistro DATE,
@EstadoPago VARCHAR (50),
@IdTipoMulta INT,
@NumeroVivienda INT,
@IdCluster INT
AS
BEGIN
	UPDATE MultaVivienda 
	SET Monto = @Monto,
		Observaciones = @Observaciones,
		FechaInfraccion = @FechaInfraccion,
		FechaRegistro = @FechaRegistro,
		EstadoPago = @EstadoPago,
		IdTipoMulta = @IdTipoMulta,
		NumeroVivienda = @NumeroVivienda,
		IdCluster = @IdCluster
	WHERE IdMultaVivienda = @IdMultaVivienda;
	
	IF @@ROWCOUNT > 0 
	BEGIN  
	PRINT 'La fila se actualizo correctamente'
	END
	ELSE 
	BEGIN
	PRINT 'la fila no se actualizo'
	END 

END;
GO 
CREATE OR ALTER PROCEDURE SP_EliminarMultaVivienda
@IdMultaVivienda int 
AS
	IF NOT EXISTS (SELECT 1 FROM MultaVivienda WHERE IdMultaVivienda=@IdMultaVivienda )
		BEGIN
			RAISERROR('La multa vivienda no existe',16,1);
			RETURN; 
		END 
	IF  EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdMultaVivienda=@IdMultaVivienda )
	BEGIN
		RAISERROR('La multa vivienda nose puede eliminiar porque esta asociada con otra entidad',16,1);
		RETURN; 
	END 
BEGIN
	DELETE MultaVivienda
	WHERE IdMultaVivienda = @IdMultaVivienda;
	PRINT 'La multa de la vivienda se ha eliminado correctamente.'

END;
GO

-- 30. TABLA: CobroServicio

--insertar cobro de serivicio por vivienda 
Create  OR ALTER Procedure SP_InsertarCobroServicioVivienda
@FechaCobro Date,
@Monto DECIMAL(10,2) ,
@MontoAplicado DECIMAL(10,2),
@EstadoPago VARCHAR(10),
@IdServicio      int,
@NumeroVivienda  INT,
@IdCluster       INT
As
 IF DAY(@FechaCobro) NOT BETWEEN 1 AND 10
    BEGIN
        RAISERROR('La fecha de cobro debe estar dentro de los primeros 10 días del mes.', 16, 1);
        RETURN;
    END
Begin 
	Insert Into CobroServicioVivienda(FechaCobro,Monto,MontoAplicado,EstadoPago ,IdServicio,NumeroVivienda, IdCluster)
	Values (@FechaCobro, @Monto, @MontoAplicado,@EstadoPago,@IdServicio, @NumeroVivienda, @IdCluster);
	SELECT SCOPE_IDENTITY() AS IdCobroServicio
End;
GO

CREATE OR ALTER PROCEDURE SP_SelectAllCobroServicioVivienda
@PageIndex INT = 1,
@PageSize INT = 10,
@FechaCobroDesdeFilter DATE = NULL,
@FechaCobroHastaFilter DATE = NULL,
@ServicioFilter VARCHAR (50) = NULL, 
@NumeroViviendaFilter INT = NULL,
@ClusterFilter INT = NULL,
@EstadoPago VARCHAR(10) = NULL

AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @offset INT = (@PageIndex -1) * @pageSize;
    SELECT csv.idCobroServicio, csv.FechaCobro, csv.Monto, csv.MontoAplicado, csv.EstadoPago,csv.IdServicio, s.Nombre AS NombreServicio,v.NumeroVivienda, csv.IdCluster,c.Descripcion AS NombreCluster
    FROM CobroServicioVivienda AS csv
    INNER JOIN Servicio AS s ON csv.IdServicio = s.IdServicio
	INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda AND csv.IdCluster = v.IdCluster
	INNER JOIN Cluster AS c  ON csv.IdCluster = c.IdCluster 
    WHERE
        (@FechaCobroDesdeFilter IS NULL OR CAST( csv.FechaCobro AS DATE)>= @FechaCobroDesdeFilter)
        AND(@FechaCobroHastaFilter IS NULL OR CAST( csv.FechaCobro AS DATE)<= @FechaCobroHastaFilter)
		AND (@ServicioFilter IS NULL OR s.Nombre LIKE '%' + @ServicioFilter + '%')
		AND (@NumeroViviendaFilter IS NULL OR v.NumeroVivienda  = @NumeroViviendaFilter)
		AND (@ClusterFilter IS NULL OR c.IdCluster = @ClusterFilter )AND
        (@EstadoPago IS NULL OR 
       csv.EstadoPago LIKE + ''  + @EstadoPago + '')
       

    ORDER BY csv.idCobroServicio
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    From CobroServicioVivienda AS csv
	INNER JOIN Servicio AS s ON csv.IdServicio = s.IdServicio
	INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda AND csv.IdCluster = v.IdCluster
	INNER JOIN Cluster AS c  ON csv.IdCluster = c.IdCluster 
    WHERE
       (@FechaCobroDesdeFilter IS NULL OR CAST( csv.FechaCobro AS DATE)>= @FechaCobroDesdeFilter)
        AND(@FechaCobroHastaFilter IS NULL OR CAST( csv.FechaCobro AS DATE)<= @FechaCobroHastaFilter)
		AND (@ServicioFilter IS NULL OR s.Nombre LIKE '%' + @ServicioFilter + '%')
		AND (@NumeroViviendaFilter IS NULL OR v.NumeroVivienda  = @NumeroViviendaFilter)
		AND (@ClusterFilter IS NULL OR c.IdCluster = @ClusterFilter )AND
        (@EstadoPago IS NULL OR 
       csv.EstadoPago LIKE + ''  + @EstadoPago + '')

END;
GO
--actualiza  cobro servicio vivienda 
CREATE OR ALTER PROCEDURE SP_ActualizarCobroServicioVivienda
@idCobroServicio INT,
@FechaCobro Date,
@Monto DECIMAL,
@MontoAplicado DECIMAL,
@EstadoPago VARCHAR(10),
@IdServicio      int,
@NumeroVivienda  INT,
@IdCluster       INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM CobroServicioVivienda WHERE idCobroServicio = @idCobroServicio
    )
    BEGIN
        UPDATE CobroServicioVivienda
        SET FechaCobro = @FechaCobro,
            Monto = @Monto,
            MontoAplicado = @MontoAplicado,
			EstadoPago = @EstadoPago,
			IdServicio = @IdServicio,
			NumeroVivienda = @NumeroVivienda,
			IdCluster = @IdCluster
        WHERE idCobroServicio = @idCobroServicio;
        PRINT 'El cobro servicio ha sido actualizado correctamente.';
    END
    ELSE
    BEGIN
        RAISERROR('El cobro servicio especificado no existe.', 16, 1);
    END
END;
GO
--Buscar cobro servicio vivienda  por fecha 
CREATE OR ALTER PROCEDURE SP_BuscarCSVPorFecha
@FechaCobro date 
AS
BEGIN
	Select  FechaCobro,Monto, MontoAplicado,EstadoPago, IdServicio,NumeroVivienda, IdCluster
    FROM CobroServicioVivienda
    WHERE FechaCobro = @FechaCobro
    ORDER BY FechaCobro;
END;
GO
--buscar  cobro por servicio y numero de vivienda
CREATE OR ALTER PROCEDURE SP_BuscarCSVPorServicioVivienda 
@NumeroVivienda INT,
@IdCluster INT
AS
BEGIN
    SELECT csv.idCobroServicio, csv.FechaCobro,csv.Monto, csv.MontoAplicado,csv.EstadoPago,csv.IdServicio,csv.NumeroVivienda, csv.IdCluster,s.IdServicio, s.Nombre
    FROM CobroServicioVivienda csv
	INNER JOIN Servicio as s 
	on csv.IdServicio= s.IdServicio
    WHERE NumeroVivienda = @NumeroVivienda and IdCluster = @IdCluster
END;
GO
--buscar cobro servicio vivienda por id 
Create OR Alter Procedure SP_BuscarCobroServicioPorViviendaPorId
@idCobroServicio int
AS

Begin 
	Select  idCobroServicio, FechaCobro, Monto, MontoAplicado, EstadoPago, IdServicio, NumeroVivienda, IdCluster
	from CobroServicioVivienda
	Where  idCobroServicio = @idCobroServicio 

END;
GO
--elimina el cobro del servicio por vivienda 
CREATE OR ALTER PROCEDURE SP_EliminarCobroServicioVivienda
    @idCobroServicioVivienda INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1 FROM CobroServicioVivienda WHERE idCobroServicio = @idCobroServicioVivienda
    )
    BEGIN
        RAISERROR('El cobro del servicio de cobro no existe.', 16, 1);
        RETURN;
    END
    IF EXISTS (
        SELECT 1 FROM DetalleRecibo WHERE idCobroServicio = @idCobroServicioVivienda
    )
    BEGIN
        RAISERROR('No se puede eliminar el cobro del sevicio debido a que esta asocida a otra tabla.', 16, 1);
        RETURN;
    END
    DELETE FROM CobroServicioVivienda
    WHERE idCobroServicio = @idCobroServicioVivienda;

    PRINT 'El cobro del servicio se ha eliminado correctamente.';
END;
GO


-- 31. TABLA: DetalleRecibo


--insertar  detalle recibo 
CREATE OR ALTER PROCEDURE SP_InsertarDetalleRecibo
@IdRecibo INT,
@idCobroServicio INT,
@IdMultaVivienda INT
AS
BEGIN
	INSERT INTO DetalleRecibo(IdRecibo, idCobroServicio, IdMultaVivienda)
	VALUES (@IdRecibo, @idCobroServicio, @IdMultaVivienda)
	SELECT SCOPE_IDENTITY () AS IdDetalleRecibo
END;
GO
CREATE OR ALTER PROCEDURE SP_SelectAllDetalleRecibo
@PageIndex INT = 1,
@PageSize INT = 10,
@IdReciboFilter INT = NULL,
@IdCobroServicioFilter INT = NULL,
@IdMultaViviendaFilter INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @offset INT = (@PageIndex -1) * @PageSize;
   SELECT 
        dr.IdDetalleRecibo,dr.IdRecibo,dr.idCobroServicio,dr.IdMultaVivienda,
        ISNULL(csv.MontoAplicado, 0) AS MontoAplicado,
        per.PrimerNombre + ' ' + COALESCE (per.SegundoNombre , '') + ' ' + per.PrimerApellido + ' ' +COALESCE( per.SegundoApellido, '') AS NombreCompleto,
        v.NumeroVivienda,v.IdCluster, s.Nombre AS Concepto, C.Descripcion AS NombreCluster
    FROM DetalleRecibo AS dr
    INNER JOIN CobroServicioVivienda AS csv ON dr.idCobroServicio = csv.idCobroServicio
    INNER JOIN Servicio AS s ON csv.IdServicio = s.IdServicio
    INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda  AND csv.IdCluster = v.IdCluster
    INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
    INNER JOIN Residente AS r ON v.NumeroVivienda = r.NumeroVivienda AND V.IdCluster = R.IdCluster
    INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
     WHERE
        (@IdReciboFilter IS NULL OR dr.IdRecibo = @IdReciboFilter)
        AND (@IdCobroServicioFilter IS NULL OR dr.idCobroServicio = @IdCobroServicioFilter)
    UNION 
    SELECT 
        dr.IdDetalleRecibo,dr.IdRecibo,dr.idCobroServicio,dr.IdMultaVivienda,
        ISNULL(MV.Monto, 0) AS MontoAplicado,
        per.PrimerNombre + ' ' + COALESCE (per.SegundoNombre , '') + ' ' + per.PrimerApellido + ' ' +COALESCE( per.SegundoApellido, '') AS NombreCompleto,
        v.NumeroVivienda,v.IdCluster, TV.Nombre AS Concepto, C.Descripcion AS NombreCluster
    FROM DetalleRecibo AS dr
    INNER JOIN MultaVivienda AS MV ON dr.IdMultaVivienda = MV.IdMultaVivienda
    INNER JOIN TipoMulta AS TV  ON  MV.IdTipoMulta = TV.IdTipoMulta
    INNER JOIN Vivienda AS v ON MV.NumeroVivienda = v.NumeroVivienda  AND MV.IdCluster = v.IdCluster
    INNER JOIN Cluster AS C ON V.IdCluster = C.IdCluster
    INNER JOIN Residente AS r ON v.NumeroVivienda = r.NumeroVivienda AND V.IdCluster = R.IdCluster
    INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
     WHERE
        (@IdReciboFilter IS NULL OR dr.IdRecibo = @IdReciboFilter)        
        AND (@IdMultaViviendaFilter IS NULL OR dr.IdMultaVivienda = @IdMultaViviendaFilter)
    ORDER BY IdDetalleRecibo
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    SELECT COUNT(*) AS TotalCount
    FROM DetalleRecibo AS dr
    WHERE
        (@IdReciboFilter IS NULL OR dr.IdRecibo = @IdReciboFilter)
        AND (@IdCobroServicioFilter IS NULL OR dr.idCobroServicio = @IdCobroServicioFilter)
        AND (@IdMultaViviendaFilter IS NULL OR dr.IdMultaVivienda = @IdMultaViviendaFilter)
END;
GO
exec SP_SelectAllDetalleRecibo

go
--busca detalle recibo por Multa
CREATE OR ALTER PROCEDURE SP_BuscarDetalleReciboPorMulta
@IdMultaVivienda int 
AS
	BEGIN
		SELECT dr.IdDetalleRecibo,
		    dr.idCobroServicio,
		    dr.IdRecibo,
		    dr.IdMultaVivienda,
		    tm.Nombre AS NombreMulta,
		    per.PrimerNombre,
		    per.PrimerApellido
			FROM DetalleRecibo AS dr
			INNER JOIN MultaVivienda AS mv ON dr.IdMultaVivienda = mv.IdMultaVivienda
			INNER JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
			INNER JOIN Vivienda AS v ON mv.NumeroVivienda = v.NumeroVivienda
			INNER JOIN Residente AS r ON v.NumeroVivienda = r.NumeroVivienda
			INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
			WHERE dr.IdMultaVivienda = @IdMultaVivienda
	END;
GO
--busca detalle recibo por cobro del servicio vivienda 
CREATE OR ALTER PROCEDURE SP_BuscarDetalleReciboPorCS
@idCobroServicio int 
AS
	BEGIN
		SELECT 
			dr.IdDetalleRecibo,
			dr.IdRecibo,
			dr.idCobroServicio,
			dr.IdMultaVivienda,
			ISNULL(tm.Nombre, 'N/A') AS NombreMulta,
			per.PrimerNombre,
			per.PrimerApellido,
			v.NumeroVivienda,
			v.IdCluster,
			csv.MontoAplicado
			FROM DetalleRecibo AS dr
			INNER JOIN CobroServicioVivienda AS csv ON dr.idCobroServicio = csv.idCobroServicio
			INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda
			INNER JOIN Residente AS r ON v.NumeroVivienda = r.NumeroVivienda
			INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
			LEFT JOIN MultaVivienda AS mv ON dr.IdMultaVivienda = mv.IdMultaVivienda
			LEFT JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
			WHERE dr.idCobroServicio = @idCobroServicio
	END;
GO

--busca detalle recibo por el id, muestra la persona que pago 
CREATE OR ALTER PROCEDURE SP_BuscarDetalleReciboPorID
@IdRecibo INT 
AS
BEGIN
	SELECT dr.IdDetalleRecibo, dr.IdRecibo,
	csv.IdServicio, csv.MontoAplicado,
	s.Nombre,
	v.NumeroVivienda,v.IdCluster,
	CONCAT(per.PrimerNombre,' ' ,per.SegundoNombre,' ', per.PrimerApellido,' ', per.SegundoApellido) AS NombreCompleto,
	c.Descripcion AS NombreCluster 
	From DetalleRecibo AS dr
	INNER JOIN CobroServicioVivienda AS csv ON dr.idCobroServicio = csv.idCobroServicio
	INNER JOIN Servicio		AS s On csv.IdServicio = s.IdServicio
	INNER JOIN Vivienda AS v ON csv.NumeroVivienda = v.NumeroVivienda 
	INNER JOIN Residente AS r ON  v.NumeroVivienda = r.NumeroVivienda
	INNER JOIN Persona AS per ON r.IdPersona = per.IdPersona
	INNER JOIN Cluster AS c ON v.IdCluster = c.IdCluster
	WHERE IdRecibo = @IdRecibo
END;
GO
--actualiza el detalle del recibo 
CREATE OR ALTER PROCEDURE SP_ActulizarDetalleRecibo
@IdDetalleRecibo INT,
@IdRecibo INT, 
@idCobroServicio INT, 
@IdMultaVivienda INT
AS
BEGIN
	UPDATE DetalleRecibo
	SET IdRecibo = @IdRecibo,
		idCobroServicio = @idCobroServicio,
		IdMultaVivienda = @IdMultaVivienda
	WHERE IdDetalleRecibo = @IdDetalleRecibo

END;
GO
--elimina el detalle recibo 
CREATE OR ALTER PROCEDURE SP_EliminarDetalleRecibo
@IdDetalleRecibo INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM DetalleRecibo WHERE IdDetalleRecibo = @IdDetalleRecibo)
	BEGIN
		DELETE FROM DetalleRecibo
		WHERE IdDetalleRecibo = @IdDetalleRecibo;
		PRINT 'Detalle eliminado correctamente.';
		END
		ELSE
		BEGIN
			PRINT 'El detalle solicitado no existe.';
		END
END;
GO

CREATE OR ALTER PROCEDURE SP_ObtenerPersonasPaginado
    @PageIndex INT = 1,
    @PageSize INT = 10,
    @CuiFilter VARCHAR(30) = NULL,
    @NombreFilter VARCHAR(30) = NULL
AS
BEGIN
   

    DECLARE @Offset INT = (@PageIndex - 1) * @PageSize;

    SELECT 
        P.IdPersona, Cui, PrimerNombre, SegundoNombre, 
        PrimerApellido, SegundoApellido, Telefono, Genero, COALESCE(PR.IdPropietario, 0)
    FROM Persona AS P
    LEFT JOIN Propietario AS PR ON P.IdPersona = PR.IdPersona
    WHERE 
        (@CuiFilter IS NULL OR Cui LIKE '%' + @CuiFilter + '%')
        AND (@NombreFilter IS NULL OR 
             PrimerNombre LIKE '%' + @NombreFilter + '%' OR
             PrimerApellido LIKE '%' + @NombreFilter + '%')
    ORDER BY IdPersona
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    
    SELECT COUNT(*) AS TotalCount
    FROM Persona
    WHERE 
        (@CuiFilter IS NULL OR Cui LIKE '%' + @CuiFilter + '%')
        AND (@NombreFilter IS NULL OR 
             PrimerNombre LIKE '%' + @NombreFilter + '%' OR
             PrimerApellido LIKE '%' + @NombreFilter + '%');
END;
GO 
CREATE OR ALTER PROCEDURE SP_DetalleReciboCompleto
    @IdRecibo INT
AS
BEGIN
    SELECT 
        r.IdRecibo,
        r.FechaEmision,
        r.NumeroVivienda,
        r.IdCluster,
        CONCAT(p.PrimerNombre, ' ', p.SegundoNombre, ' ', p.PrimerApellido, ' ', p.SegundoApellido) AS NombrePropietario,
        dr.IdDetalleRecibo,
        dr.IdMultaVivienda,
        dr.idCobroServicio,
        ISNULL(csv.MontoAplicado, 0) AS MontoServicio,
        s.Nombre AS NombreServicio,
        tm.Nombre AS NombreMulta
    FROM DetalleRecibo AS dr
    INNER JOIN Recibo AS r ON dr.IdRecibo = r.IdRecibo
    INNER JOIN CobroServicioVivienda AS csv ON dr.idCobroServicio = csv.idCobroServicio
    LEFT JOIN Servicio AS s ON csv.IdServicio = s.IdServicio
    LEFT JOIN MultaVivienda AS mv ON dr.IdMultaVivienda = mv.IdMultaVivienda
    LEFT JOIN TipoMulta AS tm ON mv.IdTipoMulta = tm.IdTipoMulta
    INNER JOIN Vivienda AS v ON r.NumeroVivienda = v.NumeroVivienda AND r.IdCluster = v.IdCluster
    INNER JOIN Residente AS re ON v.NumeroVivienda = re.NumeroVivienda AND v.IdCluster = re.IdCluster
    INNER JOIN Persona AS p ON re.IdPersona = p.IdPersona
    WHERE r.IdRecibo = @IdRecibo
    ORDER BY dr.IdDetalleRecibo;
END;
GO
CREATE OR ALTER PROCEDURE SP_ObtenerPropietarioPorViviendaYCluster
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT TOP 1
        CONCAT(p.PrimerNombre, ' ', p.SegundoNombre, ' ', p.PrimerApellido, ' ', p.SegundoApellido) AS NombreCompleto
    FROM Vivienda v
    INNER JOIN Residente r ON v.NumeroVivienda = r.NumeroVivienda AND v.IdCluster = r.IdCluster
    INNER JOIN Persona p ON r.IdPersona = p.IdPersona
    WHERE v.NumeroVivienda = @NumeroVivienda
      AND v.IdCluster = @IdCluster
END;
-- 32. TABLA: DocumentoPersona

GO
CREATE OR ALTER PROCEDURE SP_ActualizarDocumentoPersona
@IdTipoDocumento INT,
@IdPersona INT,
@NumeroDocumento INT,
@Observaciones VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS (SELECT 1 FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
BEGIN
RAISERROR('No existe un documento con esos datos para actualizar.', 16, 1)
RETURN
END

UPDATE DocumentoPersona
SET NumeroDocumento = @NumeroDocumento,
Observaciones = @Observaciones
WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarDocumentoPersonaPorId
@IdTipoDocumento INT,
@IdPersona INT
AS
BEGIN

SELECT dp.NumeroDocumento, dp.Observaciones, td.Nombre AS TipoDocumento, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS Persona FROM DocumentoPersona dp
INNER JOIN TipoDocumento td ON dp.IdTipoDocumento = td.IdTipoDocumento
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
WHERE dp.IdTipoDocumento = @IdTipoDocumento AND dp.IdPersona = @IdPersona;
END;

GO
CREATE OR ALTER PROCEDURE SP_BuscarDocumentoPorNumero
@NumeroDocumento INT
AS
BEGIN
SELECT dp.NumeroDocumento, dp.Observaciones, td.Nombre AS TipoDocumento, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS Persona FROM DocumentoPersona dp
INNER JOIN TipoDocumento td ON dp.IdTipoDocumento = td.IdTipoDocumento
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona 
WHERE dp.NumeroDocumento = @NumeroDocumento;
END

GO
CREATE OR ALTER PROCEDURE SP_BuscarDocumentoPorTipo
@IdTipoDocumento INT
AS
BEGIN

SELECT dp.NumeroDocumento, dp.Observaciones, CONCAT(p.PrimerNombre, ' ', p.PrimerApellido) AS Persona FROM DocumentoPersona dp
INNER JOIN Persona p ON dp.IdPersona = p.IdPersona
WHERE dp.IdTipoDocumento = @IdTipoDocumento
END

EXEC SP_BuscarDocumentoPorTipo
@IdTipoDocumento = 1

GO
CREATE OR ALTER PROCEDURE SP_EliminarDocumentoPersona
@IdTipoDocumento INT,
@IdPersona INT
AS
BEGIN
SET NOCOUNT ON

IF NOT EXISTS (SELECT 1 FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
BEGIN
RAISERROR('El documento no existe o ya fue eliminado.', 16, 1)
RETURN
END

DELETE FROM DocumentoPersona WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona
END

GO
CREATE OR ALTER PROCEDURE SP_InsertarDocumentoPersona
    @NumeroDocumento INT,
    @IdTipoDocumento INT,
    @IdPersona INT,
    @Observaciones VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Persona WHERE IdPersona = @IdPersona)
    BEGIN
        RAISERROR('La persona no existe en la tabla Persona.', 16, 1);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento)
    BEGIN
        RAISERROR('Este tipo de documento no existe.', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM DocumentoPersona 
               WHERE IdTipoDocumento = @IdTipoDocumento AND IdPersona = @IdPersona)
    BEGIN
        RAISERROR('Ya existe un documento para esta persona y tipo.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM DocumentoPersona
               WHERE NumeroDocumento = @NumeroDocumento AND IdTipoDocumento = @IdTipoDocumento)
    BEGIN
        RAISERROR('Ya existe un documento con ese número para este tipo.', 16, 1);
        RETURN;
    END

    INSERT INTO DocumentoPersona (NumeroDocumento, IdTipoDocumento, IdPersona, Observaciones)
    VALUES (@NumeroDocumento, @IdTipoDocumento, @IdPersona, @Observaciones);
END

GO

-- PROCEDIMIENTO ALMACENADO PARA ACUMULACIÓN DE DEUDAS

go
    ----Tabla de DetallePago
CREATE OR ALTER PROCEDURE SP_InsertarDetallePago
    @Monto decimal,
    @idTipoPago int,
    @IdPago int,
    @Referencia varchar(50) = NULL  
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DetallePago
        (Monto, idTipoPago, IdPago, Referencia)
    VALUES
        (@Monto, @idTipoPago, @IdPago, @Referencia);
END
GO

CREATE OR ALTER  PROCEDURE SP_ActualizarDetallePago
    @IdDetallePago int, 
    @Monto decimal,
    @idTipoPago int,
    @IdPago int,
    @Referencia varchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE DetallePago
    SET
        Monto = @Monto,
        idTipoPago = @idTipoPago,
        IdPago = @IdPago,
        Referencia = @Referencia
    WHERE
        IdDetallePago = @IdDetallePago; 
END
GO
CREATE  OR ALTER PROCEDURE SP_BuscarDetallePago_PorID
    @IdDetallePago int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM 
        DetallePago
    WHERE 
        IdDetallePago = @IdDetallePago;
END
GO
CREATE  OR ALTER PROCEDURE SP_BuscarDetallePagoPorMontoYTipoPago
    @MontoMinimo decimal,
    @idTipoPago int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        IdDetallePago, Monto, Referencia
    FROM 
        DetallePago
    WHERE 
        Monto > @MontoMinimo 
        AND idTipoPago = @idTipoPago
    ORDER BY 
        Monto DESC; 
END
GO
CREATE OR ALTER  PROCEDURE SP_BuscarDetallePagoPorReferencia
    @Referencia varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM 
        DetallePago
    WHERE 
        Referencia LIKE '%'+ @Referencia + '%';
END
GO



CREATE OR ALTER  PROCEDURE SP_EliminarDetallePago
    @IdDetallePago int 
AS
BEGIN
    SET NOCOUNT ON;
        DELETE FROM DetallePago
        WHERE IdDetallePago = @IdDetallePago;

        IF @@ROWCOUNT = 0
        BEGIN
            PRINT 'No se encontró ningún registro con el IdDetallePago especificado.';
        END
        ELSE
        BEGIN
            PRINT 'Registro eliminado exitosamente.';
        END
END
GO
CREATE OR ALTER PROCEDURE SP_EstadoDeCuenta
@AnioFilter INT = NULL,
@NumeroVivienda INT = NULL,
@ClusterFilter int = NULL,
@MesFilter VARCHAR(15) = NULL
AS
BEGIN
	SELECT csv.idCobroServicio, DATENAME(MONTH, csv.FechaCobro) AS MesCobro , YEAR( csv.FechaCobro) AS Año, csv.Monto, COALESCE(csv.MontoAplicado, 0) AS MontoPagado, csv.EstadoPago, csv.IdServicio, csv.NumeroVivienda, csv.IdCluster,
			s.Nombre
	FROM CobroServicioVivienda AS csv
		INNER JOIN Servicio  AS s ON csv.IdServicio = s.IdServicio
		WHERE 
		(@AnioFilter IS NULL OR
		YEAR( csv.FechaCobro) =  @AnioFilter )
		AND(@NumeroVivienda IS NULL OR
		 csv.NumeroVivienda = @NumeroVivienda)
		AND(@ClusterFilter  IS NULL OR
		 csv.IdCluster =  @ClusterFilter)
		AND(@MesFilter IS NULL OR 
		 DATENAME(MONTH, csv.FechaCobro) = @MesFilter)
		--where NumeroVivienda = 1 and IdCluster= 1

	SELECT YEAR( csv.FechaCobro) AS Anio, SUM(csv.Monto) AS TotalCobrado,
		 SUM(COALESCE(csv.MontoAplicado, 0)) AS TotalPagado
	FROM CobroServicioVivienda AS csv
		--where NumeroVivienda = 1 and IdCluster= 1
		WHERE 
		(@AnioFilter IS NULL OR
		YEAR( csv.FechaCobro) =  @AnioFilter )
		AND(@NumeroVivienda IS NULL OR
		 csv.NumeroVivienda = @NumeroVivienda)
		AND(@ClusterFilter  IS NULL OR
		 csv.IdCluster =  @ClusterFilter)
		AND(@MesFilter IS NULL OR 
		 DATENAME(MONTH, csv.FechaCobro) = @MesFilter)
		GROUP BY NumeroVivienda , IdCluster, YEAR( csv.FechaCobro)
END;
--GO