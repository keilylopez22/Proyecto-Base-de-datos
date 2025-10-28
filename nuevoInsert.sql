BEGIN TRY
DECLARE @Propietarios2 TABLE (IdPropietario INT, IdPersona INT);
    BEGIN TRANSACTION;

    -- ==============================================================================
    -- 1. INSERCIÓN DE DATOS MAESTROS (Catálogos)
    -- ==============================================================================
    DECLARE @ResidencialId INT;
    INSERT INTO Residencial (Nombre) VALUES ('Residenciales San Francisco');
    SET @ResidencialId = SCOPE_IDENTITY();

    -- Clusters
    DECLARE @ClusterA INT, @ClusterB INT, @ClusterC INT, @ClusterD INT, @ClusterE INT, @ClusterF INT;
    INSERT INTO Cluster (Descripcion, IdResidencial) VALUES 
        ('Andalucía', @ResidencialId), ('Bernarda', @ResidencialId), ('Catalina', @ResidencialId), 
        ('Diana I', @ResidencialId), ('Diana II', @ResidencialId), ('Esmeralda', @ResidencialId);

    -- CORRECCIÓN: Asignación de IDs de Clusters (Se realiza individualmente para evitar el error de sintaxis)
    SELECT @ClusterA = IdCluster FROM Cluster WHERE Descripcion = 'Andalucía';
    SELECT @ClusterB = IdCluster FROM Cluster WHERE Descripcion = 'Bernarda';
    SELECT @ClusterC = IdCluster FROM Cluster WHERE Descripcion = 'Catalina';
    SELECT @ClusterD = IdCluster FROM Cluster WHERE Descripcion = 'Diana I';
    SELECT @ClusterE = IdCluster FROM Cluster WHERE Descripcion = 'Diana II';
    SELECT @ClusterF = IdCluster FROM Cluster WHERE Descripcion = 'Esmeralda';


    -- Garitas
    INSERT INTO Garita (IdCluster) VALUES (@ClusterA), (@ClusterB), (@ClusterC), (@ClusterD), (@ClusterE), (@ClusterF);

    -- Tipos de Vivienda
    DECLARE @CasaGrande INT, @CasaMedia INT, @CasaPequeña INT;
    INSERT INTO TipoVivienda (Descripcion, NumeroHabitaciones, SuperficieTotal, NumeroPisos, Estacionamiento)
    VALUES 
        ('Casa Grande', 4, 200, 2, 1), ('Casa Media', 3, 150, 2, 1), ('Casa Pequeña', 2, 100, 1, 0);

    -- CORRECCIÓN: Asignación de IDs de Tipos de Vivienda
    SELECT @CasaGrande = IdTipoVivienda FROM TipoVivienda WHERE Descripcion = 'Casa Grande';
    SELECT @CasaMedia = IdTipoVivienda FROM TipoVivienda WHERE Descripcion = 'Casa Media';
    SELECT @CasaPequeña = IdTipoVivienda FROM TipoVivienda WHERE Descripcion = 'Casa Pequeña';


    -- Servicios
    DECLARE @Agua INT, @Jardin INT, @Seguridad INT, @Admin INT;
    INSERT INTO Servicio (Nombre, Tarifa) VALUES 
        ('Servicio de Agua', 210.00), ('Servicio de Jardinería y ornato', 80.00), ('Servicio de seguridad', 115.00), ('Administración', 75.00);

    -- CORRECCIÓN: Asignación de IDs de Servicios
    SELECT @Agua = IdServicio FROM Servicio WHERE Nombre = 'Servicio de Agua';
    SELECT @Jardin = IdServicio FROM Servicio WHERE Nombre = 'Servicio de Jardinería y ornato';
    SELECT @Seguridad = IdServicio FROM Servicio WHERE Nombre = 'Servicio de seguridad';
    SELECT @Admin = IdServicio FROM Servicio WHERE Nombre = 'Administración';


    -- Multas
    DECLARE @MultaMascota INT, @MultaDesorden INT, @MultaAgua INT;
    INSERT INTO TipoMulta (Nombre, Monto) VALUES 
        ('Desechos de mascotas', 200.00), ('Desorden', 175.00), ('Exceso de consumo de agua', 300.00);

    -- CORRECCIÓN: Asignación de IDs de Multas
    SELECT @MultaMascota = IdTipoMulta FROM TipoMulta WHERE Nombre = 'Desechos de mascotas';
    SELECT @MultaDesorden = IdTipoMulta FROM TipoMulta WHERE Nombre = 'Desorden';
    SELECT @MultaAgua = IdTipoMulta FROM TipoMulta WHERE Nombre = 'Exceso de consumo de agua';


    -- Tipos de Pago
    DECLARE @Efectivo INT, @Transferencia INT;
    INSERT INTO TipoPago (Nombre, Descripcion) VALUES 
        ('Efectivo', 'Pago en efectivo'), ('Transferencia', 'Transferencia bancaria');

    -- CORRECCIÓN: Asignación de IDs de Tipos de Pago
    SELECT @Efectivo = idTipoPago FROM TipoPago WHERE Nombre = 'Efectivo';
    SELECT @Transferencia = idTipoPago FROM TipoPago WHERE Nombre = 'Transferencia';

    -- Puestos de Junta Directiva
    DECLARE @Presidente INT;
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion) VALUES ('Presidente', 'Máxima autoridad');
    SELECT @Presidente = idPuesto FROM PuestoJuntaDirectiva WHERE Nombre = 'Presidente';

    -- Puestos de Empleado
    DECLARE @Administrador INT, @Guardia INT;
    INSERT INTO PuestoEmpleado (Nombre, Descripcion) VALUES ('Administrador', 'Personal de oficina'), ('Guardia', 'Seguridad');
    
    -- CORRECCIÓN: Asignación de IDs de Puestos de Empleado
    SELECT @Administrador = IdPuestoEmpleado FROM PuestoEmpleado WHERE Nombre = 'Administrador';
    SELECT @Guardia = IdPuestoEmpleado FROM PuestoEmpleado WHERE Nombre = 'Guardia';

    -- Turnos
    DECLARE @Matutino INT;
    INSERT INTO Turno (Descripcion, HoraInicio, HoraFin) VALUES ('Matutino', '06:00:00', '14:00:00');
    SELECT @Matutino = IdTurno FROM Turno WHERE Descripcion = 'Matutino';

    -- Tipos de Documento
    DECLARE @DPI INT;
    INSERT INTO TipoDocumento (Nombre) VALUES ('DPI');
    SELECT @DPI = IdTipoDocumento FROM TipoDocumento WHERE Nombre = 'DPI';

    -- Marcas y Líneas
    DECLARE @Toyota INT, @Honda INT;
    INSERT INTO Marca (Descripcion) VALUES ('Toyota'), ('Honda');
    
    -- CORRECCIÓN: Asignación de IDs de Marcas
    SELECT @Toyota = IdMarca FROM Marca WHERE Descripcion = 'Toyota';
    SELECT @Honda = IdMarca FROM Marca WHERE Descripcion = 'Honda';

    DECLARE @Corolla INT, @Civic INT;
    INSERT INTO Linea (Descripcion, IdMarca) VALUES ('Corolla', @Toyota), ('Civic', @Honda);
    
    -- CORRECCIÓN: Asignación de IDs de Líneas
    SELECT @Corolla = IdLinea FROM Linea WHERE Descripcion = 'Corolla' AND IdMarca = @Toyota;
    SELECT @Civic = IdLinea FROM Linea WHERE Descripcion = 'Civic' AND IdMarca = @Honda;


    -- ==============================================================================
    -- 2. PERSONAS, PROPIETARIOS, DOCUMENTOS (Integridad Persona -> DocumentoPersona)
    -- ==============================================================================
    DECLARE @Personas TABLE (IdPersona INT, Cui VARCHAR(30));
    INSERT INTO Persona (Cui, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono, Genero, FechaNacimiento, EstadoCivil)
    OUTPUT inserted.IdPersona, inserted.Cui INTO @Personas
    VALUES 
        ('09072321839', 'Keily',     NULL,       'Lopez',    'Hernandez', '40338234', 'F', '2002-03-18', 'Soltero'),
        ('290289065102', 'Cristhian', 'Eduardo',  'Lopez',    'Lemus',     '55123402', 'M', '1998-06-15', 'Casado'),
        ('290371056103', 'Delmi',     NULL,       'Maria',    'Fajardo',   '55123403', 'F', '2000-11-22', 'Soltero'),
        ('290460345104', 'Cristian',  'Eduardo',  'Chamo',    'Morales',   '55123404', 'M', '1995-09-05', 'Casado'),
        ('290558934105', 'Ana',       'Laura',    'Oliva',    NULL,        '55123405', 'F', '2001-12-30', 'Soltero'),
        ('290647823106', 'Ergil',     'Isaias',   'Cardenas', 'Cruz',      '55123406', 'M', '1998-06-25', 'Casado'),
        ('290736712107', 'Fredy',     NULL,       'Cardona',  'Montenegro','55123407', 'M', '2000-11-20', 'Soltero'),
        ('290825601108', 'Fernando',  'Jose',     'Carranza', 'Cabrera',   '55123408', 'M', '1995-09-15', 'Casado'),
        ('290914590109', 'Ludin',     'Eduardo',  'Carranza', 'Guerra',    '55123409', 'M', '2001-12-28', 'Soltero'),
        ('291003489110', 'Diego',     'Alexander','Contreras','Duarte',    '55123410', 'M', '1998-06-10', 'Casado'),
        ('291192378111', 'Ricardo',   'Enrrique', 'Hernandez','Chavez',    '55123411', 'M', '2000-11-25', 'Soltero'),
        ('291281267112', 'Luis',      'Carlos',   'Lima',     'Perez',     '55123412', 'M', '1995-09-10', 'Casado'),
        ('291370156113', 'Dereck',    'Leonel',   'Marmol',   'Salguero',  '55123413', 'M', '2001-12-25', 'Soltero'),
        ('291459045114', 'Sinthia',   'Celeste',  'Orellana', 'Galeano',   '55123414', 'F', '1998-06-05', 'Casado'),
        ('291548934115', 'Daniel',    'Alexander','Ortiz',    'Cabrera',   '55123415', 'M', '2000-11-15', 'Soltero'),
        ('291637823116', 'Astrid',    'Mileidy',  'Peña',     'Polanco',   '55123416', 'F', '1995-09-20', 'Casado'),
        ('291726712117', 'Maria',     'Jose',     'Del Carmen','Portillo',  '55123417', 'F', '2001-12-20', 'Soltero'),
        ('291815601118', 'Enma',      'Leticia',  'Ramirez',  'Castro',    '55123418', 'F', '1998-06-01', 'Casado'),
        ('291904590119', 'Aura',      'Lucia',    'Snadoval', 'Pivaral',   '55123419', 'F', '2000-11-10', 'Soltero'),
        ('292093489120', 'Andreina',  'Jannin',   'Ulloa',    'Tellez',    '55123420', 'F', '1995-09-25', 'Casado');
        
    -- Asignación de IDs de Personas
    DECLARE @IdPersonaKeily INT = (SELECT IdPersona FROM @Personas WHERE Cui = '09072321839');
    DECLARE @IdPersonaCristhian INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290289065102');
    DECLARE @IdPersonaRicardo INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291192378111');
    DECLARE @IdPersonaAstrid INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291637823116');
    DECLARE @IdPersonaMaria INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291726712117');

    -- DocumentoPersona (Usando los últimos 4 dígitos del CUI para cumplir con el tipo INT)
    INSERT INTO DocumentoPersona (NumeroDocumento, Observaciones, IdPersona, IdTipoDocumento)
    SELECT 
        CAST(SUBSTRING(Cui, LEN(Cui) - 3, 4) AS INT), 
        'DPI de Propietario', 
        IdPersona, 
        @DPI 
    FROM @Personas 
    WHERE IdPersona IN (@IdPersonaKeily, @IdPersonaCristhian);

    -- Propietarios (Solo Keily y Cristhian)
    DECLARE @Propietarios TABLE (IdPropietario INT, IdPersona INT);
    INSERT INTO Propietario (Estado, IdPersona) 
    OUTPUT inserted.IdPropietario, inserted.IdPersona INTO @Propietarios
    SELECT 'ACTIVO', IdPersona FROM @Personas WHERE IdPersona IN (@IdPersonaKeily, @IdPersonaCristhian);
    DECLARE @IdPropKeily INT = (SELECT IdPropietario FROM @Propietarios WHERE IdPersona = @IdPersonaKeily);
    DECLARE @IdPropCristhian INT = (SELECT IdPropietario FROM @Propietarios WHERE IdPersona = @IdPersonaCristhian);

    -- ==============================================================================
    -- 3. VIVIENDAS, RESIDENTES Y EMPLEADOS
    -- ==============================================================================
  
    INSERT INTO Propietario (Estado, IdPersona)
    SELECT 'ACTIVO', IdPersona FROM @Personas WHERE Cui IN (
        '09072321839', '290289065102', '290371056103', '290460345104', '290558934105',
        '290647823106', '290736712107', '290825601108', '290914590109', '291003489110'
    );
    INSERT INTO @Propietarios2 (IdPropietario, IdPersona)
    SELECT IdPropietario, IdPersona FROM Propietario;

    -- Viviendas (420 en total)
    DECLARE @i2 INT = 1;
    WHILE @i2 <= 90 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterA, @CasaGrande, NULL); SET @i2 += 1; END
    SET @i2 = 1;
    WHILE @i2 <= 88 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterB, @CasaMedia, NULL); SET @i2 += 1; END
    SET @i2 = 1;
    WHILE @i2 <= 98 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterC, @CasaPequeña, NULL); SET @i2 += 1; END
    SET @i2 = 1;
    WHILE @i2 <= 35 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterD, @CasaPequeña, NULL); SET @i2 += 1; END
    SET @i2 = 1;
    WHILE @i2 <= 35 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterE, @CasaPequeña, NULL); SET @i2 += 1; END
    SET @i2 = 1;
    WHILE @i2 <= 74 BEGIN INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario) VALUES (@i2, @ClusterF, @CasaMedia, NULL); SET @i2 += 1; END

    -- Asignar propietarios a las primeras 10 viviendas
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '09072321839')) WHERE NumeroVivienda = 1 AND IdCluster = @ClusterA;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290289065102')) WHERE NumeroVivienda = 2 AND IdCluster = @ClusterA;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290371056103')) WHERE NumeroVivienda = 3 AND IdCluster = @ClusterA;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290460345104')) WHERE NumeroVivienda = 1 AND IdCluster = @ClusterB;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290558934105')) WHERE NumeroVivienda = 2 AND IdCluster = @ClusterB;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290647823106')) WHERE NumeroVivienda = 3 AND IdCluster = @ClusterB;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290736712107')) WHERE NumeroVivienda = 1 AND IdCluster = @ClusterC;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290825601108')) WHERE NumeroVivienda = 2 AND IdCluster = @ClusterC;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '290914590109')) WHERE NumeroVivienda = 3 AND IdCluster = @ClusterC;
    UPDATE Vivienda SET IdPropietario = (SELECT TOP(1) IdPropietario FROM @Propietarios2 WHERE IdPersona = (SELECT IdPersona FROM @Personas WHERE Cui = '291003489110')) WHERE NumeroVivienda = 4 AND IdCluster = @ClusterC;

    -- Residentes (15 residentes: 10 propietarios + 5 inquilinos)
    DECLARE @IdPersonaKeily2 INT = (SELECT IdPersona FROM @Personas WHERE Cui = '09072321839');
    DECLARE @IdPersonaCristhian2 INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290289065102');
    DECLARE @IdPersonaDelmi INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290371056103');
    DECLARE @IdPersonaCristian INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290460345104');
    DECLARE @IdPersonaAna INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290558934105');
    DECLARE @IdPersonaErgil INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290647823106');
    DECLARE @IdPersonaFredy INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290736712107');
    DECLARE @IdPersonaFernando INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290825601108');
    DECLARE @IdPersonaLudin INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290914590109');
    DECLARE @IdPersonaDiego INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291003489110');
    DECLARE @IdPersonaRicardo2 INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291192378111');
    DECLARE @IdPersonaLuis INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291281267112');
    DECLARE @IdPersonaDereck INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291370156113');
    DECLARE @IdPersonaSinthia INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291459045114');
    DECLARE @IdPersonaDaniel INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291548934115');

    INSERT INTO Residente (IdPersona, NumeroVivienda, IdCluster, EsInquilino, Estado)
    VALUES 
        (@IdPersonaKeily2, 1, @ClusterA, 0, 'ACTIVO'),
        (@IdPersonaCristhian2, 2, @ClusterA, 0, 'ACTIVO'),
        (@IdPersonaDelmi, 3, @ClusterA, 0, 'ACTIVO'),
        (@IdPersonaCristian, 1, @ClusterB, 0, 'ACTIVO'),
        (@IdPersonaAna, 2, @ClusterB, 0, 'ACTIVO'),
        (@IdPersonaErgil, 3, @ClusterB, 0, 'ACTIVO'),
        (@IdPersonaFredy, 1, @ClusterC, 0, 'ACTIVO'),
        (@IdPersonaFernando, 2, @ClusterC, 0, 'ACTIVO'),
        (@IdPersonaLudin, 3, @ClusterC, 0, 'ACTIVO'),
        (@IdPersonaDiego, 4, @ClusterC, 0, 'ACTIVO'),
        (@IdPersonaRicardo2, 1, @ClusterD, 1, 'ACTIVO'),
        (@IdPersonaLuis, 2, @ClusterD, 1, 'ACTIVO'),
        (@IdPersonaDereck, 3, @ClusterD, 1, 'ACTIVO'),
        (@IdPersonaSinthia, 4, @ClusterD, 1, 'ACTIVO'),
        (@IdPersonaDaniel, 5, @ClusterD, 1, 'ACTIVO');

    -- Empleados y AsignacionTurno
    INSERT INTO Empleado (FechaAlta, Estado, IdPersona, IdPuestoEmpleado)
    VALUES 
        ('2023-01-15', 'ACTIVO', @IdPersonaAstrid, @Administrador),
        ('2023-02-01', 'ACTIVO', @IdPersonaMaria, @Guardia);
    DECLARE @IdEmpleadoMaria INT = (SELECT IdEmpleado FROM Empleado WHERE IdPersona = @IdPersonaMaria);
    INSERT INTO AsignacionTurno (IdEmpleado, IdTurno, FechaAsignacion) VALUES (@IdEmpleadoMaria, @Matutino, GETDATE());

    -- Junta Directiva
    DECLARE @IdJuntaA INT;
    INSERT INTO JuntaDirectiva (IdCluster) VALUES (@ClusterA);
    SET @IdJuntaA = SCOPE_IDENTITY();
    INSERT INTO MiembroJuntaDirectiva (FechaInicio, FechaFin, Estado, IdJuntaDirectiva, IdPropietario, idPuesto)
    VALUES (GETDATE(), DATEADD(year, 2, GETDATE()), 'ACTIVO', @IdJuntaA, @IdPropKeily, @Presidente);

    -- ==============================================================================
    -- 4. SEGURIDAD: VEHICULOS Y PERSONAS NO GRATAS
    -- ==============================================================================
    
    -- Vehiculo (para ser prohibido)
    INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
    VALUES (2020, 'P123ABC', 1, @ClusterA, @Corolla, @Toyota);
    DECLARE @IdVehiculoProhibir INT = SCOPE_IDENTITY();

    -- VehiculoProhibido (Integridad Vehiculo -> VehiculoProhibido)
    INSERT INTO VehiculoProhibido (Fecha, Motivo, IdVehiculo)
    VALUES (GETDATE(), 'Exceso de velocidad registrado el 10/10/2024', @IdVehiculoProhibir);

    -- PersonaNoGrata (Integridad Persona -> PersonaNoGrata)
    INSERT INTO Persona (Cui, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono, Genero, FechaNacimiento, EstadoCivil)
    VALUES ('111122223333', 'Juan', 'Jose', 'Perez', 'Altercado', '55551234', 'M', '1980-05-05', 'Soltero');
    DECLARE @IdPersonaNoGrata INT = SCOPE_IDENTITY();
    
    INSERT INTO PersonaNoGrata (FechaInicio, Motivo, IdPersona)
    VALUES (GETDATE(), 'Altercado con guardia en garita', @IdPersonaNoGrata);

    -- Registro Accesos
    DECLARE @IdGaritaA INT = (SELECT IdGarita FROM Garita WHERE IdCluster = @ClusterA);
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    VALUES ('Luis Visitante', '1000', 55123424, 'Visita Familiar', @DPI);
    DECLARE @IdVisitante INT = SCOPE_IDENTITY();
    
    INSERT INTO RegistroAccesos (FechaIngreso, IdGarita, IdVisitante, IdEmpleado)
    VALUES (GETDATE(), @IdGaritaA, @IdVisitante, @IdEmpleadoMaria);

    -- ==============================================================================
    -- 5. TRANSACCIONALES: COBROS, MULTAS, PAGOS, RECIBOS (CRÍTICO)
    -- ==============================================================================
    
    -- 5.1. CobroServicioVivienda (Vivienda A-1) - Total 480.00
    DECLARE @FechaCobroBase DATE = '2024-09-01';
    DECLARE @Cobros TABLE (idCobroServicio INT, IdServicio INT, EstadoPago VARCHAR(10));
    
    -- Insertar Cobros para A-1 (Serán PAGADOS)
    INSERT INTO CobroServicioVivienda (FechaCobro, Monto, MontoAplicado, EstadoPago, IdServicio, NumeroVivienda, IdCluster)
    OUTPUT inserted.idCobroServicio, inserted.IdServicio, inserted.EstadoPago INTO @Cobros
    SELECT @FechaCobroBase, Tarifa, Tarifa, 'PAGADO', IdServicio, 1, @ClusterA
    FROM Servicio;

    -- Insertar Cobros para A-2 (Serán PENDIENTES)
    INSERT INTO CobroServicioVivienda (FechaCobro, Monto, MontoAplicado, EstadoPago, IdServicio, NumeroVivienda, IdCluster)
    SELECT @FechaCobroBase, Tarifa, Tarifa, 'PENDIENTE', IdServicio, 2, @ClusterA
    FROM Servicio;

    -- 5.2. MultaVivienda (Vivienda A-3)
    INSERT INTO MultaVivienda (Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster)
    VALUES (200.00, 'Desechos de mascota no recogidos', '2024-09-05', GETDATE(), 'PAGADO', @MultaMascota, 3, @ClusterA);
    DECLARE @IdMultaPagada INT = SCOPE_IDENTITY();

    -- 5.3. Pago (Liquida Cobros A-1 (480.00) + Multa A-3 (200.00) = 680.00)
    DECLARE @MontoTotalPago DECIMAL = 680.00;
    INSERT INTO Pago (FechaPago, MontoTotal) VALUES (GETDATE(), @MontoTotalPago); 
    DECLARE @IdPagoTotal INT = SCOPE_IDENTITY();
    
    INSERT INTO DetallePago (Monto, idTipoPago, IdPago, Referencia)
    VALUES (@MontoTotalPago, @Transferencia, @IdPagoTotal, 'Transfer-Servicios-Multa-A1/A3');

    -- 5.4. Recibo (Vivienda A-1)
    INSERT INTO Recibo (FechaEmision, IdPago, NumeroVivienda, IdCluster)
    VALUES (GETDATE(), @IdPagoTotal, 1, @ClusterA);
    DECLARE @IdRecibo1 INT = SCOPE_IDENTITY();
    
    -- 5.5. DetalleRecibo (Integridad Recibo -> CobroServicioVivienda & Recibo -> MultaVivienda)
    
    -- Liquidación de Cobros de Servicio (Vivienda A-1)
    INSERT INTO DetalleRecibo (IdRecibo, idCobroServicio)
    SELECT @IdRecibo1, idCobroServicio FROM @Cobros 
    WHERE EstadoPago = 'PAGADO' AND idCobroServicio IN (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 1 AND IdCluster = @ClusterA);

    -- Liquidación de Multa (Vivienda A-3)
    INSERT INTO DetalleRecibo (IdRecibo, IdMultaVivienda)
    VALUES (@IdRecibo1, @IdMultaPagada);


    COMMIT TRANSACTION;
    PRINT 'Datos de prueba insertados correctamente, cumpliendo estrictamente con el modelo proporcionado.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    
    -- Mostrar detalles del error
    PRINT 'Error en la inserción de datos de prueba:';
    THROW;
END CATCH;
GO