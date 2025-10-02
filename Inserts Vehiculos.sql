-- Marca
INSERT INTO Marca (IdMarca, Descripcion) VALUES 
(1, 'Toyota'),
(2, 'Honda'),
(3, 'Nissan'),
(4, 'Mazda'),
(5, 'Chevrolet'),
(6, 'Ford'),
(7, 'BMW'),
(8, 'Audi'),
(9, 'Mercedes-Benz'),
(10, 'Hyundai');

-- Linea
INSERT INTO Linea(IdLinea, Descripcin, IdMarca) VALUES 
(1, 'Corolla', 1),
(2, 'Civic', 2),
(3, 'Sentra', 3),
(4, 'CX-5', 4),
(5, 'Spark', 5),
(6, 'F-150', 6),
(7, 'Serie 3', 7),
(8, 'A4', 8),
(9, 'Clase C', 9),
(10, 'Elantra', 10);

-- Visitante
INSERT INTO Visitante (IdVisitante, IdPersona, IdCluster, NumeroVivienda) VALUES 
(1, 1, 1, 25),
(2, 2, 1, 58),
(3, 3, 2, 120),
(4, 4, 2, 205),
(5, 5, 3, 310),
(6, 6, 3, 15),
(7, 7, 4, 77),
(8, 8, 4, 190),
(9, 9, 5, 300),
(10, 10, 5, 45);

-- Garita
INSERT INTO Garita (IdGarita, NombreGarita, IdCluster, IdRegistroPersonaVisitante) VALUES 
(1, 'Principal Norte', 1, 1),
(2, 'Secundaria Sur', 1, 2),
(3, 'Principal Oeste', 2, 3),
(4, 'Secundaria Este', 2, 4),
(5, 'Entrada de Servicio', 1, 5),
(6, 'Acceso 6', 3, 6),
(7, 'Acceso 7', 3, 7),
(8, 'Acceso 8', 4, 8),
(9, 'Acceso 9', 4, 9),
(10, 'Garita 10', 5, 10);

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