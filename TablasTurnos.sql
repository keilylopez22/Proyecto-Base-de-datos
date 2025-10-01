CREATE TABLE Empleado (
IdEmpleado INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
IdPersona INT NOT NULL,
--FOREIGN KEY (IdPersona) REFERENCES Persona(IdPersona)
);

CREATE TABLE PuestoTrabajo (
IdPuestoTrabajo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL UNIQUEs
);

CREATE TABLE ContratoTrabajo (
IdNumeroContrato INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaEmisionContrato DATE NOT NULL,
Estado VARCHAR(20) CHECK (Estado IN ('Activo', 'Inactivo', 'Finalizado', 'Suspendido')),
IdEmpleado INT NOT NULL,
IdPuestoTrabajo INT NOT NULL,
--FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
--FOREIGN KEY (IdPuestoTrabajo) REFERENCES PuestoTrabajo(IdPuestoTrabajo)
);

CREATE TABLE Turno (
IdTurno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Descripcion VARCHAR(50) NOT NULL,
HoraInicio TIME NOT NULL,
HoraFin TIME NOT NULL,
DuracionTurno CHECK(DATEDIFF(HOURS, HoraInicio, HoraFin) <= 24),
IdPuestoTrabajo INT NOT NULL,
--FOREIGN KEY (IdPuestoTrabajo) REFERENCES PuestoTrabajo(IdPuestoTrabajo)
);

CREATE TABLE AsignacionTurno (
IdAsignacionTurno INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaAsignacion DATE NOT NULL,
IdEmpleado INT NOT NULL,
IdTurno INT NOT NULL,
UNIQUE(EmpleadoID, TurnoID, FechaAsignacion)
--FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado),
--FOREIGN KEY (IdTurno) REFERENCES Turno(IdTurno), 
--UNIQUE (IdEmpleado, IdTurno, FechaAsignacion)
);

CREATE TABLE Rondin (
IdRondin INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
FechaInico DATE NOT NULL,
FechaFin DATE NOT NULL,
IdEmpleado INT,
--FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado)
);

CREATE TABLE DetalleDelRondin (
IdDetalleDelRondin INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Hora DATE NOT NULL,
Lugar VARCHAR(50),
IdRondin INT,
--FOREIGN KEY (IdRondin) Rondin Empleado(IdRondin)
);

CREATE TABLE RegistroPersonasVisitantes (
IdRegistroPersonaVisitante INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
TipoRegistro VARCHAR(50) NOT NULL CHECK(TipoRegistro IN ('Entrada', 'Salida')),
FechaRegistro TIME NOT NULL,
TipoDocumento  VARCHAR(50) NOT NULL CHECK(TipoDocumento IN ('DPI', 'Licencia')), 
NumeroDocumento VARCHAR(50) UNIQUE,
IdVisitante INT
--FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante)
);
