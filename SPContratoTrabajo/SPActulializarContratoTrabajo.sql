CREATE OR ALTER PROCEDURE ActulializarContratoTrabajo
@IdNumeroContrato INT,
@FechaEmisionContrato DATE,
@Estado VARCHAR(20),
@IdEmpleado INT,
@IdPuestoTrabajo INT
AS 
BEGIN
UPDATE ContratoTrabajo
SET FechaEmisionContrato = @FechaEmisionContrato,
Estado = @Estado,
IdEmpleado = @IdEmpleado,
IdPuestoTrabajo = @IdPuestoTrabajo
WHERE IdNumeroContrato = @IdNumeroContrato;
END,

EXEC ActulializarContratoTrabajo
@IdNumeroContrato = 1,
@FechaEmisionContrato ='2025-12-01',
@Estado ='Inactivo',
@IdEmpleado = 1,
@IdPuestoTrabajo = 1