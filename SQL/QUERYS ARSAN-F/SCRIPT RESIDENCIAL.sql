CREATE TABLE Residencial
(
  IdResidencial int     NOT NULL IDENTITY(1,1),
  Nombre        varchar(25) NOT NULL,
  CONSTRAINT PK_Residencial PRIMARY KEY (IdResidencial)
)
GO
INSERT INTO Residencial(Nombre) 
VALUES ('SAN FRANCISCO');

GO

UPDATE Cluster
    SET IdResidencial = 1
GO
ALTER TABLE Cluster
  ADD CONSTRAINT FK_Residencial_TO_Cluster
    FOREIGN KEY (IdResidencial)
    REFERENCES Residencial (IdResidencial)