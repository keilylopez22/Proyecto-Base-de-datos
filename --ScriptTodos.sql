--Script Keily

CREATE TABLE Persona (
    IdPersona INT NOT NULL IDENTITY (1, 1),
    PrimerNombre VARCHAR(30) NOT NULL,
    SegundoNombre VARCHAR(30) NULL,
    PrimerApellido VARCHAR(30) NOT NULL,
    SegundoApellido VARCHAR(30) NULL,
    FechaDeNacimiento DATE NOT NULL,
    Cui VARCHAR(30) NOT NULL,
    Telefono VARCHAR(30) NULL,
    Genero CHAR(1) NOT NULL CHECK (Genero IN ('M', 'F')),
    CONSTRAINT PK_Persona PRIMARY KEY CLUSTERED (IdPersona ASC)
);
GO
CREATE TABLE Cluster (
    IdCluster INT NOT NULL IDENTITY (1, 1),
    Descripcion VARCHAR(30) NULL,
    CONSTRAINT PK_Cluster PRIMARY KEY CLUSTERED (IdCluster ASC)
);
GO
CREATE TABLE Propietario (
    IdPropietario INT NOT NULL IDENTITY (1, 1),
    IdPersona INT NOT NULL,
    CONSTRAINT PK_Propietario PRIMARY KEY CLUSTERED (IdPropietario ASC)
);
GO
CREATE TABLE Residente (
    IdResidente INT NOT NULL IDENTITY (1, 1),
    IdPersona INT NOT NULL,
    NumeroVivienda INT NOT NULL,
    Estado VARCHAR(10) CHECK (Estado IN ('Activo', 'Inactivo')) NOT NULL,
    IdCluster INT NOT NULL,
    CONSTRAINT PK_Residente PRIMARY KEY CLUSTERED (IdResidente ASC)
);
GO
CREATE TABLE Vivienda (
    NumeroVivienda INT NOT NULL,
    IdCluster INT NOT NULL,
    IdPropietario INT NOT NULL,
    IdTipoVivienda INT NOT NULL,
    CONSTRAINT PK_Vivienda PRIMARY KEY CLUSTERED (
        NumeroVivienda ASC,
        IdCluster ASC)
);
GO
CREATE TABLE TipoVivienda (
    IdTipoVivienda INT NOT NULL IDENTITY (1, 1),
    Descripcion VARCHAR(50) NULL,
    NumeroHabitaciones INT NULL,
    SuperficieTotal DECIMAL(10, 2) NULL,
    NumeroPisos INT NULL,
    ServiciosIncluidos VARCHAR(200) NULL,
    Estacionamiento BIT NULL,
    CONSTRAINT PK_TipoVivienda PRIMARY KEY CLUSTERED (IdTipoVivienda ASC)
);
GO

--Scrip Delmi


CREATE TABLE TipoPago(
IdTipoPago INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (75) NOT NULL
);
CREATE TABLE Recibo(
IdRecibo INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Fecha DATE NOT NULL,
ValorTotal DECIMAL (18,2), 
IdTipoPago INT NOT NULL,
NumeroVivienda INT NOT NULL,
IdCluster INT NOT NULL,
FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda(NumeroVivienda, IdCluster),
FOREIGN KEY (IdTipoPago) REFERENCES TipoPago(IdTipoPago)
);
CREATE TABLE Planilla(
IdPlanilla INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (100),
Fecha DATE,
IdRecibo INT NOT NULL,
FOREIGN KEY (IdRecibo)  REFERENCES  Recibo (IdRecibo)
);

CREATE TABLE DetallePlanilla(
IdDetallePlanilla INT NOT NULL PRIMARY KEY IDENTITY (1,1),
IdPlanilla INT NOT NULL,
NumeroVivienda INT NOT NULL,
IdCluster INT NOT NULL,
FOREIGN KEY (IdPlanilla) REFERENCES Planilla(IdPlanilla),
FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda(NumeroVivienda, IdCluster),
);

