--GARITA
CREATE OR ALTER PROCEDURE ActualizarGarita
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

CREATE OR ALTER PROCEDURE ConsultarPorClusterGarita
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorIdGarita
    @IdGarita INT
AS
BEGIN
    SELECT * FROM Garita WHERE IdGarita = @IdGarita
END;

GO

CREATE OR ALTER PROCEDURE ConsultarTodasGarita
AS
BEGIN
    SELECT * FROM Garita
END;

GO

CREATE OR ALTER PROCEDURE EliminarGarita
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

CREATE OR ALTER PROCEDURE InsertarGarita
    @IdCluster INT
AS
BEGIN
    INSERT INTO Garita (IdCluster)
    VALUES (@IdCluster)
    
    RETURN SCOPE_IDENTITY()
END;

GO

-- LINEA
CREATE OR ALTER PROCEDURE SPActualizarLinea
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

CREATE OR ALTER PROCEDURE SPConsultarPorDescripcionLinea
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Linea WHERE Descripcion LIKE '%' + @Descripcion + '%'
END;

GO

CREATE OR ALTER PROCEDURE SPConsultarPorIdLinea
    @IdLinea INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdLinea = @IdLinea
END;

GO

CREATE OR ALTER PROCEDURE SPConsultarPorMarcaLinea
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Linea WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SPEliminarLinea
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

CREATE OR ALTER PROCEDURE SPInsertarLinea
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
CREATE OR ALTER PROCEDURE SPActualizarMarca
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

CREATE OR ALTER PROCEDURE SPConsultarPorDescripcionMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    SELECT * FROM Marca WHERE Descripcion = @Descripcion
END;

GO

CREATE OR ALTER PROCEDURE SPConsultarPorIdMarca
    @IdMarca INT
AS
BEGIN
    SELECT * FROM Marca WHERE IdMarca = @IdMarca
END;

GO

CREATE OR ALTER PROCEDURE SPEliminarMarca
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

CREATE OR ALTER PROCEDURE SPInsertarMarca
    @Descripcion VARCHAR(50)
AS
BEGIN
    INSERT INTO Marca (Descripcion)
    VALUES (@Descripcion)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--REGISTRO ACCESO
CREATE OR ALTER PROCEDURE ActualizarRegistroAccesos
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

CREATE OR ALTER PROCEDURE ConsultarPorFechaIngresoRegistroAccesos
    @Fecha DATE
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE CAST(FechaIngreso AS DATE) = @Fecha
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorIdRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorVehiculoRegistroAccesos
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM RegistroAccesos WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE EliminarRegistroAccesos
    @IdRegistroAcceso INT
AS
BEGIN
    DELETE FROM RegistroAccesos WHERE IdAcceso = @IdRegistroAcceso
    
    RETURN @@ROWCOUNT
END;

GO

CREATE OR ALTER PROCEDURE InsertarRegistroAccesos
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
CREATE PROCEDURE ActualizarTipoDoc
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

CREATE OR ALTER PROCEDURE ConsultarPorIdTipoDoc
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE PROCEDURE ConsultarPorNombreTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    SELECT * FROM TipoDocumento WHERE Nombre = @Nombre
END;

GO

CREATE OR ALTER PROCEDURE ConsultarTodosTipoDoc
AS
BEGIN
    SELECT * FROM TipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE EliminarTipoDoc
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

CREATE OR ALTER PROCEDURE InsertarTipoDoc
    @Nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO TipoDocumento (Nombre)
    VALUES (@Nombre)
    
    RETURN SCOPE_IDENTITY()
END;

GO

--VEHICULO
CREATE OR ALTER PROCEDURE ActualizarVehiculo
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

CREATE OR ALTER PROCEDURE ConsultarPorIdVehiculo
    @IdVehiculo INT
AS
BEGIN
    SELECT * FROM Vehiculo WHERE IdVehiculo = @IdVehiculo
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorPlacaVehiculo
    @Placa VARCHAR(10)
AS
BEGIN
    SELECT * FROM Vehiculo WHERE Placa = @Placa
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorViviendaVehiculo
    @NumeroVivienda INT,
    @IdCluster INT
AS
BEGIN
    SELECT * FROM Vehiculo 
    WHERE NumeroVivienda = @NumeroVivienda AND IdCluster = @IdCluster
END;

GO

CREATE OR ALTER PROCEDURE EliminarVehiculo
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

CREATE OR ALTER PROCEDURE InsertarVehiculo
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
CREATE OR ALTER PROCEDURE ActualizarVisitante
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

CREATE OR ALTER PROCEDURE ConsultarPorDocumentoVisitante
    @NumeroDocumento VARCHAR(20)
AS
BEGIN
    SELECT * FROM Visitante WHERE NumeroDocumento = @NumeroDocumento
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorIdVisitante
    @IdVisitante INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdVisitante = @IdVisitante
END;

GO

CREATE OR ALTER PROCEDURE ConsultarPorTipoDocumentoVisitante
    @IdTipoDocumento INT
AS
BEGIN
    SELECT * FROM Visitante WHERE IdTipoDocumento = @IdTipoDocumento
END;

GO

CREATE OR ALTER PROCEDURE EliminarVisitante
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

CREATE OR ALTER PROCEDURE InsertarVisitante
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