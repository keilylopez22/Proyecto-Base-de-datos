--Insert para viviendas

--INSERT INTO nombre_tabla (columna1, columna2, columna3)
--VALUES (valor1, valor2, valor3);

Alter table TipoVivienda 
ADD Precio DECIMAL(10, 2) NULL;


INSERT INTO Persona  (PrimerNombre, SegundoNombre,PrimerApellido, SegundoApellido, FechaDeNacimiento, Cui, Telefono, Genero)
VALUES  ('Keily', null, 'Lopez', 'Hernandez', '2002-03-18', '09072321839', '40338234', 'F'),
        ('Cristhian', 'Eduardo', 'Lopez', 'Lemus', '1998-06-15', '290289065102', '55123402', 'M'),
        ('Delmi', NULL, 'Maria', 'Fajardo', '2000-11-22', '290371056103', '55123403', 'F'),
        ('Cristian', 'Eduardo', 'Chamo', 'Morales', '1995-09-05', '290460345104', '55123404', 'M'),
        ('Ana', 'Laura', 'Oliva', NULL, '2001-12-30', '290558934105', '55123405', 'F'),
        ('Ergil', 'Isaias', 'Cardenas', 'Cruz', '1998-06-25', '290647823106', '55123406', 'M'),
        ('Fredy', NULL, 'Cardona', 'Montenegro', '2000-11-20', '290736712107', '55123407', 'M'),
        ('Fernando', 'Jose', 'Carranza', 'Cabrera', '1995-09-15', '290825601108', '55123408', 'M'),
        ('Ludin', 'Eduardo', 'Carranza', 'Guerra', '2001-12-28', '290914590109', '55123409', 'M'),
        ('Diego', 'Alexander', 'Contreras', 'Duarte', '1998-06-10', '291003489110', '55123410', 'M'),
        ('Ricardo', 'Enrrique', 'Hernandez', 'Chavez', '2000-11-25', '291192378111', '55123411', 'M'),
        ('Luis', 'Carlos', 'Lima', 'Perez', '1995-09-10', '291281267112', '55123412', 'M'),
        ('Dereck', 'Leonel', 'Marmol', 'Salguero', '2001-12-25', '291370156113', '55123413', 'M'),
        ('Sinthia', 'Celeste', 'Orellana', 'Galeano', '1998-06-05', '291459045114', '55123414', 'F'),
        ('Daniel', 'Alexander', 'Ortiz', 'Cabrera', '2000-11-15', '291548934115', '55123415', 'M'),
        ('Astrid', 'Mileidy', 'Peña', 'Polanco', '1995-09-20', '291637823116', '55123416', 'F'),
        ('Maria', 'Jose', 'Del Carmen', 'Portillo', '2001-12-20', '291726712117', '55123417', 'F'),
        ('Enma', 'Leticia', 'Ramirez', 'Castro', '1998-06-01', '291815601118', '55123418', 'F'),
        ('Aura', 'Lucia', 'Snadoval', 'Pivaral', '2000-11-10', '291904590119', '55123419', 'F'),
        ('Andreina', 'Jannin', 'Ulloa', 'Tellez', '1995-09-25', '292093489120', '55123420', 'F'),
        ('David', 'Alejandro', 'Perez', 'Garcia', '1950-04-10', '100182736121', '55123421', 'M'), 
        ('Elsa', 'Maria', 'Soto', 'Juarez', '1955-08-01', '100271625122', '55123422', 'F'), 
        ('Valeria', 'Sofia', 'Contreras', 'Duarte', '2024-05-01', '100360514123', '55123423', 'F'), 
        ('Juan', 'Jose', 'Lopez', 'Hernandez', '2016-11-17', '100459403124', '55123424', 'M'), 
        ('Lucia', 'Fernanda', 'Morales', 'Ramos', '2010-07-25', '100548392125', '55123425', 'F'), 
        ('Jorge', 'Alberto', 'Reyes', 'Soliz', '1985-02-14', '100637281126', '55123426', 'M'),
        ('Susana', 'Carolina', 'Guzman', 'Mendez', '1990-09-09', '100726170127', '55123427', 'F'), 
        ('Marco', 'Antonio', 'Carranza', 'Cabrera', '1970-12-05', '100815069128', '55123428', 'M'), 
        ('Maria', 'Elena', 'Lopez', 'Lemus', '2022-02-10', '100904958129', '55123429', 'F'), 
        ('Carlos', 'Andres', 'Perez', 'Garcia', '2006-03-03', '101093847130', '55123430', 'M'), 
        ('Ana', 'Beatriz', 'Perez', 'Garcia', '2008-04-04', '101182736131', '55123431', 'F'), 
        ('Roberto', 'Manuel', 'Solis', 'Ventura', '1980-05-20', '101271625132', '55123432', 'M'), 
        ('Gabriela', 'Paola', 'Monzon', 'Herrera', '1992-10-10', '101360514133', '55123433', 'F'), 
        ('Felipe', 'Santiago', 'Oliva', 'Cruz', '2018-01-01', '101459403134', '55123434', 'M'), 
        ('Juana', 'Rosa', 'Sanchez', 'Gomez', '1940-07-07', '101548392135', '55123435', 'F'); 

GO

INSERT INTO Cluster(Descripcion)
VALUES ('Sector A -Casas grandes'),
        ('Sector B -Casas medianas'),
        ('Sector C -Casas pequeñas'),
        ('Sector D -Apartamentos'),
        ('Sector E -Fases Nuevas');


GO

INSERT INTO TipoVivienda (Descripcion, NumeroHabitaciones, SuperficieTotal, NumeroPisos, ServiciosIncluidos, Estacionamiento, Precio)
VALUES ('Casa Modelo Grande', 6, 400.00, 2, '', 1, 20000 ),
         ('Casa Modelo Mediana', 4, 250.00, 2, '', 1, 20000 ),
         ('Casa Modelo Pequeña', 3, 150.00, 1, '', 1, 20000 ),
         ('Apartamento Modelo A', 3, 120.00, 1, '', 1, 20000 ),
         ('Apartamento Modelo B', 2, 80.00, 1, '', 1, 20000);
        



GO


INSERT INTO Propietario (IdPersona)
Select top 20 IdPersona from Persona



GO
--NumeroVivienda, IdCluster, IdPropietario, IdTipoVivienda
Insert into Vivienda(NumeroVivienda, IdCluster,  IdTipoVivienda)
Select  CAST(C.IdCluster AS varchar(10))  +''+ CAST(ROW_NUMBER() OVER(ORDER BY C.IdCluster)AS VARCHAR(10))AS NumeroVivienda, IdCluster , TV.IdTipoVivienda
From Cluster AS C,
TipoVivienda AS TV

 



GO

Insert into Residente (IdPersona, Estado)
Select IdPersona, 'Activo' from Persona

      