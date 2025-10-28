ALTER TABLE Pago
  DROP CONSTRAINT FK_TipoPago_TO_Pago

ALTER TABLE Pago
DROP COLUMN Referencia, idTipoPago

CREATE TABLE DetallePago
(
  IdDetallePago int         NOT NULL IDENTITY(1,1),
  Monto         decimal     NOT NULL,
  idTipoPago    int         NOT NULL,
  IdPago        int         NOT NULL,
  Referencia    varchar(50),
  CONSTRAINT PK_DetallePago PRIMARY KEY (IdDetallePago)
)
GO



ALTER TABLE DetallePago
  ADD CONSTRAINT FK_TipoPago_TO_DetallePago
    FOREIGN KEY (idTipoPago)
    REFERENCES TipoPago (idTipoPago)
GO

ALTER TABLE DetallePago
  ADD CONSTRAINT FK_Pago_TO_DetallePago
    FOREIGN KEY (IdPago)
    REFERENCES Pago (IdPago)