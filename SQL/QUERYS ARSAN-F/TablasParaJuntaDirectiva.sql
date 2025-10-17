CREATE TABLE JuntaDirectiva
(
  IdJuntaDirectiva Int NOT NULL IDENTITY(1,1),
  IdCluster        INT NOT NULL,
  CONSTRAINT PK_JuntaDirectiva PRIMARY KEY (IdJuntaDirectiva)
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

CREATE TABLE PuestoJuntaDirectiva
(
  idPuesto    int          NOT NULL IDENTITY(1,1),
  Nombre      varchar      NOT NULL,
  Descripcion varchar(100),
  CONSTRAINT PK_PuestoJuntaDirectiva PRIMARY KEY (idPuesto)
)
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
