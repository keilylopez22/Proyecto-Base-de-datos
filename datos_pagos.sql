INSERT INTO TipoPago(Descripcion)
VALUES  
		('Efectivo'),
		('Cheque'),
		('Deposito'),
		('Tarjeta de credito'),
		('Tarjeta de debito'),
		('Transferencia bancaria');
GO
INSERT INTO Servicio(Descripcion, Valor )
VALUES	
		('Servicio de agua', 210.00),
		('Servicio de jardineria y ornato',80.00),
		('Servicio de seguridad', 115.00),
		('Administracion',75.00 ); 
GO 
INSERT INTO Recibo (Fecha, ValorTotal, IdTipoPago, NumeroVivienda, IdCluster)
VALUES 
		('2024-03-01', 405.00, 1, 101, 1),
		('2024-03-02', 285.00, 2, 202, 2),
		('2024-03-03', 285.00, 3, 303, 3),
		('2024-03-04', 195.00, 4, 404, 4),
		('2024-03-05', 365.00, 5, 605, 5);
GO 
INSERT INTO Planilla (Descripcion, Fecha, IdRecibo)
VALUES 
		('Planilla mensual - Marzo 2024', '2024-03-10', 1),
		('Planilla mensual - Marzo 2024', '2024-03-10', 2),
		('Planilla mensual - Abril 2024', '2024-04-10', 3),
		('Planilla mensual - Abril 2024', '2024-04-10', 4),
		('Planilla mensual - Mayo 2024', '2024-05-10', 5);
GO
INSERT INTO DetallePlanilla (IdPlanilla, NumeroVivienda, IdCluster)
VALUES 
		(1, 101, 1),
		(2, 202, 2),
		(3, 303, 3),
		(4, 404, 4),
		(5, 605, 5);
GO 
INSERT INTO RequerimientoCobro (Fecha, IdServicio, NumeroVivienda, IdCluster)
VALUES 
		('2024-03-01', 1, 101, 1),
		('2024-03-01', 2, 101, 1),
		('2024-03-01', 3, 101, 1),
		('2024-03-02', 1, 202, 2),
		('2024-03-02', 4, 202, 2),
		('2024-03-03', 4, 303, 3),
		('2024-03-03', 1, 303, 3),
		('2024-03-04', 2, 404, 4),
		('2024-03-04', 3, 404, 4),
		('2024-03-05', 1, 605, 5),
		('2024-0 3-05', 2, 605, 5),
		('2024-03-05', 4, 605, 5);
GO
INSERT INTO DetalleServicio (Valor, IdRequerimientoC, IdRecibo)
VALUES 
		(210.00, 1, 1),
		(80.00, 2, 1),
		(115.00, 3, 1),
		(210.00, 4, 2),
		(75.00, 5, 2),
		(210.00, 6, 3),
		(75.00, 7, 3),
		(80.00, 8, 4),
		(115.00, 9, 4),
		(210.00, 10, 5),
		(80.00, 11, 5),
		(75.00, 12, 5);