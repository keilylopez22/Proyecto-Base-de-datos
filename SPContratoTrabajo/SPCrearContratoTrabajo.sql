CREATE OR ALTER PROCEDURE CrearContratoTrabajo 
@FechaEmisionContrato DATE,
@Estado VARCHAR(20),
@IdEmpleado INT,
@IdPuestoTrabajo INT
AS
BEGIN 
INSERT INTO ContratoTrabajo(FechaEmisionContrato, Estado, IdEmpleado, IdPuestoTrabajo)
VALUES (@FechaEmisionContrato, @Estado, @IdEmpleado,@IdPuestoTrabajo);
END

EXEC CrearContratoTrabajo
@FechaEmisionContrato = '2025-10-02',
@Estado = 'Activo',
@IdEmpleado = 21,
@IdPuestoTrabajo = 2
