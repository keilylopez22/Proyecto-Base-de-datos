--Insert para viviendas

--INSERT INTO nombre_tabla (columna1, columna2, columna3)
--VALUES (valor1, valor2, valor3);

Alter table TipoVivienda 
ADD Precio DECIMAL(10, 2) NULL;


INSERT INTO Persona  (PrimerNombre, SegundoNombre,PrimerApellido, SegundoApellido, FechaDeNacimiento, Cui, Telefono, Genero)
VALUES  ('Keily', null, 'Lopez', 'Hernandez', '18-03-2002', '09072321839', '40338234', 'F'),
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
VALUES ('Casa Modelo Grande', 6, 400.00, 2, '', 1 ),
         ('Casa Modelo Mediana', 4, 250.00, 2, '', 1 ),
         ('Casa Modelo Pequeña', 3, 150.00, 1, '', 1 ),
         ('Apartamento Modelo A', 3, 120.00, 1, '', 1 ),
         ('Apartamento Modelo B', 2, 80.00, 1, '', 1 ),
         ('Apartamento Penthouse', 4, 200.00, 3, '', 1 ),
         ('Apartamento Estudio', 1, 50.00, 1, '', 1 ),
         ('Casa Sostenible', 3, 180.00, 2, '', 1 ),
         ('Casa Inteligente', 4, 240.00, 2, '', 1 ),
         ('Apartamento Loft', 2, 100.00, 1, '', 1 ),
         ('Apartamento Dúplex', 3, 150.00, 2, '', 1 ),
         ('Casa Tradicional', 4, 230.00, 2, '', 1 ),
         ('Casa Moderna', 5, 320.00, 2, '', 1 ),
         ('Apartamento Familiar', 3, 130.00, 1, '', 1 ),
         ('Apartamento Compacto', 2, 70.00, 1, '', 1 ),
         ('Casa Colonial', 4, 260.00, 2, '', 1 ),
         ('Casa Minimalista', 3, 200.00, 2, '', 1 ),
         ('Apartamento Ejecutivo', 2, 90.00, 1, '', 1 ),
         ('Apartamento Junior', 1, 60.00, 1, '', 1 ),
         ('Casa Ecológica', 3, 170.00, 2, '', 1 ),
         ('Apartamento Urbano', 2, 85.00, 1, '', 1 ),
         ('Apartamento Suburbano', 3, 110.00, 1, '', 1 ),
         ('Casa Vintage', 4, 250.00, 2, '', 1 );
   

GO
INSERT INTO Vivienda (NumeroVivienda, IdCluster, IdPropietario, IdTipoVivienda)
VALUES 
    (101, 1, 1, 1),
    (102, 1, 2, 13),
    (103, 1, 3, 16),
    (104, 1, 4, 12),
    (105, 1, 5, 1),
    (201, 2, 6, 2),
    (202, 2, 7, 8),
    (203, 2, 8, 17),
    (204, 2, 9, 23),
    (205, 2, 10, 2),
    (301, 3, 11, 3),
    (302, 3, 12, 20),
    (303, 3, 13, 3),
    (304, 3, 14, 17),
    (305, 3, 15, 20),
    (401, 4, 16, 5),
    (402, 4, 17, 7),
    (403, 4, 18, 4),
    (404, 4, 19, 10),
    (405, 4, 20, 11),
    (501, 4, 21, 14),
    (502, 4, 22, 15),
    (503, 4, 23, 18),
    (504, 4, 24, 19),
    (505, 4, 25, 6),
    (601, 5, 26, 9),
    (602, 5, 27, 8),
    (603, 5, 28, 17),
    (604, 5, 29, 21),
    (605, 5, 30, 22);

  GO  
INSERT INTO Propietario (IdPersona)
VALUES  (1),
        (2),
        (3),
        (4);
GO

INSERT INTO Residente (IdPersona, NumeroVivienda,IdCluster, Estado)
VALUES (1, 101, 1, 'Activo'),
       (2, 102, 1, 'Activo'),
       (3, 103, 1, 'Activo'),
       (4, 104, 1, 'Activo'),
       (5, 105, 1, 'Activo'),
       (6, 201, 2, 'Activo'),
       (7, 202, 2, 'Activo'),
       (8, 203, 2, 'Activo'),
       (9, 204, 2, 'Activo'),
       (10, 205, 2, 'Activo'),
       (11, 301, 3, 'Activo'),
       (12, 302, 3, 'Activo'),
       (13, 303, 3, 'Activo'),
       (14, 304, 3, 'Activo'),
       (15, 305, 3, 'Activo'),
       (16, 401, 4, 'Activo'),
       (17, 402, 4, 'Activo'),
       (18, 403, 4, 'Activo'),
       (19, 404, 4, 'Activo'),
       (20, 405, 4,'Activo'),
       (21, 501, 4,'Activo'),
       (22, 502, 4,'Activo'),
       (23, 503, 4,'Activo'),
       (24, 504, 4,'Activo'),
       (25, 505 ,4,'Activo'),
       (26 ,601 ,5,'Activo'),
       (27 ,602 ,5,'Activo'),
       (28 ,603 ,5,'Activo'),
       (29 ,604 ,5,'Activo'),
       (30 ,605 ,5,'Activo');