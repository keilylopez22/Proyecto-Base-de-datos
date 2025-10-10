EXEC sp_rename 'RegistroPersonasVisitantes.FechaRegistro', 'HoraRegistro', 'COLUMN';

ALTER TABLE RegistroPersonasVisitantes
ADD FechaRegistro DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE);

ALTER TABLE RegistroPersonasVisitantes
DROP CONSTRAINT UQ__Registro__A42025881B8EB0E3;

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