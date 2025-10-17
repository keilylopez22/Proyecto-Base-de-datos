--se crean estas tablas para poder cumplir con lo que pide el sp 18 

CREATE TABLE DocumentoPersona
(
  NumeroDocumento int         NOT NULL,
  IdTipoDocumento Int         NOT NULL,
  IdPersona       int         NOT NULL,
  Observaciones   varchar(50),
  CONSTRAINT PK_DocumentoPersona PRIMARY KEY (IdTipoDocumento, IdPersona)
)
GO
ALTER TABLE DocumentoPersona
  ADD CONSTRAINT FK_TipoDocumento_TO_DocumentoPersona
    FOREIGN KEY (IdTipoDocumento)
    REFERENCES TipoDocumento (IdTipoDocumento)
GO

ALTER TABLE DocumentoPersona
  ADD CONSTRAINT FK_Persona_TO_DocumentoPersona
    FOREIGN KEY (IdPersona)
    REFERENCES Persona (IdPersona)
GO
--Se agrego esta relacion para el sp 14
ALTER TABLE Recibo 
ADD NumeroVivienda INT, IdCluster INT
GO
ALTER TABLE Recibo
  ADD CONSTRAINT FK_Vivienda_TO_Recibo
    FOREIGN KEY (NumeroVivienda, IdCluster)
    REFERENCES Vivienda (NumeroVivienda, IdCluster)