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
INSERT INTO Visitante (IdPersona, IdCluster, NumeroVivienda) VALUES 
(1, 1, 11),    
(2, 1, 13),    
(3, 2, 26),     
(4, 2, 27),     
(5, 3, 312),   
(6, 3, 313),   
(7, 4, 416),   
(8, 4, 417),   
(9, 5, 521),   
(10, 5, 522);  

-- Garita
INSERT INTO Garita (NombreGarita, IdCluster, IdRegistroPersonaVisitante) VALUES 
('Principal Norte', 1, 3),
('Secundaria Sur', 1, 4),
('Principal Oeste', 2, 5),
('Secundaria Este', 2, 6),
('Entrada de Servicio', 1, 7),
('Acceso 6', 3, 8),
('Acceso 7', 3, 9),
('Acceso 8', 4, 10),
('Acceso 9', 4, 11),
('Garita 10', 5, 12);

-- ********** Tablas Con Dependencias Cruzadas **********

-- Vehiculo
INSERT INTO Vehiculo (IdVehiculo, Placa, Modelo, IdLinea, IdMarca, IdResidente, IdVisitante) VALUES 
(1, 'P123ABC', 'Sedan', 1, 1, 1, 1),
(2, 'C456DEF', 'Coupe', 2, 2, 2, 2),
(3, 'M789GHI', 'SUV', 3, 3, 3, 3),
(4, 'F012JKL', 'PickUp', 4, 4, 4, 4),
(5, 'B345MNO', 'Hatchback', 5, 5, 5, 5),
(6, 'A678PQR', 'Sedan', 6, 6, 6, 6),
(7, 'T901STU', 'Coupe', 7, 7, 7, 7),
(8, 'R234VWX', 'SUV', 8, 8, 8, 8),
(9, 'L567YZA', 'Convertible', 9, 9, 9, 9),
(10, 'H890BCD', 'Minivan', 10, 10, 10, 10);

--RegistroVehiculos
INSERT INTO RegistroVehiculos (IdRegistroVehiculo, FechaHoraEntrada, FechaHoraSalida, Observaciones, IdGarita, IdVehiculo, IdVisitante, IdResidente) VALUES 
(1, '2025-10-01 08:00:00', '2025-10-01 09:30:00', 'Visita a Lote 25', 1, 1, 1, 1),
(2, '2025-10-01 10:15:00', '2025-10-01 11:45:00', 'Entrega de paquete', 2, 2, 2, 2),
(3, '2025-10-01 14:00:00', '2025-10-01 16:00:00', 'Mantenimiento', 3, 3, 3, 3),
(4, '2025-10-02 07:30:00', '2025-10-02 12:00:00', 'Cita con arquitecto', 4, 4, 4, 4),
(5, '2025-10-02 17:00:00', '2025-10-02 17:45:00', 'Breve visita', 5, 5, 5, 5),
(6, '2025-10-03 11:00:00', NULL, 'Dentro del cluster', 6, 6, 6, 6),
(7, '2025-10-03 15:30:00', '2025-10-03 19:30:00', 'Visita familiar', 7, 7, 7, 7),
(8, '2025-10-04 09:00:00', '2025-10-04 11:30:00', 'Servicio a domicilio', 8, 8, 8, 8),
(9, '2025-10-04 18:30:00', '2025-10-04 22:00:00', 'Cena con amigos', 9, 9, 9, 9),
(10, '2025-10-05 06:00:00', '2025-10-05 07:00:00', 'Entrega matutina', 10, 10, 10, 10);

--L istaNegra
INSERT INTO ListaNegra (IdListaNegra, Causa, FechaDeclaradoNoGrato, IdVehiculo, IdVisitante) VALUES 
(1, 'Incumplimiento de normas de vivienda', '2025-09-15', 2, 2),
(2, 'Problemas de comportamiento con la seguridad', '2025-09-20', 8, 8);

