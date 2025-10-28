ALTER TABLE Vivienda 
DROP CONSTRAINT FK_Propietario_TO_Vivienda

ALTER TABLE Vivienda 
DROP COLUMN IdPropietario

ALTER TABLE Vivienda
ADD IdPropietario INT NULL

ALTER TABLE Vivienda
  ADD CONSTRAINT FK_Propietario_TO_Vivienda
    FOREIGN KEY (IdPropietario)
    REFERENCES Propietario (IdPropietario)
GO


