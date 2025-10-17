CREATE TABLE AsignacionTurno
(
  IdAsignacionTurno int  NOT NULL IDENTITY(1,1),
  IdEmpleado        int  NOT NULL,
  IdTurno           int  NOT NULL,
  FechaAsignacion   date NOT NULL,
  CONSTRAINT PK_AsignacionTurno PRIMARY KEY (IdAsignacionTurno)
)
GO

CREATE TABLE Cluster
(
  IdCluster     INT         NOT NULL IDENTITY(1,1),
  Descripcion   varchar(30) NOT NULL,
  IdResidencial int         NOT NULL,
  CONSTRAINT PK_Cluster PRIMARY KEY (IdCluster)
)
GO

CREATE TABLE CobroServicioVivienda
(
  idCobroServicio int         NOT NULL IDENTITY(1,1),
  FechaCobro      date       ,
  Monto           decimal    ,
  MontoAplicado   decimal    ,
  EstadoPago      varchar(50),
  IdServicio      int         NOT NULL,
  NumeroVivienda  INT         NOT NULL,
  IdCluster       INT         NOT NULL,
  CONSTRAINT PK_CobroServicioVivienda PRIMARY KEY (idCobroServicio)
)
GO

CREATE TABLE DetalleRecibo
(
  IdDetalleRecibo INT NOT NULL IDENTITY(1,1),
  IdRecibo        int NOT NULL,
  idCobroServicio int,
  IdMultaVivienda int,
  CONSTRAINT PK_DetalleRecibo PRIMARY KEY (IdDetalleRecibo)
)
GO

CREATE TABLE Empleado
(
  IdEmpleado       int         NOT NULL IDENTITY(1,1),
  FechaAlta        date       ,
  FechaBaja        date       ,
  Estado           varchar(30),
  IdPersona        int         NOT NULL,
  IdPuestoEmpleado int         NOT NULL,
  CONSTRAINT PK_Empleado PRIMARY KEY (IdEmpleado)
)
GO

CREATE TABLE Garita
(
  IdGarita  int NOT NULL IDENTITY(1,1),
  IdCluster INT NOT NULL,
  CONSTRAINT PK_Garita PRIMARY KEY (IdGarita)
)
GO

CREATE TABLE JuntaDirectiva
(
  IdJuntaDirectiva Int NOT NULL IDENTITY(1,1),
  IdCluster        INT NOT NULL,
  CONSTRAINT PK_JuntaDirectiva PRIMARY KEY (IdJuntaDirectiva)
)
GO

CREATE TABLE Linea
(
  IdLinea     int         NOT NULL IDENTITY(1,1),
  Descripcion varchar(30),
  IdMarca     int         NOT NULL,
  CONSTRAINT PK_Linea PRIMARY KEY (IdLinea, IdMarca)
)
GO

CREATE TABLE Marca
(
  IdMarca     int         NOT NULL IDENTITY(1,1),
  Descripcion varchar(30),
  CONSTRAINT PK_Marca PRIMARY KEY (IdMarca)
)
GO

CREATE TABLE MiembroJuntaDirectiva
(
  IdMiembro        int         NOT NULL IDENTITY(1,1),
  FechaInicio      date        NOT NULL,
  FechaFin         date        NOT NULL,
  Estado           varchar(10),
  IdJuntaDirectiva Int         NOT NULL,
  IdPropietario    int         NOT NULL,
  idPuesto         int         NOT NULL,
  CONSTRAINT PK_MiembroJuntaDirectiva PRIMARY KEY (IdMiembro)
)
GO

CREATE TABLE MultaVivienda
(
  IdMultaVivienda int         NOT NULL IDENTITY(1,1),
  Monto           decimal    ,
  Observaciones   varchar(50),
  FechaInfraccion date       ,
  FechaRegistro   date       ,
  EstadoPago      varchar(50),
  IdTipoMulta     int         NOT NULL,
  NumeroVivienda  INT         NOT NULL,
  IdCluster       INT         NOT NULL,
  CONSTRAINT PK_MultaVivienda PRIMARY KEY (IdMultaVivienda)
)
GO

