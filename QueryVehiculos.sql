CREATE TABLE Garita (
IdGarita INT IDENTITY PRIMARY KEY,
NombreGarita VARCHAR (50),
IdCluster INT NOT NULL
);

GO

CREATE TABLE Vehiculo (
IdVehiculo INT IDENTITY PRIMARY KEY,
Placa VARCHAR(10),
Modelo VARCHAR(30),
IdLinea INT Not NULL,
IdMarca INT Not NULL,
IdResidente INT Not NULL,
IdVisitante INT Not NULL
);

GO

CREATE TABLE Linea(
IdLinea INT IDENTITY PRIMARY KEY,
Descripcion VARCHAR (50),
IdMarca INT Not NULL
);

CREATE TABLE Marca (
IdMarca INT IDENTITY PRIMARY KEY,
Descripcion VARCHAR(50)
);

GO

--registra a las personas que llegan de visita
CREATE TABLE Visitante (
IdVisitante INT IDENTITY PRIMARY KEY,
FechaEntrada DATETIME,
FechaSalida DATETIME,
TipoDocumento  VARCHAR(50) NOT NULL CHECK(TipoDocumento IN ('DPI', 'Licencia')), 
NumeroDocumento VARCHAR(50),
IdPersona INT NOT NULL,
IdCluster INT NOT NULL,
NumeroVivienda INT NOT NULL,
IdGarita INT NOT NULL,
IdEmpleado INT NOT NULL
);

GO

--Registra entradas/salidas de vehiculos.
CREATE TABLE RegistroVehiculos (
IdRegistroVehiculo INT IDENTITY PRIMARY KEY,
FechaHoraEntrada DATE,
FechaHoraSalida DATE,
Observaciones VARCHAR(50),
IdGarita INT NOT NULL,
IdVehiculo INT NOT NULL,
IdVisitante INT NOT NULL,
IdResidente INT NOT NULL
);

GO

CREATE TABLE ListaNegra (
IdListaNegra INT IDENTITY PRIMARY KEY,
Causa VARCHAR (100),
FechaDeclaradoNoGrato DATE,
IdVehiculo INT NOT NULL,
IdVisitante INT NOT NULL
);

GO

--ALTER TABLE

--GARITA
ALTER TABLE Garita
ADD CONSTRAINT FK_Garita_Cluster FOREIGN KEY (IdCluster) REFERENCES Cluster (IdCluster);

GO

--Visitante
ALTER TABLE Visitante
ADD CONSTRAINT FK_Visitante_Persona FOREIGN KEY (IdPersona) REFERENCES Persona(IdPersona);

GO

ALTER TABLE Visitante
ADD CONSTRAINT FK_Visitante_Vivienda FOREIGN KEY (NumeroVivienda, IdCluster) REFERENCES Vivienda(NumeroVivienda, IdCluster);

GO

--LINEA
ALTER TABLE Linea
ADD CONSTRAINT FK_Linea_Marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca);

GO

--VEHICULO
ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Linea FOREIGN KEY (IdLinea) REFERENCES Linea(IdLinea);

GO

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca);

GO

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Residente FOREIGN KEY (IdResidente) REFERENCES Residente(IdResidente);

GO

ALTER TABLE Vehiculo
ADD CONSTRAINT FK_Vehiculo_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

GO

--REGISTRO VEHICULOS
ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo);

GO

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

GO

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Residente FOREIGN KEY (IdResidente) REFERENCES Residente(IdResidente);

GO

ALTER TABLE RegistroVehiculos
ADD CONSTRAINT FK_Registro_Garita FOREIGN KEY (IdGarita) REFERENCES Garita(IdGarita);

GO

--LISTA NEGRA
ALTER TABLE ListaNegra
ADD CONSTRAINT FK_ListaNegra_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo);

GO

ALTER TABLE ListaNegra
ADD CONSTRAINT FK_ListaNegra_Visitante FOREIGN KEY (IdVisitante) REFERENCES Visitante(IdVisitante);

GO