CREATE TABLE Servicio (
IdServicio INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (100),
Valor DECIMAL (18,2) 
);
CREATE TABLE RequerimientoCobro(
IdRequerimientoC INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Fecha DATE,
IdServicio INT NOT NULL,
NumeroVivienda INT NOT NULL,
IdCluster INT NOT NULL,
FOREIGN KEY (IdServicio) REFERENCES Servicio(IdServicio),
FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda(NumeroVivienda, IdCluster),
);
CREATE TABLE DetalleServicio(
IdDetalleServicio INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Valor DECIMAL (18,2),
IdRequerimientoC INT NOT NULL,
IdRecibo INT NOT NULL, 
FOREIGN KEY (IdRequerimientoC) REFERENCES RequerimientoCobro(IdRequerimientoC),
FOREIGN KEY (IdRecibo) REFERENCES Recibo (IdRecibo)
);

--Script Chamo
CREATE TABLE Empleado (
IdEmpleado INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
IdPersona INT NOT NULL,
);

CREATE TABLE PuestoTrabajo (
IdPuestoTrabajo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ContratoTrabajo (
IdNumeroContrato INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaEmisionContrato DATE NOT NULL,
Estado VARCHAR(20) CHECK (Estado IN ('Activo', 'Inactivo', 'Finalizado', 'Suspendido')),
IdEmpleado INT NOT NULL,
IdPuestoTrabajo INT NOT NULL,
);

CREATE TABLE Turno (
IdTurno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL,
HoraInicio TIME NOT NULL,
HoraFin TIME NOT NULL,
IdPuestoTrabajo INT NOT NULL,
);

CREATE TABLE AsignacionTurno (
IdAsignacionTurno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaAsignacion DATE NOT NULL,
IdEmpleado INT NOT NULL,
IdTurno INT NOT NULL,
UNIQUE(IdEmpleado, IdTurno, FechaAsignacion)
);

CREATE TABLE Rondin (
IdRondin INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaInico DATE NOT NULL,
FechaFin DATE NOT NULL,
IdEmpleado INT,
);

CREATE TABLE DetalleDelRondin (
IdDetalleDelRondin INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Hora DATE NOT NULL,
Lugar VARCHAR(50),
IdRondin INT,
);

CREATE TABLE RegistroPersonasVisitantes (
IdRegistroPersonaVisitante INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
TipoRegistro VARCHAR(50) NOT NULL CHECK(TipoRegistro IN ('Entrada', 'Salida')),
FechaRegistro TIME NOT NULL,
TipoDocumento  VARCHAR(50) NOT NULL CHECK(TipoDocumento IN ('DPI', 'Licencia')), 
NumeroDocumento VARCHAR(50) UNIQUE,
IdVisitante INT
);

--SCRIPT Cris

CREATE TABLE Garita (
IdGarita INT PRIMARY KEY,
NombreGarita VARCHAR (50),
IdCluster INT NOT NULL
);

CREATE TABLE Vehiculo (
IdVehiculo INT PRIMARY KEY,
Placa VARCHAR(10),
Modelo VARCHAR(30),
IdLinea INT Not NULL,
IdMarca INT Not NULL,
IdResidente INT Not NULL,
IdVisitante INT Not NULL
);

CREATE TABLE Linea(
IdLinea INT PRIMARY KEY,
Descripcion VARCHAR (50),
IdMarca INT Not NULL
);

CREATE TABLE Marca (
IdMarca INT PRIMARY KEY,
Descripcion VARCHAR(50)
);

CREATE TABLE Visitante (
IdVisitante INT PRIMARY KEY,
IdPersona INT NOT NULL,
IdCluster INT NOT NULL,
NumeroVivienda INT NOT NULL
);

CREATE TABLE RegistroVehiculos (
IdRegistroVehiculo INT PRIMARY KEY,
FechaHoraEntrada DATE,
FechaHoraSalida DATE,
Observaciones VARCHAR(50),
IdGarita INT NOT NULL,
IdVehiculo INT NOT NULL,
IdVisitante INT NOT NULL,
IdResidente INT NOT NULL
);

CREATE TABLE ListaNegra (
IdListaNegra INT PRIMARY KEY,
Causa VARCHAR (100),
FechaDeclaradoNoGrato DATE,
IdVehiculo INT NOT NULL,
IdVisitante INT NOT NULL
);

--Alter tables Keily

ALTER TABLE Vivienda
ADD CONSTRAINT FK_Vivienda_Cluster FOREIGN KEY (IdCluster) REFERENCES Cluster (IdCluster)

ALTER TABLE Vivienda
ADD CONSTRAINT FK_Vivienda_Propietario FOREIGN KEY (IdPropietario) REFERENCES Propietario (IdPropietario)

GO

ALTER TABLE Vivienda
ADD CONSTRAINT FK_Vivienda_TipoVivienda FOREIGN KEY (IdTipoVivienda) REFERENCES TipoVivienda (IdTipoVivienda)

GO

ALTER TABLE Residente
ADD CONSTRAINT FK_Residente_Persona FOREIGN KEY (IdPersona) REFERENCES Persona (IdPersona)

GO

ALTER TABLE Residente
ADD CONSTRAINT FK_Residente_Vivienda FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda (NumeroVivienda, IdCluster)




GO
ALTER TABLE Propietario
ADD CONSTRAINT FK_Propietario_Persona FOREIGN KEY (IdPersona) REFERENCES Persona (IdPersona)

--Alter tables Chamo
ALTER TABLE Empleado
ADD CONSTRAINT FK_Empleado_Persona FOREIGN KEY (IdPersona) REFERENCES Persona (IdPersona)

ALTER TABLE ContratoTrabajo
ADD CONSTRAINT FK_ContratoTrabajo_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)