CREATE TABLE Pago
(
  IdPago     int         NOT NULL IDENTITY(1,1),
  FechaPago  date       ,
  MontoTotal decimal    ,
  idTipoPago int         NOT NULL,
  Referencia varchar(50),
  CONSTRAINT PK_Pago PRIMARY KEY (IdPago)
)
GO

CREATE TABLE Persona
(
  IdPersona       int         NOT NULL IDENTITY(1,1),
  Cui             varchar(30) NOT NULL,
  PrimerNombre    varchar(30) NOT NULL,
  SegundoNombre   varchar(30),
  PrimerApellido  varchar(30) NOT NULL,
  SegundoApellido varchar(30),
  Telefono        varchar(10),
  Genero          char(1)    ,
  FechaNacimiento date       ,
  CONSTRAINT PK_Persona PRIMARY KEY (IdPersona)
)
GO

ALTER TABLE Persona
  ADD CONSTRAINT UQ_Cui UNIQUE (Cui)
GO

CREATE TABLE PersonaNoGrata
(
  idPersonaNoGrata int         NOT NULL IDENTITY(1,1),
  FechaInicio      date        NOT NULL,
  FechaFin         date       ,
  Motivo           varchar(50),
  IdPersona        int         NOT NULL,
  CONSTRAINT PK_PersonaNoGrata PRIMARY KEY (idPersonaNoGrata)
)
GO

CREATE TABLE Propietario
(
  IdPropietario int         NOT NULL IDENTITY(1,1),
  Estado        varchar(10) NOT NULL,
  IdPersona     int         NOT NULL,
  CONSTRAINT PK_Propietario PRIMARY KEY (IdPropietario)
)
GO

CREATE TABLE PuestoEmpleado
(
  IdPuestoEmpleado int         NOT NULL IDENTITY(1,1),
  Nombre           varchar(30),
  Descripcion      varchar(30),
  CONSTRAINT PK_PuestoEmpleado PRIMARY KEY (IdPuestoEmpleado)
)
GO

CREATE TABLE PuestoJuntaDirectiva
(
  idPuesto    int          NOT NULL IDENTITY(1,1),
  Nombre      varchar(50)  NOT NULL,
  Descripcion varchar(100),
  CONSTRAINT PK_PuestoJuntaDirectiva PRIMARY KEY (idPuesto)
)
GO

CREATE TABLE Recibo
(
  IdRecibo     int  NOT NULL IDENTITY(1,1),
  FechaEmision date,
  IdPago       int  NOT NULL,
  CONSTRAINT PK_Recibo PRIMARY KEY (IdRecibo)
)
GO

CREATE TABLE RegistroAccesos
(
  IdAcceso      int         NOT NULL IDENTITY(1,1),
  FechaIngreso  datetime   ,
  FechaSalida   datetime   ,
  Observaciones varchar(50),
  IdVehiculo    int        ,
  IdGarita      int         NOT NULL,
  IdVisitante   int        ,
  IdResidente   int        ,
  IdEmpleado    int         NOT NULL,
  CONSTRAINT PK_RegistroAccesos PRIMARY KEY (IdAcceso)
)
GO

CREATE TABLE Residencial
(
  IdResidencial int         NOT NULL IDENTITY(1,1),
  Nombre        varchar(50) NOT NULL,
  CONSTRAINT PK_Residencial PRIMARY KEY (IdResidencial)
)
GO

CREATE TABLE Residente
(
  IdResidente    int         NOT NULL IDENTITY(1,1),
  IdPersona      int         NOT NULL,
  NumeroVivienda INT         NOT NULL,
  IdCluster      INT         NOT NULL,
  EsInquilino    bit         NOT NULL,
  Estado         varchar(10),
  CONSTRAINT PK_Residente PRIMARY KEY (IdResidente)
)
GO

