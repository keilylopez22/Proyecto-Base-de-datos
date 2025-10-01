CREATE TABLE Empleado (
EmpleadoID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
PersonaID INT NOT NULL,
--FOREIGN KEY (IdPersona) REFERENCES Persona(IdPersona)
);

CREATE TABLE PuestoTrabajo (
CodigoPuestoTrabajo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE ContratoTrabajo (
NumeroContrato INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaEmisionContrato DATE NOT NULL,
Estado VARCHAR(20) CHECK (Estado IN ('Activo', 'Inactivo', 'Finalizado', 'Suspendido')),
IdPersona INT NOT NULL,
CodigoPuestoTrabajo INT NOT NULL,
--FOREIGN KEY (IdPersona) REFERENCES Empleado(IdPersona),
--FOREIGN KEY (CodigoPuestoTrabajo) REFERENCES PuestoTrabajo(CodigoPuestoTrabajo)
);

CREATE TABLE Turno (
TurnoID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL,
HoraInicio TIME NOT NULL,
HoraFin TIME NOT NULL,
DuracionTurno CHECK(DATEDIFF(HOURS, HoraInicio, HoraFin) <= 24),
CodigoPuestoTrabajo INT NOT NULL,
--FOREIGN KEY (CodigoPuestoTrabajo) REFERENCES PuestoTrabajo(CodigoPuestoTrabajo)
);

CREATE TABLE AsignacionTurno (
AsignacionTurnoID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaAsignacion DATE NOT NULL,
EmpleadoID INT NOT NULL,
TurnoID INT NOT NULL,
UNIQUE(EmpleadoID, TurnoID, FechaAsignacion)
--FOREIGN KEY (IdPersona) REFERENCES Empleado(IdPersona),
--FOREIGN KEY (TurnoID) REFERENCES Turno(TurnoID), 
--UNIQUE (IdPersona, TurnoID, FechaAsignacion)
);

CREATE TABLE Rondin (
RondinID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaInico DATE NOT NULL,
FechaFin DATE NOT NULL,
IdPersona INT,
--FOREIGN KEY (IdPersona) REFERENCES Empleado(EmpleadoID)
);

CREATE TABLE DetalleDelRondin (
DetalleDelRondinID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Hora DATE NOT NULL,
Lugar VARCHAR(50),
RondinID INT,
--FOREIGN KEY (RondinID) Rondin Empleado(RondinID)
);

CREATE TABLE RegistroPersonasVisitantes (
IdRegistroPersonaVisitante INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
TipoRegistro VARCHAR(50) NOT NULL CHECK(TipoRegistro IN ('Entrada', 'Salida')),
FechaRegistro TIME NOT NULL,
TipoDocumento  VARCHAR(50) NOT NULL CHECK(TipoDocumento IN ('DPI', 'Licencia')), 
NumeroDocumento VARCHAR(50) UNIQUE,
VisitanteID INT
--FOREIGN KEY (VisitanteID) REFERENCES Visitante(VisitanteID)
);
