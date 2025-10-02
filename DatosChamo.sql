INSERT INTO Empleado (IdPersona) VALUES (1);
INSERT INTO Empleado (IdPersona) VALUES (2);
INSERT INTO Empleado (IdPersona) VALUES (3);
INSERT INTO Empleado (IdPersona) VALUES (4);
INSERT INTO Empleado (IdPersona) VALUES (5);
INSERT INTO Empleado (IdPersona) VALUES (6);
INSERT INTO Empleado (IdPersona) VALUES (7);
INSERT INTO Empleado (IdPersona) VALUES (8);
INSERT INTO Empleado (IdPersona) VALUES (9);
INSERT INTO Empleado (IdPersona) VALUES (10);
INSERT INTO Empleado (IdPersona) VALUES (11);
INSERT INTO Empleado (IdPersona) VALUES (12);
INSERT INTO Empleado (IdPersona) VALUES (13);
INSERT INTO Empleado (IdPersona) VALUES (14);
INSERT INTO Empleado (IdPersona) VALUES (15);
INSERT INTO Empleado (IdPersona) VALUES (16);
INSERT INTO Empleado (IdPersona) VALUES (17);
INSERT INTO Empleado (IdPersona) VALUES (18);
INSERT INTO Empleado (IdPersona) VALUES (19);
INSERT INTO Empleado (IdPersona) VALUES (20);


INSERT INTO PuestoTrabajo (Descripcion) VALUES 
('Gerente de Condominio'),
('Jefe de Seguridad'),
('Guardia de Seguridad'),
('Asistente Contable'),
('Supervisor Mantenimiento'),
('Tecnico Mantenimiento General'),
('Electricista'),
('Plomero'),
('Personal de Limpieza'),
('Jardinero'),
('Encargado de TI/Redes'),
('Delivery'),
('Encargado casa club'),
('Coordinador de eventos'),
('Recepcionista');

INSERT INTO ContratoTrabajo (FechaEmisionContrato, Estado, IdEmpleado, IdPuestoTrabajo) VALUES
('2025-04-05', 'Activo', 1, 1),   
('2025-04-20', 'Activo', 2, 2),  
('2025-01-15', 'Activo', 3, 3),   
('2025-02-01', 'Activo', 5, 3),   
('2025-02-15', 'Activo', 7, 3),  
('2025-03-01', 'Activo', 9, 3),   
('2025-03-10', 'Activo', 11, 3), 
('2025-03-20', 'Activo', 13, 3),  
('2025-05-10', 'Activo', 4, 4),   
('2025-05-15', 'Suspendido', 6, 5), 
('2025-06-01', 'Activo', 8, 6),   
('2025-06-20', 'Inactivo', 10, 7), 
('2025-07-05', 'Activo', 12, 8),  
('2025-07-25', 'Activo', 14, 9),  
('2025-08-10', 'Activo', 15, 10), 
('2025-08-25', 'Activo', 16, 11), -- 
('2025-09-01', 'Finalizado', 17, 12), 
('2025-09-15', 'Activo', 18, 13),
('2025-09-15', 'Activo', 19, 15),
('2025-09-15', 'Activo', 20, 6); 

INSERT INTO Turno (Descripcion, HoraInicio, HoraFin, IdPuestoTrabajo)
VALUES
('Turno Matutinu', '06:00', '13:00', 3), 
('Turno Vespertino', '13:00', '22:00', 3), 
('Turno Nocturno', '22:00', '06:00', 3), 
('Turno Jefe Seguridad', '08:00', '16:00', 2); 

INSERT INTO AsignacionTurno (FechaAsignacion, IdEmpleado, IdTurno) VALUES
-- Día 1
('2025-10-01', 3, 1), --guardia mañana
('2025-10-01', 5, 2), --guardia tarde
('2025-10-01', 7, 3), --guardia noche
('2025-10-01', 2, 4), --jefe
-- Día 2
('2025-10-02', 9, 1),
('2025-10-02', 11, 2),
('2025-10-02', 13, 3),
('2025-10-02', 2, 4),
-- Día 3
('2025-10-03', 5, 1),
('2025-10-03', 7, 2),
('2025-10-03', 9, 3),
('2025-10-03', 2, 4),
-- Día 4
('2025-10-04', 11, 1),
('2025-10-04', 13, 2),
('2025-10-04', 3, 3),
('2025-10-04', 2, 4),
-- Día 5
('2025-10-05', 7, 1),
('2025-10-05', 9, 2),
('2025-10-05', 11, 3),
('2025-10-05', 2, 4),
-- Día 6
('2025-10-06', 13, 1),
('2025-10-06', 3, 2),
('2025-10-06', 5, 3),
('2025-10-06', 2, 4),
-- Día 7
('2025-10-07', 9, 1),
('2025-10-07', 11, 2),
('2025-10-07', 13, 3),
('2025-10-07', 2, 4);