CREATE TABLE Servicio
(
  IdServicio int         NOT NULL IDENTITY(1,1),
  Nombre     varchar(50) NOT NULL,
  Tarifa     decimal     NOT NULL,
  CONSTRAINT PK_Servicio PRIMARY KEY (IdServicio)
)
GO

CREATE TABLE TipoDocumento
(
  IdTipoDocumento Int         NOT NULL IDENTITY(1,1),
  Nombre          varchar(50),
  CONSTRAINT PK_TipoDocumento PRIMARY KEY (IdTipoDocumento)
)
GO

CREATE TABLE TipoMulta
(
  IdTipoMulta int         NOT NULL IDENTITY(1,1),
  Nombre      varchar(50),
  Monto       money      ,
  CONSTRAINT PK_TipoMulta PRIMARY KEY (IdTipoMulta)
)
GO

CREATE TABLE TipoPago
(
  idTipoPago  int          NOT NULL IDENTITY(1,1),
  Nombre      varchar(50) ,
  Descripcion varchar(100),
  CONSTRAINT PK_TipoPago PRIMARY KEY (idTipoPago)
)
GO

CREATE TABLE TipoVivienda
(
  IdTipoVivienda     int         NOT NULL IDENTITY(1,1),
  Descripcion        varchar(50),
  NumeroHabitaciones int        ,
  SuperficieTotal    int        ,
  NumeroPisos        int        ,
  Estacionamiento    Bit        ,
  CONSTRAINT PK_TipoVivienda PRIMARY KEY (IdTipoVivienda)
)
GO

CREATE TABLE Turno
(
  IdTurno     int         NOT NULL IDENTITY(1,1),
  Descripcion varchar(30),
  HoraInicio  varchar(10),
  HoraFin     varchar(10),
  CONSTRAINT PK_Turno PRIMARY KEY (IdTurno)
)
GO

CREATE TABLE Vehiculo
(
  IdVehiculo     int         NOT NULL IDENTITY(1,1),
  A�o            int        ,
  Placa          varchar(50),
  NumeroVivienda INT         NOT NULL,
  IdCluster      INT         NOT NULL,
  IdLinea        int         NOT NULL,
  IdMarca        int         NOT NULL,
  CONSTRAINT PK_Vehiculo PRIMARY KEY (IdVehiculo)
)
GO

ALTER TABLE Vehiculo
  ADD CONSTRAINT UQ_Placa UNIQUE (Placa)
GO

CREATE TABLE VehiculoProhibido
(
  IdVehiculoProhibido int         NOT NULL IDENTITY(1,1),
  Fecha               date       ,
  Motivo              varchar(50),
  IdVehiculo          int         NOT NULL,
  CONSTRAINT PK_VehiculoProhibido PRIMARY KEY (IdVehiculoProhibido)
)
GO

CREATE TABLE Visitante
(
  IdVisitante     int         NOT NULL IDENTITY(1,1),
  NombreCompleto  varchar(50) NOT NULL,
  NumeroDocumento varchar(50) NOT NULL,
  Telefono        int        ,
  MotivoVisita    varchar(50),
  IdTipoDocumento Int         NOT NULL,
  CONSTRAINT PK_Visitante PRIMARY KEY (IdVisitante)
)
GO

CREATE TABLE Vivienda
(
  NumeroVivienda INT NOT NULL,
  IdCluster      INT NOT NULL,
  IdTipoVivienda int NOT NULL,
  IdPropietario  int NOT NULL,
  CONSTRAINT PK_Vivienda PRIMARY KEY (NumeroVivienda, IdCluster)
)
GO

ALTER TABLE Vivienda
  ADD CONSTRAINT FK_Cluster_TO_Vivienda
    FOREIGN KEY (IdCluster)
    REFERENCES Cluster (IdCluster)
GO

ALTER TABLE Propietario
  ADD CONSTRAINT FK_Persona_TO_Propietario
    FOREIGN KEY (IdPersona)
    REFERENCES Persona (IdPersona)
GO

