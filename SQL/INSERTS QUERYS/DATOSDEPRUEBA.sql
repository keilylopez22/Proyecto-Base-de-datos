BEGIN TRY
    BEGIN TRANSACTION;
  
    DECLARE @Personas TABLE (IdPersona INT, Cui VARCHAR(20));
    INSERT INTO Persona (Cui, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono, Genero, FechaNacimiento)
    OUTPUT inserted.IdPersona, inserted.Cui INTO @Personas
    VALUES 
        ('09072321839', 'Keily',     NULL,       'Lopez',    'Hernandez', '40338234', 'F', '2002-03-18'),
        ('290289065102', 'Cristhian', 'Eduardo',  'Lopez',    'Lemus',     '55123402', 'M', '1998-06-15'),
        ('290371056103', 'Delmi',     NULL,       'Maria',    'Fajardo',   '55123403', 'F', '2000-11-22'),
        ('290460345104', 'Cristian',  'Eduardo',  'Chamo',    'Morales',   '55123404', 'M', '1995-09-05'),
        ('290558934105', 'Ana',       'Laura',    'Oliva',    NULL,        '55123405', 'F', '2001-12-30'),
        ('290647823106', 'Ergil',     'Isaias',   'Cardenas', 'Cruz',      '55123406', 'M', '1998-06-25'),
        ('290736712107', 'Fredy',     NULL,       'Cardona',  'Montenegro','55123407', 'M', '2000-11-20'),
        ('290825601108', 'Fernando',  'Jose',     'Carranza', 'Cabrera',   '55123408', 'M', '1995-09-15'),
        ('290914590109', 'Ludin',     'Eduardo',  'Carranza', 'Guerra',    '55123409', 'M', '2001-12-28'),
        ('291003489110', 'Diego',     'Alexander','Contreras','Duarte',    '55123410', 'M', '1998-06-10'),
        ('291192378111', 'Ricardo',   'Enrrique', 'Hernandez','Chavez',    '55123411', 'M', '2000-11-25'),
        ('291281267112', 'Luis',      'Carlos',   'Lima',     'Perez',     '55123412', 'M', '1995-09-10'),
        ('291370156113', 'Dereck',    'Leonel',   'Marmol',   'Salguero',  '55123413', 'M', '2001-12-25'),
        ('291459045114', 'Sinthia',   'Celeste',  'Orellana', 'Galeano',   '55123414', 'F', '1998-06-05'),
        ('291548934115', 'Daniel',    'Alexander','Ortiz',    'Cabrera',   '55123415', 'M', '2000-11-15'),
        ('291637823116', 'Astrid',    'Mileidy',  'Peña',     'Polanco',   '55123416', 'F', '1995-09-20'),
        ('291726712117', 'Maria',     'Jose',     'Del Carmen','Portillo',  '55123417', 'F', '2001-12-20'),
        ('291815601118', 'Enma',      'Leticia',  'Ramirez',  'Castro',    '55123418', 'F', '1998-06-01'),
        ('291904590119', 'Aura',      'Lucia',    'Snadoval', 'Pivaral',   '55123419', 'F', '2000-11-10'),
        ('292093489120', 'Andreina',  'Jannin',   'Ulloa',    'Tellez',    '55123420', 'F', '1995-09-25');
  
    DECLARE @IdResidencial INT;
    INSERT INTO Residencial (Nombre) VALUES ('Residenciales San Francisco');
    SET @IdResidencial = SCOPE_IDENTITY();
  
    DECLARE @Clusters TABLE (IdCluster INT, Nombre VARCHAR(50));
    INSERT INTO Cluster (Descripcion, IdResidencial)
    OUTPUT inserted.IdCluster, inserted.Descripcion INTO @Clusters
    VALUES 
        ('Cluster A (Deluxe)', @IdResidencial),
        ('Cluster B (Central)', @IdResidencial),
        ('Cluster C (Familiar)', @IdResidencial),
        ('Cluster D (Económico)', @IdResidencial);
    DECLARE 
        @IdClusterA INT = (SELECT IdCluster FROM @Clusters WHERE Nombre = 'Cluster A (Deluxe)'),
        @IdClusterB INT = (SELECT IdCluster FROM @Clusters WHERE Nombre = 'Cluster B (Central)'),
        @IdClusterC INT = (SELECT IdCluster FROM @Clusters WHERE Nombre = 'Cluster C (Familiar)'),
        @IdClusterD INT = (SELECT IdCluster FROM @Clusters WHERE Nombre = 'Cluster D (Económico)');

    INSERT INTO Garita (IdCluster) VALUES (@IdClusterA), (@IdClusterB), (@IdClusterC), (@IdClusterD);
   
    DECLARE @TipoVivienda TABLE (IdTipoVivienda INT, Descripcion VARCHAR(50));
    INSERT INTO TipoVivienda (Descripcion, NumeroHabitaciones, SuperficieTotal, NumeroPisos, Estacionamiento)
    OUTPUT inserted.IdTipoVivienda, inserted.Descripcion INTO @TipoVivienda
    VALUES 
        ('Casa Grande', 4, 200, 2, 1),
        ('Casa Media', 3, 150, 2, 1),
        ('Casa Pequeña', 2, 100, 1, 0);
    DECLARE 
        @IdCasaGrande INT = (SELECT IdTipoVivienda FROM @TipoVivienda WHERE Descripcion = 'Casa Grande'),
        @IdCasaMedia  INT = (SELECT IdTipoVivienda FROM @TipoVivienda WHERE Descripcion = 'Casa Media'),
        @IdCasaPequeña INT = (SELECT IdTipoVivienda FROM @TipoVivienda WHERE Descripcion = 'Casa Pequeña');
   
    DECLARE @PuestosJunta TABLE (IdPuesto INT, Nombre VARCHAR(50));
    INSERT INTO PuestoJuntaDirectiva (Nombre, Descripcion)
    OUTPUT inserted.IdPuesto AS IdPuesto, inserted.Nombre INTO @PuestosJunta
    VALUES 
        ('Presidente', 'Máxima autoridad del cluster'),
        ('Vicepresidente', 'Sustituye al presidente'),
        ('Tesorero', 'Encargado de finanzas y pagos'),
        ('Secretario', 'Encargado de actas y comunicados');
    DECLARE 
        @IdPresidente INT = (SELECT IdPuesto FROM @PuestosJunta WHERE Nombre = 'Presidente'),
        @IdVicepresidente INT = (SELECT IdPuesto FROM @PuestosJunta WHERE Nombre = 'Vicepresidente'),
        @IdTesorero INT = (SELECT IdPuesto FROM @PuestosJunta WHERE Nombre = 'Tesorero'),
        @IdSecretario INT = (SELECT IdPuesto FROM @PuestosJunta WHERE Nombre = 'Secretario');
 
    DECLARE @PuestosEmpleado TABLE (IdPuesto INT, Nombre VARCHAR(50));
    INSERT INTO PuestoEmpleado (Nombre, Descripcion)
    OUTPUT inserted.IdPuestoEmpleado AS IdPuesto, inserted.Nombre INTO @PuestosEmpleado
    VALUES 
        ('Administrador', 'Personal de oficina y contabilidad'),
        ('Guardia', 'Personal de seguridad y control de acceso'),
        ('Mantenimiento', 'Personal encargado del jardín y áreas comunes');
    DECLARE 
        @IdAdministrador INT = (SELECT IdPuesto FROM @PuestosEmpleado WHERE Nombre = 'Administrador'),
        @IdGuardia INT = (SELECT IdPuesto FROM @PuestosEmpleado WHERE Nombre = 'Guardia'),
        @IdMantenimiento INT = (SELECT IdPuesto FROM @PuestosEmpleado WHERE Nombre = 'Mantenimiento');
  
    DECLARE @Turnos TABLE (IdTurno INT, Descripcion VARCHAR(50));
    INSERT INTO Turno (Descripcion, HoraInicio, HoraFin)
    OUTPUT inserted.IdTurno, inserted.Descripcion INTO @Turnos
    VALUES 
        ('Matutino', '06:00', '14:00'),
        ('Vespertino', '14:00', '22:00'),
        ('Nocturno', '22:00', '06:00');
    DECLARE 
        @IdMatutino INT = (SELECT IdTurno FROM @Turnos WHERE Descripcion = 'Matutino'),
        @IdVespertino INT = (SELECT IdTurno FROM @Turnos WHERE Descripcion = 'Vespertino'),
        @IdNocturno INT = (SELECT IdTurno FROM @Turnos WHERE Descripcion = 'Nocturno');

    DECLARE @Servicios TABLE (IdServicio INT, Nombre VARCHAR(50));
    INSERT INTO Servicio (Nombre, Tarifa)
    OUTPUT inserted.IdServicio, inserted.Nombre INTO @Servicios
    VALUES 
        ('Mantenimiento Base', 350.00),
        ('Agua Consumo Mínimo', 150.00),
        ('Seguridad Extra', 100.00);
    DECLARE 
        @IdMantBase INT = (SELECT IdServicio FROM @Servicios WHERE Nombre = 'Mantenimiento Base'),
        @IdAgua INT = (SELECT IdServicio FROM @Servicios WHERE Nombre = 'Agua Consumo Mínimo'),
        @IdSeguridadExtra INT = (SELECT IdServicio FROM @Servicios WHERE Nombre = 'Seguridad Extra');
 
    DECLARE @TiposMulta TABLE (IdTipoMulta INT, Nombre VARCHAR(50));
    INSERT INTO TipoMulta (Nombre, Monto)
    OUTPUT inserted.IdTipoMulta, inserted.Nombre INTO @TiposMulta
    VALUES 
        ('Desechos fuera de hora', 250.00),
        ('Exceso de velocidad', 300.00),
        ('Ruido excesivo', 500.00),
        ('Daño a área común', 1000.00);
    DECLARE 
        @IdMultaBasura INT = (SELECT IdTipoMulta FROM @TiposMulta WHERE Nombre = 'Desechos fuera de hora'),
        @IdMultaVelocidad INT = (SELECT IdTipoMulta FROM @TiposMulta WHERE Nombre = 'Exceso de velocidad'),
        @IdMultaRuido INT = (SELECT IdTipoMulta FROM @TiposMulta WHERE Nombre = 'Ruido excesivo'),
        @IdMultaDanio INT = (SELECT IdTipoMulta FROM @TiposMulta WHERE Nombre = 'Daño a área común');

    DECLARE @TiposPago TABLE (IdTipoPago INT, Nombre VARCHAR(50));
    INSERT INTO TipoPago (Nombre, Descripcion)
    OUTPUT inserted.IdTipoPago, inserted.Nombre INTO @TiposPago
    VALUES 
        ('Efectivo', 'Pago realizado en la oficina'),
        ('Transferencia', 'Pago por transferencia bancaria'),
        ('Cheque', 'Pago con cheque físico'),
        ('Débito Automático', 'Cargo recurrente a tarjeta');
    DECLARE 
        @IdEfectivo INT = (SELECT IdTipoPago FROM @TiposPago WHERE Nombre = 'Efectivo'),
        @IdTransferencia INT = (SELECT IdTipoPago FROM @TiposPago WHERE Nombre = 'Transferencia'),
        @IdCheque INT = (SELECT IdTipoPago FROM @TiposPago WHERE Nombre = 'Cheque'),
        @IdDebito INT = (SELECT IdTipoPago FROM @TiposPago WHERE Nombre = 'Débito Automático');
 
    DECLARE @TiposDoc TABLE (IdTipoDocumento INT, Nombre VARCHAR(50));
    INSERT INTO TipoDocumento (Nombre)
    OUTPUT inserted.IdTipoDocumento, inserted.Nombre INTO @TiposDoc
    VALUES 
        ('DPI'),
        ('Licencia de Conducir'),
        ('Pasaporte');
    DECLARE 
        @IdDPI INT = (SELECT IdTipoDocumento FROM @TiposDoc WHERE Nombre = 'DPI'),
        @IdLicencia INT = (SELECT IdTipoDocumento FROM @TiposDoc WHERE Nombre = 'Licencia de Conducir'),
        @IdPasaporte INT = (SELECT IdTipoDocumento FROM @TiposDoc WHERE Nombre = 'Pasaporte');

    DECLARE @Marcas TABLE (IdMarca INT, Descripcion VARCHAR(50));
    INSERT INTO Marca (Descripcion)
    OUTPUT inserted.IdMarca, inserted.Descripcion INTO @Marcas
    VALUES 
        ('Toyota'),
        ('Honda'),
        ('Nissan');
    DECLARE 
        @IdToyota INT = (SELECT IdMarca FROM @Marcas WHERE Descripcion = 'Toyota'),
        @IdHonda INT = (SELECT IdMarca FROM @Marcas WHERE Descripcion = 'Honda'),
        @IdNissan INT = (SELECT IdMarca FROM @Marcas WHERE Descripcion = 'Nissan');
   
    DECLARE @Lineas TABLE (IdLinea INT, Descripcion VARCHAR(50), IdMarca INT);
    INSERT INTO Linea (Descripcion, IdMarca)
    OUTPUT inserted.IdLinea, inserted.Descripcion, inserted.IdMarca INTO @Lineas
    VALUES 
        ('Corolla', @IdToyota),
        ('Yaris', @IdToyota),
        ('Civic', @IdHonda),
        ('CR-V', @IdHonda),
        ('Sentra', @IdNissan),
        ('Frontier', @IdNissan);
    DECLARE 
        @IdCorolla INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'Corolla'),
        @IdYaris INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'Yaris'),
        @IdCivic INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'Civic'),
        @IdCRV INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'CR-V'),
        @IdSentra INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'Sentra'),
        @IdFrontier INT = (SELECT IdLinea FROM @Lineas WHERE Descripcion = 'Frontier');
  
    DECLARE @Propietarios TABLE (IdPropietario INT, Cui VARCHAR(20));

    -- Insertar propietarios
    INSERT INTO Propietario (Estado, IdPersona)
    SELECT 'ACTIVO', p.IdPersona
    FROM @Personas p
    WHERE p.Cui IN (
        '09072321839', 
        '290289065102', 
        '290371056103', 
        '290460345104', 
        '290558934105', 
        '290647823106', 
        '290736712107',
        '290825601108', 
        '290914590109', 
        '291003489110' 
    );

    INSERT INTO @Propietarios (IdPropietario, Cui)
    SELECT pr.IdPropietario, p.Cui
    FROM Propietario pr
    INNER JOIN @Personas p ON pr.IdPersona = p.IdPersona;


    DECLARE 
        @IdPropKeily INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '09072321839'),
        @IdPropCristhian INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290289065102'),
        @IdPropDelmi INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290371056103'),
        @IdPropCristian INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290460345104'),
        @IdPropAna INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290558934105'),
        @IdPropErgil INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290647823106'),
        @IdPropFredy INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290736712107'),
        @IdPropFernando INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290825601108'),
        @IdPropLudin INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '290914590109'),
        @IdPropDiego INT = (SELECT IdPropietario FROM @Propietarios WHERE Cui = '291003489110');

    INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdTipoVivienda, IdPropietario)
    VALUES 
        (101, @IdClusterA, @IdCasaGrande, @IdPropKeily),
        (102, @IdClusterA, @IdCasaGrande, @IdPropCristhian),
        (103, @IdClusterA, @IdCasaMedia, @IdPropDelmi),
        (201, @IdClusterB, @IdCasaMedia, @IdPropCristian),
        (202, @IdClusterB, @IdCasaMedia, @IdPropAna),
        (203, @IdClusterB, @IdCasaPequeña, @IdPropErgil),
        (301, @IdClusterC, @IdCasaMedia, @IdPropFredy),
        (302, @IdClusterC, @IdCasaPequeña, @IdPropFernando),
        (303, @IdClusterC, @IdCasaPequeña, @IdPropLudin),
        (304, @IdClusterC, @IdCasaPequeña, @IdPropDiego),
        (401, @IdClusterD, @IdCasaPequeña, @IdPropKeily),
        (402, @IdClusterD, @IdCasaPequeña, @IdPropCristhian),
        (403, @IdClusterD, @IdCasaMedia, @IdPropDelmi),
        (404, @IdClusterD, @IdCasaGrande, @IdPropCristian),
        (405, @IdClusterD, @IdCasaMedia, @IdPropAna);
    
    DECLARE @IdPersonaKeily INT = (SELECT IdPersona FROM @Personas WHERE Cui = '09072321839');
    DECLARE @IdPersonaCristhian INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290289065102');
    DECLARE @IdPersonaDelmi INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290371056103');
    DECLARE @IdPersonaCristian INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290460345104');
    DECLARE @IdPersonaAna INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290558934105');
    DECLARE @IdPersonaErgil INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290647823106');
    DECLARE @IdPersonaFredy INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290736712107');
    DECLARE @IdPersonaFernando INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290825601108');
    DECLARE @IdPersonaLudin INT = (SELECT IdPersona FROM @Personas WHERE Cui = '290914590109');
    DECLARE @IdPersonaDiego INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291003489110');
    DECLARE @IdPersonaRicardo INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291192378111');
    DECLARE @IdPersonaLuis INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291281267112');
    DECLARE @IdPersonaDereck INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291370156113');
    DECLARE @IdPersonaSinthia INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291459045114');
    DECLARE @IdPersonaDaniel INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291548934115');
    INSERT INTO Residente (IdPersona, NumeroVivienda, IdCluster, EsInquilino, Estado)
    VALUES 
        (@IdPersonaKeily, 101, @IdClusterA, 0, 'ACTIVO'),
        (@IdPersonaCristhian, 102, @IdClusterA, 0, 'ACTIVO'),
        (@IdPersonaDelmi, 103, @IdClusterA, 0, 'ACTIVO'),
        (@IdPersonaCristian, 201, @IdClusterB, 0, 'ACTIVO'),
        (@IdPersonaAna, 202, @IdClusterB, 0, 'ACTIVO'),
        (@IdPersonaErgil, 203, @IdClusterB, 0, 'ACTIVO'),
        (@IdPersonaFredy, 301, @IdClusterC, 0, 'ACTIVO'),
        (@IdPersonaFernando, 302, @IdClusterC, 0, 'ACTIVO'),
        (@IdPersonaLudin, 303, @IdClusterC, 0, 'ACTIVO'),
        (@IdPersonaDiego, 304, @IdClusterC, 0, 'ACTIVO'),
        (@IdPersonaRicardo, 401, @IdClusterD, 1, 'ACTIVO'),
        (@IdPersonaLuis, 402, @IdClusterD, 1, 'ACTIVO'),
        (@IdPersonaDereck, 403, @IdClusterD, 1, 'ACTIVO'),
        (@IdPersonaSinthia, 404, @IdClusterD, 1, 'ACTIVO'),
        (@IdPersonaDaniel, 405, @IdClusterD, 1, 'ACTIVO');
    
    DECLARE @IdPersonaAstrid INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291637823116');
    DECLARE @IdPersonaMaria INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291726712117');
    DECLARE @IdPersonaEnma INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291815601118');
    DECLARE @IdPersonaAura INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291904590119');
    DECLARE @IdPersonaAndreina INT = (SELECT IdPersona FROM @Personas WHERE Cui = '292093489120');
    INSERT INTO Empleado (FechaAlta, Estado, IdPersona, IdPuestoEmpleado)
    VALUES 
        ('2023-01-15', 'ACTIVO', @IdPersonaAstrid, @IdAdministrador),
        ('2023-02-01', 'ACTIVO', @IdPersonaMaria, @IdGuardia),
        ('2023-03-10', 'ACTIVO', @IdPersonaEnma, @IdGuardia),
        ('2023-04-20', 'ACTIVO', @IdPersonaAura, @IdGuardia),
        ('2023-05-05', 'ACTIVO', @IdPersonaAndreina, @IdMantenimiento);
    
    INSERT INTO Vehiculo (Año, Placa, NumeroVivienda, IdCluster, IdLinea, IdMarca)
    VALUES 
        (2020, 'P123ABC', 101, @IdClusterA, @IdCorolla, @IdToyota),
        (2018, 'P456DEF', 102, @IdClusterA, @IdCivic, @IdHonda),
        (2022, 'P789GHI', 103, @IdClusterA, @IdSentra, @IdNissan),
        (2015, 'Q111JKL', 201, @IdClusterB, @IdYaris, @IdToyota),
        (2021, 'Q222MNO', 202, @IdClusterB, @IdCRV, @IdHonda),
        (2019, 'Q333PQR', 203, @IdClusterB, @IdFrontier, @IdNissan),
        (2017, 'R444STU', 301, @IdClusterC, @IdCorolla, @IdToyota),
        (2023, 'R555VWX', 302, @IdClusterC, @IdCivic, @IdHonda),
        (2016, 'R666YZA', 303, @IdClusterC, @IdSentra, @IdNissan),
        (2020, 'R777BCD', 304, @IdClusterC, @IdCRV, @IdHonda);
  
    DECLARE @Juntas TABLE (IdJuntaDirectiva INT, IdCluster INT);
    INSERT INTO JuntaDirectiva (IdCluster)
    OUTPUT inserted.IdJuntaDirectiva, inserted.IdCluster INTO @Juntas
    VALUES (@IdClusterA), (@IdClusterB), (@IdClusterC), (@IdClusterD);
    DECLARE 
        @IdJuntaA INT = (SELECT IdJuntaDirectiva FROM @Juntas WHERE IdCluster = @IdClusterA),
        @IdJuntaB INT = (SELECT IdJuntaDirectiva FROM @Juntas WHERE IdCluster = @IdClusterB),
        @IdJuntaC INT = (SELECT IdJuntaDirectiva FROM @Juntas WHERE IdCluster = @IdClusterC),
        @IdJuntaD INT = (SELECT IdJuntaDirectiva FROM @Juntas WHERE IdCluster = @IdClusterD);
   
    INSERT INTO MiembroJuntaDirectiva (FechaInicio, FechaFin, Estado, IdJuntaDirectiva, IdPropietario, IdPuesto)
    VALUES 
        ('2024-01-01', '2025-12-31', 'ACTIVO', @IdJuntaA, @IdPropKeily, @IdPresidente),
        ('2024-01-01', '2025-12-31', 'ACTIVO', @IdJuntaA, @IdPropCristhian, @IdTesorero),
        ('2024-01-01', '2025-12-31', 'ACTIVO', @IdJuntaA, @IdPropDelmi, @IdSecretario),
        ('2023-07-01', '2025-06-30', 'ACTIVO', @IdJuntaB, @IdPropCristian, @IdPresidente),
        ('2023-07-01', '2025-06-30', 'ACTIVO', @IdJuntaB, @IdPropAna, @IdTesorero),
        ('2023-07-01', '2025-06-30', 'ACTIVO', @IdJuntaB, @IdPropErgil, @IdSecretario),
        ('2024-03-01', '2026-02-28', 'ACTIVO', @IdJuntaC, @IdPropFredy, @IdPresidente),
        ('2024-03-01', '2026-02-28', 'ACTIVO', @IdJuntaC, @IdPropFernando, @IdTesorero),
        ('2023-11-01', '2025-10-31', 'ACTIVO', @IdJuntaD, @IdPropLudin, @IdPresidente),
        ('2023-11-01', '2025-10-31', 'ACTIVO', @IdJuntaD, @IdPropDiego, @IdTesorero),
        ('2022-01-01', '2023-12-31', 'INACTIVO', @IdJuntaA, @IdPropKeily, @IdVicepresidente),
        ('2022-07-01', '2023-06-30', 'INACTIVO', @IdJuntaB, @IdPropCristian, @IdVicepresidente);
   
    INSERT INTO CobroServicioVivienda (FechaCobro, Monto, MontoAplicado, EstadoPago, IdServicio, NumeroVivienda, IdCluster)
    VALUES 
        ('2024-09-01', 600.00, 600.00, 'PENDIENTE', @IdMantBase, 101, @IdClusterA),
        ('2024-09-01', 600.00, 600.00, 'PENDIENTE', @IdMantBase, 102, @IdClusterA),
        ('2024-09-01', 600.00, 600.00, 'PAGADO', @IdAgua, 103, @IdClusterA),
        ('2024-09-01', 500.00, 500.00, 'PAGADO', @IdMantBase, 201, @IdClusterB),
        ('2024-09-01', 500.00, 500.00, 'PAGADO', @IdAgua, 202, @IdClusterB),
        ('2024-09-01', 500.00, 500.00, 'PENDIENTE', @IdSeguridadExtra, 203, @IdClusterB),
        ('2024-09-01', 450.00, 450.00, 'PAGADO', @IdMantBase, 301, @IdClusterC),
        ('2024-09-01', 450.00, 450.00, 'PAGADO', @IdAgua, 302, @IdClusterC),
        ('2024-09-01', 450.00, 450.00, 'PAGADO', @IdSeguridadExtra, 303, @IdClusterC),
        ('2024-09-01', 450.00, 450.00, 'PENDIENTE', @IdMantBase, 304, @IdClusterC),
        ('2024-09-01', 400.00, 400.00, 'PAGADO', @IdAgua, 401, @IdClusterD),
        ('2024-09-01', 400.00, 400.00, 'PENDIENTE', @IdSeguridadExtra, 402, @IdClusterD),
        ('2024-09-01', 500.00, 500.00, 'PAGADO', @IdMantBase, 403, @IdClusterD),
        ('2024-09-01', 600.00, 600.00, 'PAGADO', @IdAgua, 404, @IdClusterD),
        ('2024-09-01', 500.00, 500.00, 'PENDIENTE', @IdSeguridadExtra, 405, @IdClusterD);
  
    INSERT INTO MultaVivienda (Monto, Observaciones, FechaInfraccion, FechaRegistro, EstadoPago, IdTipoMulta, NumeroVivienda, IdCluster)
    VALUES 
        (250.00, 'Bolsa de basura fuera de contenedor', '2024-09-05', GETDATE(), 'PENDIENTE', @IdMultaBasura, 101, @IdClusterA),
        (300.00, 'Exceso de 15km/h en área común', '2024-09-08', GETDATE(), 'PAGADO', @IdMultaVelocidad, 201, @IdClusterB),
        (500.00, 'Fiesta hasta altas horas', '2024-08-20', GETDATE(), 'PAGADO', @IdMultaRuido, 301, @IdClusterC),
        (250.00, 'Reincidencia de basura', '2024-09-15', GETDATE(), 'PENDIENTE', @IdMultaBasura, 101, @IdClusterA),
        (300.00, 'Exceso de velocidad', '2024-09-16', GETDATE(), 'PENDIENTE', @IdMultaVelocidad, 401, @IdClusterD),
        (500.00, 'Ruido de construcción fuera de horario', '2024-09-18', GETDATE(), 'PENDIENTE', @IdMultaRuido, 203, @IdClusterB);
  
    DECLARE @Pagos TABLE (IdPago INT, Referencia VARCHAR(50));
    INSERT INTO Pago (FechaPago, MontoTotal, idTipoPago, Referencia)
    OUTPUT inserted.IdPago, inserted.Referencia INTO @Pagos
    VALUES 
        (GETDATE(), 600.00, @IdEfectivo, 'EFECTIVO-103-09'),
        (GETDATE(), 500.00, @IdTransferencia, 'TRANS-201-09'),
        (GETDATE(), 500.00, @IdCheque, 'CHEQUE-202-09'),
        (GETDATE(), 450.00, @IdEfectivo, 'EFECTIVO-301-09'),
        (GETDATE(), 450.00, @IdTransferencia, 'TRANS-302-09'),
        (GETDATE(), 450.00, @IdCheque, 'CHEQUE-303-09'),
        (GETDATE(), 400.00, @IdDebito, 'DEBITO-401-09'),
        (GETDATE(), 600.00, @IdTransferencia, 'TRANS-404-09'),
        ('2024-09-08', 300.00, @IdEfectivo, 'MULTA-201-09'),
        ('2024-08-20', 500.00, @IdCheque, 'MULTA-301-08');
 
    DECLARE @Recibos TABLE (IdRecibo INT, ReferenciaPago VARCHAR(50));

  
    INSERT INTO Recibo (FechaEmision, IdPago, IdCluster, NumeroVivienda)
    SELECT GETDATE(), IdPago, 1,101
    FROM @Pagos;


    INSERT INTO @Recibos (IdRecibo, ReferenciaPago)
    SELECT r.IdRecibo, p.Referencia
    FROM Recibo r
    INNER JOIN @Pagos p ON r.IdPago = p.IdPago;

   
    DECLARE @IdCobro103 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 103 AND IdCluster = @IdClusterA);
    DECLARE @IdCobro201 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 201 AND IdCluster = @IdClusterB);
    DECLARE @IdCobro202 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 202 AND IdCluster = @IdClusterB);
    DECLARE @IdCobro301 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 301 AND IdCluster = @IdClusterC);
    DECLARE @IdCobro302 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 302 AND IdCluster = @IdClusterC);
    DECLARE @IdCobro303 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 303 AND IdCluster = @IdClusterC);
    DECLARE @IdCobro401 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 401 AND IdCluster = @IdClusterD);
    DECLARE @IdCobro404 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 404 AND IdCluster = @IdClusterD);
    DECLARE @IdCobro403 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 403 AND IdCluster = @IdClusterD);
    DECLARE @IdCobro405 INT = (SELECT idCobroServicio FROM CobroServicioVivienda WHERE NumeroVivienda = 405 AND IdCluster = @IdClusterD);
    DECLARE @IdMulta201 INT = (SELECT IdMultaVivienda FROM MultaVivienda WHERE NumeroVivienda = 201 AND IdCluster = @IdClusterB AND Monto = 300.00);
    DECLARE @IdMulta301 INT = (SELECT IdMultaVivienda FROM MultaVivienda WHERE NumeroVivienda = 301 AND IdCluster = @IdClusterC AND Monto = 500.00);
    DECLARE @IdRec1 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'EFECTIVO-103-09');
    DECLARE @IdRec2 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'TRANS-201-09');
    DECLARE @IdRec3 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'CHEQUE-202-09');
    DECLARE @IdRec4 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'EFECTIVO-301-09');
    DECLARE @IdRec5 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'TRANS-302-09');
    DECLARE @IdRec6 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'CHEQUE-303-09');
    DECLARE @IdRec7 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'DEBITO-401-09');
    DECLARE @IdRec8 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'TRANS-404-09');
    DECLARE @IdRec9 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'MULTA-201-09');
    DECLARE @IdRec10 INT = (SELECT IdRecibo FROM @Recibos WHERE ReferenciaPago = 'MULTA-301-08');
    INSERT INTO DetalleRecibo (IdRecibo, idCobroServicio, IdMultaVivienda)
    VALUES 
        (@IdRec1, @IdCobro103, NULL),
        (@IdRec2, @IdCobro201, NULL),
        (@IdRec3, @IdCobro202, NULL),
        (@IdRec4, @IdCobro301, NULL),
        (@IdRec5, @IdCobro302, NULL),
        (@IdRec6, @IdCobro303, NULL),
        (@IdRec7, @IdCobro401, NULL),
        (@IdRec8, @IdCobro404, NULL),
        (@IdRec9, NULL, @IdMulta201),
        (@IdRec10, NULL, @IdMulta301);
  
    DECLARE @IdEmpleadoMaria INT = (SELECT IdEmpleado FROM Empleado WHERE IdPersona = @IdPersonaMaria);
    DECLARE @IdEmpleadoEnma INT = (SELECT IdEmpleado FROM Empleado WHERE IdPersona = @IdPersonaEnma);
    DECLARE @IdEmpleadoAura INT = (SELECT IdEmpleado FROM Empleado WHERE IdPersona = @IdPersonaAura);
    INSERT INTO AsignacionTurno (IdEmpleado, IdTurno, FechaAsignacion)
    VALUES 
        (@IdEmpleadoMaria, @IdMatutino, '2024-10-01'),
        (@IdEmpleadoEnma, @IdVespertino, '2024-10-01'),
        (@IdEmpleadoAura, @IdNocturno, '2024-10-01'),
        (@IdEmpleadoMaria, @IdVespertino, '2024-10-02'),
        (@IdEmpleadoEnma, @IdNocturno, '2024-10-02'),
        (@IdEmpleadoAura, @IdMatutino, '2024-10-02'),
        (@IdEmpleadoMaria, @IdNocturno, '2024-10-03'),
        (@IdEmpleadoEnma, @IdMatutino, '2024-10-03'),
        (@IdEmpleadoAura, @IdVespertino, '2024-10-03'),
        (@IdEmpleadoMaria, @IdMatutino, '2024-10-04');
  
    DECLARE @Visitantes TABLE (IdVisitante INT, NumeroDocumento VARCHAR(20));
    INSERT INTO Visitante (NombreCompleto, NumeroDocumento, Telefono, MotivoVisita, IdTipoDocumento)
    OUTPUT inserted.IdVisitante, inserted.NumeroDocumento INTO @Visitantes
    VALUES 
        ('Juan Jose Lopez Hernandez', '100459403124', 55123424, 'Visita Familiar', @IdDPI),
        ('Lucia Fernanda Morales Ramos', '100548392125', 55123425, 'Servicios a Domicilio', @IdLicencia),
        ('Jorge Alberto Reyes Soliz', '100637281126', 55123426, 'Repartidor', @IdDPI),
        ('Susana Carolina Guzman Mendez', '100726170127', 55123427, 'Social', @IdPasaporte),
        ('Marco Antonio Carranza Cabrera', '100815069128', 55123428, 'Social', @IdDPI);
    DECLARE 
        @IdVisitJuan INT = (SELECT IdVisitante FROM @Visitantes WHERE NumeroDocumento = '100459403124'),
        @IdVisitLucia INT = (SELECT IdVisitante FROM @Visitantes WHERE NumeroDocumento = '100548392125'),
        @IdVisitJorge INT = (SELECT IdVisitante FROM @Visitantes WHERE NumeroDocumento = '100637281126'),
        @IdVisitSusana INT = (SELECT IdVisitante FROM @Visitantes WHERE NumeroDocumento = '100726170127'),
        @IdVisitMarco INT = (SELECT IdVisitante FROM @Visitantes WHERE NumeroDocumento = '100815069128');
  
    DECLARE @IdVeh1 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'P123ABC');
    DECLARE @IdVeh2 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'P456DEF');
    DECLARE @IdVeh3 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'P789GHI');
    DECLARE @IdVeh4 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'Q111JKL');
    DECLARE @IdVeh5 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'Q222MNO');
    DECLARE @IdVeh6 INT = (SELECT IdVehiculo FROM Vehiculo WHERE Placa = 'Q333PQR');
    DECLARE @IdGaritaA INT = (SELECT IdGarita FROM Garita WHERE IdCluster = @IdClusterA);
    DECLARE @IdGaritaB INT = (SELECT IdGarita FROM Garita WHERE IdCluster = @IdClusterB);
    DECLARE @IdGaritaC INT = (SELECT IdGarita FROM Garita WHERE IdCluster = @IdClusterC);
    DECLARE @IdGaritaD INT = (SELECT IdGarita FROM Garita WHERE IdCluster = @IdClusterD);
    DECLARE @IdResidenteKeily INT = (SELECT IdResidente FROM Residente WHERE IdPersona = @IdPersonaKeily);
    DECLARE @IdResidenteCristian INT = (SELECT IdResidente FROM Residente WHERE IdPersona = @IdPersonaCristian);
    DECLARE @IdResidenteFredy INT = (SELECT IdResidente FROM Residente WHERE IdPersona = @IdPersonaFredy);
    DECLARE @IdResidenteRicardo INT = (SELECT IdResidente FROM Residente WHERE IdPersona = @IdPersonaRicardo);
    DECLARE @IdResidenteDaniel INT = (SELECT IdResidente FROM Residente WHERE IdPersona = @IdPersonaDaniel);
    INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado)
    VALUES 
        ('2024-10-09 07:00:00', '2024-10-09 17:00:00', @IdVeh1, @IdGaritaA, NULL, @IdResidenteKeily, @IdEmpleadoMaria),
        ('2024-10-09 08:30:00', '2024-10-09 18:00:00', NULL, @IdGaritaB, NULL, @IdResidenteCristian, @IdEmpleadoEnma),
        ('2024-10-09 09:00:00', '2024-10-09 10:30:00', @IdVeh2, @IdGaritaA, @IdVisitJuan, NULL, @IdEmpleadoMaria),
        ('2024-10-09 11:00:00', '2024-10-09 11:30:00', NULL, @IdGaritaC, @IdVisitLucia, NULL, @IdEmpleadoAura),
        ('2024-10-09 14:00:00', '2024-10-09 15:00:00', NULL, @IdGaritaD, @IdVisitJorge, NULL, @IdEmpleadoEnma),
        ('2024-10-09 19:30:00', '2024-10-09 20:30:00', @IdVeh3, @IdGaritaA, @IdVisitSusana, NULL, @IdEmpleadoAura),
        ('2024-10-09 23:00:00', NULL, NULL, @IdGaritaB, @IdVisitMarco, NULL, @IdEmpleadoMaria),
        ('2024-10-10 06:15:00', '2024-10-10 16:00:00', @IdVeh4, @IdGaritaA, NULL, @IdResidenteFredy, @IdEmpleadoEnma),
        ('2024-10-10 07:45:00', '2024-10-10 15:30:00', @IdVeh5, @IdGaritaB, NULL, @IdResidenteRicardo, @IdEmpleadoAura),
        ('2024-10-10 08:10:00', '2024-10-10 14:00:00', @IdVeh6, @IdGaritaC, NULL, @IdResidenteDaniel, @IdEmpleadoMaria);

    DECLARE @IdPersonaEnma2 INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291815601118');
    DECLARE @IdPersonaAura2 INT = (SELECT IdPersona FROM @Personas WHERE Cui = '291904590119');
    INSERT INTO PersonaNoGrata (FechaInicio, FechaFin, Motivo, IdPersona)
    VALUES 
        ('2024-05-01', '2025-05-01', 'Intentó ingresar sin permiso en estado de ebriedad', @IdPersonaEnma2),
        ('2024-08-15', NULL, 'Violación grave a reglamento interno', @IdPersonaAura2);
    
    COMMIT TRANSACTION;
    PRINT 'Datos iniciales insertados con éxito y referencias correctas.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

UPDATE  Persona SET EstadoCivil = 'Soltero'