INSERT INTO Rondin (FechaInico, FechaFin, IdEmpleado)
VALUES
-- Día 1
('2025-10-01', '2025-10-01', 3),
('2025-10-01', '2025-10-01', 5),
('2025-10-01', '2025-10-01', 7),

-- Día 2
('2025-10-02', '2025-10-02', 9),
('2025-10-02', '2025-10-02', 11),
('2025-10-02', '2025-10-02', 13),

-- Día 3
('2025-10-03', '2025-10-03', 5),
('2025-10-03', '2025-10-03', 7),
('2025-10-03', '2025-10-03', 9),

-- Día 4
('2025-10-04', '2025-10-04', 11),
('2025-10-04', '2025-10-04', 13),
('2025-10-04', '2025-10-04', 3),

-- Día 5
('2025-10-05', '2025-10-05', 7),
('2025-10-05', '2025-10-05', 9),
('2025-10-05', '2025-10-05', 11),

-- Día 6
('2025-10-06', '2025-10-06', 13),
('2025-10-06', '2025-10-06', 3),
('2025-10-06', '2025-10-06', 5),

-- Día 7
('2025-10-07', '2025-10-07', 9),
('2025-10-07', '2025-10-07', 11),
('2025-10-07', '2025-10-07', 13);

INSERT INTO DetalleDelRondin (Hora, Lugar, IdRondin)
VALUES
-- Día 1 (Rondin 1-3)
('2025-10-01T08:00:00', 'Garita', 1),
('2025-10-01T09:00:00', 'Entrada Principal', 1),
('2025-10-01T10:00:00', 'Estacionamiento', 1),

('2025-10-01T14:00:00', 'Garita', 2),
('2025-10-01T15:00:00', 'Patio', 2),
('2025-10-01T16:00:00', 'Caseta', 2),

('2025-10-01T22:00:00', 'Garita', 3),
('2025-10-01T23:00:00', 'Puerta Trasera', 3),
('2025-10-02T00:00:00', 'Parqueo', 3),

-- Día 2 (Rondin 4-6)
('2025-10-02T08:00:00', 'Garita', 4),
('2025-10-02T09:00:00', 'Entrada Principal', 4),
('2025-10-02T10:00:00', 'Estacionamiento', 4),

('2025-10-02T14:00:00', 'Garita', 5),
('2025-10-02T15:00:00', 'Patio', 5),
('2025-10-02T16:00:00', 'Caseta', 5),

('2025-10-02T22:00:00', 'Garita', 6),
('2025-10-02T23:00:00', 'Puerta Trasera', 6),
('2025-10-03T00:00:00', 'Parqueo', 6),

-- Día 3 (Rondin 7-9)
('2025-10-03T08:00:00', 'Garita', 7),
('2025-10-03T09:00:00', 'Entrada Principal', 7),
('2025-10-03T10:00:00', 'Estacionamiento', 7),

('2025-10-03T14:00:00', 'Garita', 8),
('2025-10-03T15:00:00', 'Patio', 8),
('2025-10-03T16:00:00', 'Caseta', 8),

('2025-10-03T22:00:00', 'Garita', 9),
('2025-10-03T23:00:00', 'Puerta Trasera', 9),
('2025-10-04T00:00:00', 'Parqueo', 9),

-- Día 4 (Rondin 10-12)
('2025-10-04T08:00:00', 'Garita', 10),
('2025-10-04T09:00:00', 'Entrada Principal', 10),
('2025-10-04T10:00:00', 'Estacionamiento', 10),

('2025-10-04T14:00:00', 'Garita', 11),
('2025-10-04T15:00:00', 'Patio', 11),
('2025-10-04T16:00:00', 'Caseta', 11),

('2025-10-04T22:00:00', 'Garita', 12),
('2025-10-04T23:00:00', 'Puerta Trasera', 12),
('2025-10-05T00:00:00', 'Parqueo', 12),

-- Día 5 (Rondin 13-15)
('2025-10-05T08:00:00', 'Garita', 13),
('2025-10-05T09:00:00', 'Entrada Principal', 13),
('2025-10-05T10:00:00', 'Estacionamiento', 13),

('2025-10-05T14:00:00', 'Garita', 14),
('2025-10-05T15:00:00', 'Patio', 14),
('2025-10-05T16:00:00', 'Caseta', 14),

('2025-10-05T22:00:00', 'Garita', 15),
('2025-10-05T23:00:00', 'Puerta Trasera', 15),
('2025-10-06T00:00:00', 'Parqueo', 15),

