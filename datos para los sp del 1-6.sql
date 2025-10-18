select * from Persona
select * from Propietario
select * from RegistroAccesos
select * from Residente
select * from Cluster
select * from Vivienda
select * from Residencial
select * from TipoVivienda
select * from Linea
select * from RegistroAccesos
select * from Empleado
select * from Vehiculo
select * from Marca
select * from Visitante

EXEC VehiculosPorVivienda
@IdCluster = 2, 
@NumeroVivienda= 202

EXEC VehiculosPorHora
@FechaInicio = '2024-01-01',
@FechaFin = '2024-10-14'

EXEC ReporteViviendas

EXEC VehiculosDePersonas 
@FechaInicio = '2025-10-14',
@FechaFin   = '2025-10-15'

EXEC VecinoPagoTiempo
@FechaInicio = '2025-10-12',
@FechaFin = '2025-10-13';

EXEC PropietariosCondomio

exec PSActualizarCluster
@IdCluster =1,
@Descripcion = 'Andalucia'

exec PSActualizarCluster
@IdCluster =2,
@Descripcion = 'Bernarda'

exec PSActualizarCluster
@IdCluster =3,
@Descripcion = 'Catalina'

exec PSActualizarCluster
@IdCluster =4,
@Descripcion = 'Diana I'

exec SPInsertarCluster
@Descripcion = 'Diana II',
@IdResidencial = 1

exec SPInsertarCluster
@Descripcion = 'Esmeranda II',
@IdResidencial = 1

INSERT INTO Persona (Cui, PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Telefono, Genero, FechaNacimiento)
VALUES
('10011234256459', 'Juan', 'Carlos', 'Pérez', 'Gómez', '5550001', 'M', '1998-05-15'),
('10458676523102', 'Ana', NULL, 'Ramírez', 'Lopez', '5550002', 'F', '2000-03-20'),
('10890652345603', 'Luis', 'Alberto', 'Martínez', 'López', '5550003', 'M', '1995-11-10'),
('10009674367254', 'Sofía', NULL, 'Hernández', 'Cruz', '5550004', 'F', '1999-07-08'),
('10009683625755', 'Carlos', 'Enrique', 'Ramos', 'Soto', '5550005', 'M', '1988-01-01');

INSERT INTO Cluster (Descripcion, IdResidencial)
VALUES ('Diana I', 1),
       ('Diana II', 1);
INSERT INTO Vivienda(NumeroVivienda, IdCluster, IdTipoVivienda,IdPropietario)
VALUES (2,4,2, 2),
	   (3,4,1,4),
	   (5,3,3,6),
	   (1,5,3,5),
	   (1,6,2,6);

INSERT INTO Residente (IdPersona, NumeroVivienda, IdCluster, EsInquilino, Estado)
VALUES
(22, 2, 4,1,'ACTIVO'),
(23, 3, 4,0, 'ACTIVO'),
(24, 5, 3,0,'ACTIVO'),
(25, 1, 5,1, 'ACTIVO'),
(26, 1, 6,1,'ACTIVO');

INSERT INTO RegistroAccesos (FechaIngreso, FechaSalida, Observaciones,  IdVehiculo, IdGarita, IdVisitante, IdResidente, IdEmpleado
)
VALUES
('2025-10-14 23:30:00', '2025-10-15 00:10:00', 'Ingreso nocturno', 1,  1, 1, 1, 1),
('2025-10-15 00:20:00', '2025-10-15 01:05:00', 'Ingreso después de medianoche', 2,  1, 3, 23, 1), 
('2025-10-15 01:00:00', '2025-10-15 01:40:00', 'Ingreso temprano', 3,  1, 4, 22, 1), 
('2025-10-15 02:00:00', '2025-10-15 02:30:00', 'Ingreso por la madrugada', 4,  1, 5, 13, 1), 
('2025-10-15 22:45:00', '2025-10-15 06:10:00', 'Ingreso en la tarde noche ', 5, 1, 2, 15, 1);

ALTER TABLE Persona  ADD EstadoCivil VARCHAR (15);
GO
UPDATE Persona
SET EstadoCivil = CASE IdPersona
    WHEN 1 THEN 'Soltera'
    WHEN 2 THEN 'Casado'
    WHEN 3 THEN 'Soltera'
    WHEN 4 THEN 'Casado'
    WHEN 5 THEN 'Casada'
    WHEN 6 THEN 'Soltero'
    WHEN 7 THEN 'Casado'
    WHEN 8 THEN 'Casado'
    WHEN 9 THEN 'Soltero'
    WHEN 10 THEN 'Soltero'
    WHEN 11 THEN 'Casado'
    WHEN 12 THEN 'Casado'
    WHEN 13 THEN 'Soltero'
    WHEN 14 THEN 'Casada'
    WHEN 15 THEN 'Casado'
    WHEN 16 THEN 'Soltero'
    WHEN 17 THEN 'Soltera'
    WHEN 18 THEN 'Casada'
    WHEN 19 THEN 'Soltera'
    WHEN 20 THEN 'Soltera'
    WHEN 22 THEN 'Casado'
    WHEN 23 THEN 'Casada'
    WHEN 24 THEN 'Soltero'
    WHEN 25 THEN 'Casada'
    WHEN 26 THEN 'Casado'
    WHEN 27 THEN 'Soltero'
    WHEN 28 THEN 'Soltero'
    WHEN 29 THEN 'Casado'
END
WHERE IdPersona IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,22,23,24,25,26,27,28,29);

GO

