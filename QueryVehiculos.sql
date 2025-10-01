CREATE TABLE Garita (
IdGarita INT PRIMARY KEY,
NombreGarita VARCHAR (50),
IdCluster INT,
IdRegistroVehiculo INT,
--FOREIGN KEY (IdCluster) REFERENCES  Cluster(IdCluster),
--FOREIGN KEY (IdRegistroVehiculo) REFERENCES  RegistroVehiculos(IdRegistroVehiculo)
);

CREATE TABLE Vehiculo (
IdVehiculo INT PRIMARY KEY,
Placa VARCHAR(10),
Modelo VARCHAR(30),
IdLinea INT,
IdMarca INT,
IdResidente INT,
IdVisitante INT,
--FOREIGN KEY (IdLinea) REFERENCES  Linea(IdLinea),
--FOREIGN KEY (IdMarca) REFERENCES  Marca(IdMarca),
--FOREIGN KEY (IdResidente) REFERENCES  Residente(IdResidente),
--FOREIGN KEY (IdVisitante) REFERENCES  Visitante(IdVisitante)
);

CREATE TABLE Linea(
IdLinea INT PRIMARY KEY,
Descripcion VARCHAR (50),
IdMarca INT,
--FOREIGN KEY (IdMarca) REFERENCES  Marca(IdMarca)
);

CREATE TABLE Marca (
IdMarca INT PRIMARY KEY,
Descripcion VARCHAR(50)
)

CREATE TABLE Visitante (
IdVisitante INT PRIMARY KEY,
IdPersona INT,
IdVivienda INT,
--FOREIGN KEY (IdPersona) REFERENCES  Persona(IdPersona),
--FOREIGN KEY (IdVivienda) REFERENCES  Vivienda(IdVivienda)
);

CREATE TABLE RegistroVehiculos (
IdRegistroVehiculo INT PRIMARY KEY,
FechaHoraEntrada DATE,
FechaHoraSalida DATE,
Observaciones VARCHAR(50),
IdVehiculo INT,
IdVisitante INT,
IdResidente INT,
--FOREIGN KEY (IdVehiculo) REFERENCES  Vehiculo(IdVehiculo),
--FOREIGN KEY (IdVisitante) REFERENCES  Visitante(IdVisitante),
--FOREIGN KEY (IdResidente) REFERENCES  Residente(IdResidente)
);

CREATE TABLE ListaNegra (
IdListaNegra INT PRIMARY KEY,
Causa VARCHAR (100),
FechaDeclaradoNoGrato DATE,
IdVehiculo INT,
IdVisitante INT,
--FOREIGN KEY (IdVehiculo) REFERENCES  Vehiculo(IdVehiculo),
--FOREIGN KEY (IdVistante) REFERENCES  Visitante(IdVistante)
);