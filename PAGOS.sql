
CREATE TABLE TipoPago(
IdTipoPago INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (75) NOT NULL
);
CREATE TABLE Recibo(
IdRecibo INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Fecha DATE NOT NULL,
ValorTotal DECIMAL (18,2), 
IdTipoPago INT NOT NULL,
IdVivienda INT NOT NULL,
FOREIGN KEY (IdVivienda) REFERENCES Vivienda(IdVivienda),
FOREIGN KEY (IdTipoPago) REFERENCES TipoPago(IdTipoPago)
);
CREATE TABLE Planilla(
IdPlanilla INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (100),
Fecha DATE,
IdRecibo INT NOT NULL,
FOREIGN KEY (IdRecibo)  REFERENCES  Recibo (IdRecibo)
);

CREATE TABLE DetallePlanilla(
IdDetallePlanilla INT NOT NULL PRIMARY KEY IDENTITY (1,1),
IdPlanilla INT NOT NULL,
IdVivienda INT NOT NULL,
FOREIGN KEY (IdPlanilla) REFERENCES Planilla(IdPlanilla),
FOREIGN KEY (IdVivienda) REFERENCES Vivienda(IdVivienda)
);

CREATE TABLE Servicio (
IdServicio INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Descripcion VARCHAR (100),
Valor DECIMAL (18,2) 
);
CREATE TABLE RequerimientoCobro(
IdRequerimientoC INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Fecha DATE,
IdServicio INT NOT NULL,
IdVivienda INT NOT NULL,
FOREIGN KEY (IdServicio) REFERENCES Servicio(IdServicio),
FOREIGN KEY (IdVivienda) REFERENCES Vivienda(IdVivienda)
);
CREATE TABLE DetalleServicio(
IdDetalleServicio INT NOT NULL PRIMARY KEY IDENTITY (1,1),
Valor DECIMAL (18,2),
IdRequerimientoC INT NOT NULL,
IdRecibo INT NOT NULL, 
FOREIGN KEY (IdRequerimientoC) REFERENCES RequerimientoCobro(IdRequerimientoC),
FOREIGN KEY (IdRecibo) REFERENCES Recibo (IdRecibo)
);
