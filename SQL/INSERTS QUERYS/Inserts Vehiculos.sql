-- Marca
INSERT INTO Marca (Descripcion) VALUES 
('Toyota'),
('Honda'),
('Nissan'),
('Mazda'),
('Chevrolet'),
('Ford'),
('BMW'),
('Audi'),
('Mercedes-Benz'),
('Hyundai');

-- Linea
INSERT INTO Linea(Descripcion, IdMarca) VALUES 
('Corolla', 1),
('Civic', 2),
('Sentra', 3),
('CX-5', 4),
('Spark', 5),
('F-150', 6),
('Serie 3', 7),
('A4', 8),
('Clase C', 9),
('Elantra', 10);

-- Visitante
INSERT INTO Visitante (FechaEntrada, FechaSalida, TipoDocumento, NumeroDocumento, IdPersona, IdCluster, NumeroVivienda, IdGarita, IdEmpleado) 
VALUES
('2025-10-06 07:45:00', '2025-10-06 08:30:00', 'DPI',     'DPI-11112222333', 1, 1, 11, 1, 1),  

('2025-10-06 11:00:00', '2025-10-06 12:00:00', 'Licencia','LIC-L12345678',   2, 1, 13, 2, 2), 

('2025-10-06 14:00:00', '2025-10-06 15:30:00', 'DPI',     'DPI-22223333444', 3, 2, 26, 3, 3), 

('2025-10-06 17:00:00', NULL, 'Licencia','LIC-L98765432',   4, 2, 27, 4, 4), 

('2025-10-07 09:15:00', '2025-10-07 10:40:00', 'DPI',     'DPI-33334444555', 5, 3, 312, 5, 5),

('2025-10-07 15:30:00', NULL, 'Licencia','LIC-L11223344',   6, 3, 313, 6, 6),

('2025-10-08 08:00:00', '2025-10-08 09:30:00', 'DPI',     'DPI-44445555666', 7, 4, 416, 7, 7),

('2025-10-08 14:30:00', '2025-10-08 16:00:00', 'Licencia','LIC-L55667788',   8, 4, 417, 8, 8),

('2025-10-09 18:30:00', '2025-10-09 20:00:00', 'DPI',     'DPI-55556666777', 9, 5, 521, 9, 9),

('2025-10-10 06:00:00', '2025-10-10 07:00:00', 'Licencia','LIC-L99001122',   10, 5, 522, 10, 10);

-- Garita
INSERT INTO Garita (NombreGarita, IdCluster) VALUES 
('Principal Norte', 1),
('Secundaria Sur', 1),
('Principal Oeste', 2),
('Secundaria Este', 2),
('Entrada de Servicio', 1),
('Acceso 6', 3),
('Acceso 7', 3),
('Acceso 8', 4),
('Acceso 9', 4),
('Garita 10', 5);

-- Vehiculo
INSERT INTO Vehiculo (Placa, Modelo, IdLinea, IdMarca, IdResidente, IdVisitante) VALUES 
('P123ABC', 'Sedan', 1, 1, 1, 1),
('C456DEF', 'Coupe', 2, 2, 2, 2),
('M789GHI', 'SUV', 3, 3, 3, 3),
('F012JKL', 'PickUp', 4, 4, 4, 4),
('B345MNO', 'Hatchback', 5, 5, 5, 5),
('A678PQR', 'Sedan', 6, 6, 6, 6),
('T901STU', 'Coupe', 7, 7, 7, 7),
('R234VWX', 'SUV', 8, 8, 8, 8),
('L567YZA', 'Convertible', 9, 9, 9, 9),
('H890BCD', 'Minivan', 10, 10, 10, 10);

--RegistroVehiculos
INSERT INTO RegistroVehiculos (FechaHoraEntrada, FechaHoraSalida, Observaciones, IdGarita, IdVehiculo, IdVisitante, IdResidente) VALUES 
('2025-10-01 08:00:00', '2025-10-01 09:30:00', 'Visita a Lote 25', 1, 1, 1, 1),
('2025-10-01 10:15:00', '2025-10-01 11:45:00', 'Entrega de paquete', 2, 2, 2, 2),
('2025-10-01 14:00:00', '2025-10-01 16:00:00', 'Mantenimiento', 3, 3, 3, 3),
('2025-10-02 07:30:00', '2025-10-02 12:00:00', 'Cita con arquitecto', 4, 4, 4, 4),
('2025-10-02 17:00:00', '2025-10-02 17:45:00', 'Breve visita', 5, 5, 5, 5),
('2025-10-03 11:00:00', NULL, 'Dentro del cluster', 6, 6, 6, 6),
('2025-10-03 15:30:00', '2025-10-03 19:30:00', 'Visita familiar', 7, 7, 7, 7),
('2025-10-04 09:00:00', '2025-10-04 11:30:00', 'Servicio a domicilio', 8, 8, 8, 8),
('2025-10-04 18:30:00', '2025-10-04 22:00:00', 'Cena con amigos', 9, 9, 9, 9),
('2025-10-05 06:00:00', '2025-10-05 07:00:00', 'Entrega matutina', 10, 10, 10, 10);

--ListaNegra
INSERT INTO ListaNegra (Causa, FechaDeclaradoNoGrato, IdVehiculo, IdVisitante) VALUES 
('Incumplimiento de normas de vivienda', '2025-09-15', 2, 2),
('Problemas de comportamiento con la seguridad', '2025-09-20', 8, 8);