ALTER TABLE Residente
  ADD CONSTRAINT FK_Persona_TO_Residente
    FOREIGN KEY (IdPersona)
    REFERENCES Persona (IdPersona)
GO

ALTER TABLE JuntaDirectiva
  ADD CONSTRAINT FK_Cluster_TO_JuntaDirectiva
    FOREIGN KEY (IdCluster)
    REFERENCES Cluster (IdCluster)
GO

ALTER TABLE MiembroJuntaDirectiva
  ADD CONSTRAINT FK_JuntaDirectiva_TO_MiembroJuntaDirectiva
    FOREIGN KEY (IdJuntaDirectiva)
    REFERENCES JuntaDirectiva (IdJuntaDirectiva)
GO

ALTER TABLE MiembroJuntaDirectiva
  ADD CONSTRAINT FK_Propietario_TO_MiembroJuntaDirectiva
    FOREIGN KEY (IdPropietario)
    REFERENCES Propietario (IdPropietario)
GO

ALTER TABLE MiembroJuntaDirectiva
  ADD CONSTRAINT FK_PuestoJuntaDirectiva_TO_MiembroJuntaDirectiva
    FOREIGN KEY (idPuesto)
    REFERENCES PuestoJuntaDirectiva (idPuesto)
GO

ALTER TABLE CobroServicioVivienda
  ADD CONSTRAINT FK_Servicio_TO_CobroServicioVivienda
    FOREIGN KEY (IdServicio)
    REFERENCES Servicio (IdServicio)
GO

ALTER TABLE Residente
  ADD CONSTRAINT FK_Vivienda_TO_Residente
    FOREIGN KEY (NumeroVivienda, IdCluster)
    REFERENCES Vivienda (NumeroVivienda, IdCluster)
GO

ALTER TABLE CobroServicioVivienda
  ADD CONSTRAINT FK_Vivienda_TO_CobroServicioVivienda
    FOREIGN KEY (NumeroVivienda, IdCluster)
    REFERENCES Vivienda (NumeroVivienda, IdCluster)
GO

ALTER TABLE Recibo
  ADD CONSTRAINT FK_Pago_TO_Recibo
    FOREIGN KEY (IdPago)
    REFERENCES Pago (IdPago)
GO

ALTER TABLE Pago
  ADD CONSTRAINT FK_TipoPago_TO_Pago
    FOREIGN KEY (idTipoPago)
    REFERENCES TipoPago (idTipoPago)
GO

ALTER TABLE Garita
  ADD CONSTRAINT FK_Cluster_TO_Garita
    FOREIGN KEY (IdCluster)
    REFERENCES Cluster (IdCluster)
GO

ALTER TABLE Vehiculo
  ADD CONSTRAINT FK_Vivienda_TO_Vehiculo
    FOREIGN KEY (NumeroVivienda, IdCluster)
    REFERENCES Vivienda (NumeroVivienda, IdCluster)
GO

ALTER TABLE RegistroAccesos
  ADD CONSTRAINT FK_Vehiculo_TO_RegistroAccesos
    FOREIGN KEY (IdVehiculo)
    REFERENCES Vehiculo (IdVehiculo)
GO

ALTER TABLE RegistroAccesos
  ADD CONSTRAINT FK_Garita_TO_RegistroAccesos
    FOREIGN KEY (IdGarita)
    REFERENCES Garita (IdGarita)
GO

ALTER TABLE RegistroAccesos
  ADD CONSTRAINT FK_Visitante_TO_RegistroAccesos
    FOREIGN KEY (IdVisitante)
    REFERENCES Visitante (IdVisitante)
GO

ALTER TABLE RegistroAccesos
  ADD CONSTRAINT FK_Residente_TO_RegistroAccesos
    FOREIGN KEY (IdResidente)
    REFERENCES Residente (IdResidente)
GO

ALTER TABLE Vivienda
  ADD CONSTRAINT FK_TipoVivienda_TO_Vivienda
    FOREIGN KEY (IdTipoVivienda)
    REFERENCES TipoVivienda (IdTipoVivienda)
