BEGIN TRANSACTION;
BEGIN TRY

    -- ==============================================================================
    -- 1. ELIMINACIÓN DE DATOS TRANSACCIONALES DE ALTO NIVEL
    --    (Dependientes de múltiples tablas y que deben borrarse primero)
    -- ==============================================================================

    DELETE FROM RegistroAccesos;        -- Depende de Vehiculo, Garita, Visitante, Residente, Empleado
    DELETE FROM VehiculoProhibido;      -- Depende de Vehiculo
    DELETE FROM AsignacionTurno;        -- Depende de Empleado, Turno
    DELETE FROM DetalleRecibo;          -- Depende de Recibo, CobroServicioVivienda, MultaVivienda
    DELETE FROM DetallePago;            -- Depende de Pago, TipoPago
    DELETE FROM Recibo;                 -- Depende de Pago, Vivienda
    DELETE FROM CobroServicioVivienda;  -- Depende de Servicio, Vivienda
    DELETE FROM MultaVivienda;          -- Depende de TipoMulta, Vivienda

    -- ==============================================================================
    -- 2. ELIMINACIÓN DE DATOS INTERMEDIOS
    --    (Tablas maestras con fuertes dependencias de Persona o Vivienda)
    -- ==============================================================================
    
    DELETE FROM MiembroJuntaDirectiva;  -- Depende de JuntaDirectiva, Propietario
    DELETE FROM JuntaDirectiva;         -- Depende de Cluster
    DELETE FROM Vehiculo;               -- Depende de Vivienda, Linea
    DELETE FROM Residente;              -- Depende de Persona, Vivienda
    DELETE FROM Vivienda;               -- Depende de Cluster, TipoVivienda, Propietario
    DELETE FROM Propietario;            -- Depende de Persona
    DELETE FROM Empleado;               -- Depende de Persona
    DELETE FROM PersonaNoGrata;         -- Depende de Persona
    DELETE FROM DocumentoPersona;       -- Depende de Persona, TipoDocumento
    DELETE FROM Visitante;              -- Depende de TipoDocumento
    DELETE FROM Garita;                 -- Depende de Cluster
    DELETE FROM Cluster;                -- Depende de Residencial
    DELETE FROM Pago;                   -- No tiene FK entrantes

    -- ==============================================================================
    -- 3. ELIMINACIÓN DE DATOS MAESTROS Y CATÁLOGOS BASE
    --    (Deben borrarse casi al final porque otras tablas dependen de ellas)
    -- ==============================================================================
    
    DELETE FROM Persona;                -- Debe borrarse después de Propietario, Residente, Empleado, PersonaNoGrata
    DELETE FROM Linea;                  -- Depende de Marca
    DELETE FROM TipoVivienda;
    DELETE FROM TipoMulta;
    DELETE FROM Servicio;
    DELETE FROM PuestoJuntaDirectiva;
    DELETE FROM PuestoEmpleado;
    DELETE FROM Turno;
    DELETE FROM TipoDocumento;
    DELETE FROM TipoPago;
    DELETE FROM Marca;
    DELETE FROM Residencial;

    -- ==============================================================================
    -- 4. REINICIO DE CONTADORES (IDENTITY)
    --    (Asegura que las inserciones empiecen de nuevo en ID = 1)
    -- ==============================================================================

    -- Tablas Transaccionales
    DBCC CHECKIDENT (RegistroAccesos, RESEED, 0);
    DBCC CHECKIDENT (VehiculoProhibido, RESEED, 0);
    DBCC CHECKIDENT (AsignacionTurno, RESEED, 0);
    DBCC CHECKIDENT (DetalleRecibo, RESEED, 0);
    DBCC CHECKIDENT (DetallePago, RESEED, 0);
    DBCC CHECKIDENT (Recibo, RESEED, 0);
    DBCC CHECKIDENT (CobroServicioVivienda, RESEED, 0);
    DBCC CHECKIDENT (MultaVivienda, RESEED, 0);
    DBCC CHECKIDENT (Pago, RESEED, 0);

    -- Tablas Principales
    DBCC CHECKIDENT (Persona, RESEED, 0);
    DBCC CHECKIDENT (Propietario, RESEED, 0);
    DBCC CHECKIDENT (Residente, RESEED, 0);
    DBCC CHECKIDENT (Empleado, RESEED, 0);
    DBCC CHECKIDENT (JuntaDirectiva, RESEED, 0);
    DBCC CHECKIDENT (MiembroJuntaDirectiva, RESEED, 0);
    DBCC CHECKIDENT (Vehiculo, RESEED, 0);
    DBCC CHECKIDENT (Visitante, RESEED, 0);
    DBCC CHECKIDENT (PersonaNoGrata, RESEED, 0);
    
    -- Tablas de Catálogo
    DBCC CHECKIDENT (Residencial, RESEED, 0);
    DBCC CHECKIDENT (Cluster, RESEED, 0);
    DBCC CHECKIDENT (Garita, RESEED, 0);
    DBCC CHECKIDENT (TipoVivienda, RESEED, 0);
    DBCC CHECKIDENT (Servicio, RESEED, 0);
    DBCC CHECKIDENT (TipoMulta, RESEED, 0);
    DBCC CHECKIDENT (TipoPago, RESEED, 0);
    DBCC CHECKIDENT (PuestoJuntaDirectiva, RESEED, 0);
    DBCC CHECKIDENT (PuestoEmpleado, RESEED, 0);
    DBCC CHECKIDENT (Turno, RESEED, 0);
    DBCC CHECKIDENT (TipoDocumento, RESEED, 0);
    DBCC CHECKIDENT (Marca, RESEED, 0);
    DBCC CHECKIDENT (Linea, RESEED, 0);

    COMMIT TRANSACTION;
    PRINT '¡Base de datos limpiada! Todos los datos han sido eliminados y los contadores (IDENTITY) han sido reiniciados.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'ERROR: No se pudieron eliminar los datos. Revise los mensajes de error.';
    THROW;
END CATCH
GO