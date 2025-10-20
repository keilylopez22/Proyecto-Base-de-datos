
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

INSERT INTO DocumentoPersona (NumeroDocumento, IdTipoDocumento, IdPersona, Observaciones)
VALUES
(123456, 1, 1, 'Documento principal'),
(654321, 4, 2, 'Documento secundario'),
(789012, 3, 3, 'Sin observaciones')


INSERT INTO TipoDocumento (Nombre)
VALUES
('Licencia Tipo A')
DELETE DocumentoPersona
