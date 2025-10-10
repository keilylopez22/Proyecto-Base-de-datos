CREATE TABLE JuntaDirectiva
(IdJuntaDirectiva INT IDENTITY (1,1) NOT NULL,
IdCluster INT NOT NULL,
FechaInicio DATE,
FechaFin DATE,
Estado VARCHAR(100) NOT NULL CHECK (Estado IN ('ACTIVO', 'INACTIVO'))
CONSTRAINT PKJuntaDirectiva PRIMARY KEY (IdJuntaDirectiva ASC)
);
GO
CREATE TABLE PuestoJuntaDirectiva
(IdPuestoJuntaDirectiva INT NOT NULL IDENTITY (1, 1),
Nombre VARCHAR (15),
Descripcion VARCHAR (100)
CONSTRAINT PKPuestoJuntaDirectiva PRIMARY KEY (IdPuestoJuntaDirectiva ASC)
);
GO
CREATE TABLE MiembroJuntaDirectiva
(IdJuntaDirectiva INT NOT NULL,
IdPropietario INT NOT NULL,
IdPuestoJuntaDirectiva INT NOT NULL
CONSTRAINT PKMiembroJuntaDirectiva PRIMARY KEY (IdJuntaDirectiva ASC,
IdPropietario ASC,
IdPuestoJuntaDirectiva ASC)
);
GO
ALTER TABLE JuntaDirectiva
ADD CONSTRAINT FK_JuntaDirectiva_Cluster FOREIGN KEY (IdCluster) REFERENCES Cluster (IdCluster)
GO
ALTER TABLE MiembroJuntaDirectiva
ADD CONSTRAINT FK_MiembroJuntaDirectiva_JuntaDirectiva FOREIGN KEY (IdJuntaDirectiva) REFERENCES JuntaDirectiva (IdJuntaDirectiva)
GO
ALTER TABLE MiembroJuntaDirectiva
ADD CONSTRAINT FK_MiembroJuntaDirectiva_Propietario FOREIGN KEY (IdPropietario) REFERENCES Propietario (IdPropietario)
go
ALTER TABLE MiembroJuntaDirectiva
ADD CONSTRAINT FK_MiembroJuntaDirectiva_PuestoJuntaDirectiva FOREIGN KEY (IdPuestoJuntaDirectiva) REFERENCES PuestoJuntaDirectiva(IdPuestoJuntaDirectiva)