ALTER TABLE ContratoTrabajo
ADD CONSTRAINT FK_ContratoTrabajo_PuestoTrabajo FOREIGN KEY (IdPuestoTrabajo) REFERENCES PuestoTrabajo (IdPuestoTrabajo)

ALTER TABLE Turno
ADD CONSTRAINT FK_Turno_PuestoTrabajo FOREIGN KEY (IdPuestoTrabajo) REFERENCES PuestoTrabajo (IdPuestoTrabajo)

ALTER TABLE AsignacionTurno
ADD CONSTRAINT FK_AsignacionTurno_Turno FOREIGN KEY (IdTurno) REFERENCES Turno (IdTurno)

ALTER TABLE AsignacionTurno
ADD CONSTRAINT FK_AsignacionTurno_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)

ALTER TABLE Rondin
ADD CONSTRAINT FK_Rondin_Empleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado (IdEmpleado)

ALTER TABLE DetalleDelRondin
ADD CONSTRAINT FK_DetalleDelRondin_Rondin FOREIGN KEY (IdRondin) REFERENCES Rondin (IdRondin)

ALTER TABLE RegistroPersonasVisitantes
ADD CONSTRAINT FK_RegistroPersonasVisitantes_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante (IdVisitante)

ALTER TABLE Garita
ADD CONSTRAINT FK_Garita_RegistroPersonaVisitantes FOREIGN KEY (IdRegistroPersonaVisitante) REFERENCES RegistroPersonasVisitantes(IdRegistroPersonaVisitante)

--ALTER TABLE Cris

--GARITA
ALTER TABLE Garita
ADD CONSTRAINT FK_Garita_Cluster FOREIGN KEY (IdCluster) REFERENCES Cluster (IdCluster);

--Visitante
ALTER TABLE Visitante
ADD CONSTRAINT FK_Visitante_Persona FOREIGN KEY (IdPersona) REFERENCES Persona(IdPersona);

ALTER TABLE Visitante
ADD CONSTRAINT FK_Visitante_Vivienda FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda(NumeroVivienda, IdCluster);

--LINEA
ALTER TABLE Linea
ADD CONSTRAINT FK_Linea_Marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca);

--VEHICULO
ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Linea FOREIGN KEY (IdLinea) REFERENCES Linea(IdLinea);

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca);

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Residente FOREIGN KEY (IdResidente) REFERENCES Residente(IdResidente);

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

--REGISTRO VEHICULOS
ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo);

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Residente FOREIGN KEY (IdResidente) REFERENCES Residente(IdResidente);

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Garita FOREIGN KEY (IdGarita) REFERENCES Garita(IdGarita);

--LISTA NEGRA
ALTER TABLE ListaNegra
ADD CONSTRAINT FK_ListaNegra_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo);

ALTER TABLE ListaNegra
ADD CONSTRAINT FK_ListaNegra_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

ALTER TABLE Garita
ADD  IdRegistroPersonaVisitante INT NOT NULL;