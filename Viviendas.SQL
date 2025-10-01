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
) ON PRIMARY;
GO
CREATE TABLE Cluster (
    IdCluster INT NOT NULL IDENTITY (1, 1),
    Descripcion VARCHAR(30) NULL,
    CONSTRAINT PK_Cluster PRIMARY KEY CLUSTERED (IdCluster ASC)
) ON PRIMARY;
GO
CREATE TABLE Propietario (
    IdPropietario INT NOT NULL IDENTITY (1, 1),
    IdPersona INT NOT NULL,
    CONSTRAINT PK_Propietario PRIMARY KEY CLUSTERED (IdPropietario ASC)
) ON PRIMARY;
GO
CREATE TABLE Residente (
    IdResidente INT NOT NULL IDENTITY (1, 1),
    IdPersona INT NOT NULL,
    NumeroVivienda INT NOT NULL,
    Estado VARCHAR(10) CHECK (Estado IN ('Activo', 'Inactivo')) NOT NULL,
    IdCluster INT NOT NULL,
    CONSTRAINT PK_Residente PRIMARY KEY CLUSTERED (IdResidente ASC)
) ON PRIMARY;
GO
CREATE TABLE Vivienda (
    NumeroVivenda INT NOT NULL,
    IdCluster INT NOT NULL,
    IdPropietario INT NOT NULL,
    IdTipoVivienda INT NOT NULL,
    CONSTRAINT PK_Vivienda PRIMARY KEY CLUSTERED (
        NumeroVivienda ASC,
        IdCluster ASC
    )
) ON PRIMARY;
GO
CREATE TABLE TipoVivienda (
    IdTipoDeVivienda INT NOT NULL IDENTITY (1, 1),
    Descripcion VARCHAR(50) NULL,
    NumeroHabitaciones INT NULL,
    SuperficieTotal DECIMAL(10, 2) NULL,
    NumeroPisos INT NULL,
    ServiciosIncluidos VARCHAR(200) NULL,
    Estacionamiento BIT NULL,
    CONSTRAINT PK_TipoVivienda PRIMARY KEY CLUSTERED (IdTipoVivienda ASC)
) ON PRIMARY;
GO

ALTER TABLE nombre_tabla_hija
ADD CONSTRAINT nombre_fk FOREIGN KEY (columna_fk) REFERENCES nombre_tabla_padre (columna_pk);

--Alter tables

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
ADD CONSTRAINT FK_Residente_Vivienda FOREIGN KEY (NumeroVivienda) REFERENCES Vivienda (NumeroVivienda)

GO

ALTER TABLE Residente
ADD CONSTRAINT FK_Residente_Cluster  FOREIGN KEY (IdCluster) ReFERENCES Cluster (IdCluster)
GO
ALTER TABLE Propietario
ADD CONSTRAINT FK_Propietario_Persona FOREIGN KEY (IdPersona) REFERENCES Persona (IdPersona)