GO

ALTER TABLE MultaVivienda
  ADD CONSTRAINT FK_TipoMulta_TO_MultaVivienda
    FOREIGN KEY (IdTipoMulta)
    REFERENCES TipoMulta (IdTipoMulta)
GO

ALTER TABLE MultaVivienda
  ADD CONSTRAINT FK_Vivienda_TO_MultaVivienda
    FOREIGN KEY (NumeroVivienda, IdCluster)
    REFERENCES Vivienda (NumeroVivienda, IdCluster)
GO

ALTER TABLE PersonaNoGrata
  ADD CONSTRAINT FK_Persona_TO_PersonaNoGrata
    FOREIGN KEY (IdPersona)
    REFERENCES Persona (IdPersona)
GO

ALTER TABLE Visitante
  ADD CONSTRAINT FK_TipoDocumento_TO_Visitante
    FOREIGN KEY (IdTipoDocumento)
    REFERENCES TipoDocumento (IdTipoDocumento)
GO

ALTER TABLE Empleado
  ADD CONSTRAINT FK_Persona_TO_Empleado
    FOREIGN KEY (IdPersona)
    REFERENCES Persona (IdPersona)
GO

ALTER TABLE Empleado
  ADD CONSTRAINT FK_PuestoEmpleado_TO_Empleado
    FOREIGN KEY (IdPuestoEmpleado)
    REFERENCES PuestoEmpleado (IdPuestoEmpleado)
GO

ALTER TABLE RegistroAccesos
  ADD CONSTRAINT FK_Empleado_TO_RegistroAccesos
    FOREIGN KEY (IdEmpleado)
    REFERENCES Empleado (IdEmpleado)
GO

ALTER TABLE Vivienda
  ADD CONSTRAINT FK_Propietario_TO_Vivienda
    FOREIGN KEY (IdPropietario)
    REFERENCES Propietario (IdPropietario)
GO

ALTER TABLE Linea
  ADD CONSTRAINT FK_Marca_TO_Linea
    FOREIGN KEY (IdMarca)
    REFERENCES Marca (IdMarca)
GO

ALTER TABLE Vehiculo
  ADD CONSTRAINT FK_Linea_TO_Vehiculo
    FOREIGN KEY (IdLinea, IdMarca)
    REFERENCES Linea (IdLinea, IdMarca)
GO

ALTER TABLE Cluster
  ADD CONSTRAINT FK_Residencial_TO_Cluster
    FOREIGN KEY (IdResidencial)
    REFERENCES Residencial (IdResidencial)
GO

ALTER TABLE VehiculoProhibido
  ADD CONSTRAINT FK_Vehiculo_TO_VehiculoProhibido
    FOREIGN KEY (IdVehiculo)
    REFERENCES Vehiculo (IdVehiculo)
GO

ALTER TABLE AsignacionTurno
  ADD CONSTRAINT FK_Empleado_TO_AsignacionTurno
    FOREIGN KEY (IdEmpleado)
    REFERENCES Empleado (IdEmpleado)
GO

ALTER TABLE AsignacionTurno
  ADD CONSTRAINT FK_Turno_TO_AsignacionTurno
    FOREIGN KEY (IdTurno)
    REFERENCES Turno (IdTurno)
GO

ALTER TABLE DetalleRecibo
  ADD CONSTRAINT FK_Recibo_TO_DetalleRecibo
    FOREIGN KEY (IdRecibo)
    REFERENCES Recibo (IdRecibo)
GO

ALTER TABLE DetalleRecibo
  ADD CONSTRAINT FK_CobroServicioVivienda_TO_DetalleRecibo
    FOREIGN KEY (idCobroServicio)
    REFERENCES CobroServicioVivienda (idCobroServicio)
GO

ALTER TABLE DetalleRecibo
  ADD CONSTRAINT FK_MultaVivienda_TO_DetalleRecibo
    FOREIGN KEY (IdMultaVivienda)
    REFERENCES MultaVivienda (IdMultaVivienda)
GO