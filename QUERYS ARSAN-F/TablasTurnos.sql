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