-- Día 6 (Rondin 16-18)
('2025-10-06T08:00:00', 'Garita', 16),
('2025-10-06T09:00:00', 'Entrada Principal', 16),
('2025-10-06T10:00:00', 'Estacionamiento', 16),

('2025-10-06T14:00:00', 'Garita', 17),
('2025-10-06T15:00:00', 'Patio', 17),
('2025-10-06T16:00:00', 'Caseta', 17),

('2025-10-06T22:00:00', 'Garita', 18),
('2025-10-06T23:00:00', 'Puerta Trasera', 18),
('2025-10-07T00:00:00', 'Parqueo', 18),

-- Día 7 (Rondin 19-21)
('2025-10-07T08:00:00', 'Garita', 19),
('2025-10-07T09:00:00', 'Entrada Principal', 19),
('2025-10-07T10:00:00', 'Estacionamiento', 19),

('2025-10-07T14:00:00', 'Garita', 20),
('2025-10-07T15:00:00', 'Patio', 20),
('2025-10-07T16:00:00', 'Caseta', 20),

('2025-10-07T22:00:00', 'Garita', 21),
('2025-10-07T23:00:00', 'Puerta Trasera', 21),
('2025-10-08T00:00:00', 'Parqueo', 21);

EXEC sp_rename 'RegistroPersonasVisitantes.FechaRegistro', 'HoraRegistro', 'COLUMN';

ALTER TABLE RegistroPersonasVisitantes
ADD FechaRegistro DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE);

select * from RegistroPersonasVisitantes;

INSERT INTO RegistroPersonasVisitantes 
(TipoRegistro, FechaRegistro, HoraRegistro, TipoDocumento, NumeroDocumento, IdVisitante)
VALUES
-- Día 1: 2025-10-01
('Entrada', '2025-10-01', '08:15:00', 'DPI', '1234567890101', 1),
('Salida',  '2025-10-01', '09:30:00', 'DPI', '1234567890101', 1),

('Entrada', '2025-10-01', '10:00:00', 'Licencia', 'L9876543210', 2),
('Salida',  '2025-10-01', '11:15:00', 'Licencia', 'L9876543210', 2),

('Entrada', '2025-10-01', '14:20:00', 'DPI', '2233445566778', 3),
('Salida',  '2025-10-01', '15:45:00', 'DPI', '2233445566778', 3),

('Entrada', '2025-10-01', '16:00:00', 'Licencia', 'L1122334455', 4),
('Salida',  '2025-10-01', '17:30:00', 'Licencia', 'L1122334455', 4),

('Entrada', '2025-10-01', '18:10:00', 'DPI', '9988776655443', 5),
('Salida',  '2025-10-01', '19:40:00', 'DPI', '9988776655443', 5),

-- Día 2: 2025-10-02
('Entrada', '2025-10-02', '08:20:00', 'DPI', '1234567890101', 1),
('Salida',  '2025-10-02', '09:35:00', 'DPI', '1234567890101', 1),

('Entrada', '2025-10-02', '10:10:00', 'Licencia', 'L9876543210', 2),
('Salida',  '2025-10-02', '11:25:00', 'Licencia', 'L9876543210', 2),

('Entrada', '2025-10-02', '14:25:00', 'DPI', '2233445566778', 3),
('Salida',  '2025-10-02', '15:50:00', 'DPI', '2233445566778', 3),

('Entrada', '2025-10-02', '16:05:00', 'Licencia', 'L1122334455', 4),
('Salida',  '2025-10-02', '17:35:00', 'Licencia', 'L1122334455', 4),

('Entrada', '2025-10-02', '18:15:00', 'DPI', '9988776655443', 5),
('Salida',  '2025-10-02', '19:45:00', 'DPI', '9988776655443', 5),

-- Día 3: 2025-10-03
('Entrada', '2025-10-03', '08:25:00', 'DPI', '1234567890101', 1),
('Salida',  '2025-10-03', '09:40:00', 'DPI', '1234567890101', 1),

('Entrada', '2025-10-03', '10:15:00', 'Licencia', 'L9876543210', 2),
('Salida',  '2025-10-03', '11:30:00', 'Licencia', 'L9876543210', 2),

('Entrada', '2025-10-03', '14:30:00', 'DPI', '2233445566778', 3),
('Salida',  '2025-10-03', '15:55:00', 'DPI', '2233445566778', 3),

('Entrada', '2025-10-03', '16:10:00', 'Licencia', 'L1122334455', 4),
('Salida',  '2025-10-03', '17:40:00', 'Licencia', 'L1122334455', 4),

('Entrada', '2025-10-03', '18:20:00', 'DPI', '9988776655443', 5),
('Salida',  '2025-10-03', '19:50:00', 'DPI', '9988776655443', 5);









