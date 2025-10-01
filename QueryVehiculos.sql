CREATE TABLE Garita (
IdGarita INT PRIMARY KEY,
NombreGarita VARCHAR (50),
--FOREIGN KEY (IdCluster) REFERENCES  Cluster(IdCluster),
--FOREIGN KEY (IdRegistroVehiculo) REFERENCES  RegistroVehiculos(IdRegistroVehiculo)
);

CREATE TABLE Vehiculo (
IdVehiculo INT PRIMARY KEY,
Placa VARCHAR(10),
Modelo VARCHAR(30),
--FOREIGN KEY (IdLinea) REFERENCES  Linea(IdLinea),
--FOREIGN KEY (IdMarca) REFERENCES  Marca(IdMarca),
--FOREIGN KEY (IdResidente) REFERENCES  Residente(IdResidente),
--FOREIGN KEY (IdVisitante) REFERENCES  Visitante(IdVisitante)
);

CREATE TABLE Linea(
IdLinea INT PRIMARY KEY,
Descripcion VARCHAR (50),
--FOREIGN KEY (IdMarca) REFERENCES  Marca(IdMarca)
);

CREATE TABLE Marca (
IdMarca INT PRIMARY KEY,
Descripcion VARCHAR(50)
)

CREATE TABLE Residente (
IdResidente INT PRIMARY KEY,
--FOREIGN KEY (IdPersona) REFERENCES  Persona(IdPersona),
--FOREIGN KEY (IdVivienda) REFERENCES  Vivienda(IdVivienda)
);

CREATE TABLE Visitante (
IdVisitante INT PRIMARY KEY,
--FOREIGN KEY (IdPersona) REFERENCES  Persona(IdPersona),
--FOREIGN KEY (IdVivienda) REFERENCES  Vivienda(IdVivienda)
);

CREATE TABLE RegistroVehiculos (
IdRegistroVehiculo INT PRIMARY KEY,
FechaHoraEntrada DATE,
FechaHoraSalida DATE,
Observaciones VARCHAR(50),
--FOREIGN KEY (IdVehiculo) REFERENCES  Vehiculo(IdVehiculo),
--FOREIGN KEY (IdVisitante) REFERENCES  Visitante(IdVisitante),
--FOREIGN KEY (IdResidente) REFERENCES  Residente(IdResidente)
);

CREATE TABLE ListaNegra (
IdListaNegra INT PRIMARY KEY,
Causa VARCHAR (100),
FechaDeclaradoNoGrato DATE,
--FOREIGN KEY (IdVehiculo) REFERENCES  Vehiculo(IdVehiculo),
--FOREIGN KEY (IdVistante) REFERENCES  Visitante(IdVistante)

);